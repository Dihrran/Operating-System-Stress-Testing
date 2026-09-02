#!/bin/bash
mkdir -p logs
LOG_FILE="logs/log_churn_log.txt"
levels=("Low" "Medium" "High")
apache_load=(10 50 100)
mariadb_load=(5 25 50)
FALLOCATE_WORKERS=1
FILE_WORKERS=1
RECOVERY_TIME=60
log()
{
    echo "$1"
    echo "$1" >> "$LOG_FILE"
}
read_duration()
{
    read -p "Enter test duration (10-300 seconds): " duration
    while [[ ! "$duration" =~ ^[0-9]+$ ]] || [ "$duration" -lt 10 ] || [ "$duration" -gt 300 ]
    do
        echo "Invalid input."
        read -p "Enter test duration (10-300 seconds): " duration
    done
}
run_test()
{
    echo ""
    echo "Large Media Upload and Log Churn Experiment"

    echo "" >> "$LOG_FILE"
    echo "Experiment Time : $(date)" >> "$LOG_FILE"

    for i in "${!levels[@]}"
    do
        echo ""

        log "Stress Level : ${levels[$i]}"
        log "Apache Requests : ${apache_load[$i]}"
        log "MariaDB Threads : ${mariadb_load[$i]}"
        log "Fallocate Workers : $FALLOCATE_WORKERS"
        log "File Workers : $FILE_WORKERS"

        log "iostat before test"
        iostat -x 1 1 | tee -a "$LOG_FILE"

        log "Running file workload..."

        (
            while true
            do
                echo "$(date) Media upload log entry" >> "$LOG_FILE"
                sleep 0.2
            done
        ) &
        LOG_PID=$!

        stress-ng \
            --fallocate "$FALLOCATE_WORKERS" \
            --timeout "${duration}"s \
            --metrics-brief | tee -a "$LOG_FILE"

        kill $LOG_PID

        log "iostat after test"
        iostat -x 1 1 | tee -a "$LOG_FILE"

        echo ""
        echo "Recovery for $RECOVERY_TIME seconds"

        sleep $RECOVERY_TIME
    done

    echo ""
    echo "Experiment completed."
    echo "Log saved to $LOG_FILE"
}
show_log()
{
    echo ""
    if [ -f "$LOG_FILE" ]
    then
        cat "$LOG_FILE"
    else
        echo "No log file found."
    fi
}

largeMetadata()
{
while true
do
    echo ""
    echo "I/O Performance Investigation Tool"
    echo ""
    echo "1. Run Large Media Upload and Log Churn"
    echo "2. View Log"
    echo "3. Exit"
    read -p "Choose: " choice
    case $choice in
        1)
            read_duration
            run_test
            ;;
        2)
            show_log
            ;;
        3)
            echo "Program end."
            break
            ;;
        *)
            echo "Error option."
            ;;
    esac
done
}
