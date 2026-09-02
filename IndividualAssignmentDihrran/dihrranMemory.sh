#!/bin/bash

#Dihrran Chong Yun Siong
#0139028
#Investigation Area:  Memory Management 
#Workload Type: Memory-intensive
#Experimental variable: ulimit 256MB
#Observation Source: vmstat

while true
do
# testing different workload with different numbers of workers to see the difference
echo "1. Start Testing 2x 128MB"
echo "2. Start Testing 2x 180MB"
echo "3. Start Testing 1x 256MB"
echo "4. View vmstat.log"
echo "5. View workload.log"
echo "99. Exit"

read -p "Enter choice: " choice

case $choice in
1)

echo "---experiment for 2x 128MB load---"
echo "---APPLYNG ULIMIT 256MB---"
ulimit -v 262144

echo "---STARTING VMSTAT MONITORING---"
vmstat 1 30 | while read line; do
# prints the timestamp to observe the behavior as time goes
echo "$(date '+[%Y-%m-%d %H:%M:%S]') $line"
#save the output to vmstat.log and run in the background
done > vmstat.log &
VMSTAT_PID=$!

# --- Run workload --- first test by generating 128mb x 2 of allocation (just enough for the vm)
echo "---RUNNING MEMORY INTENSIVE WORKLOAD---"
stress-ng --vm 2 --vm-bytes 128M --timeout 30s 2>&1 | while read line; do
echo "$(date '+[%Y-%m-%d %H:%M:%S]') $line"
done > workload.log

# --- Cleanup ---
wait $VMSTAT_PID
echo "EXPERIMENT COMPLETED"
echo "Logs saved in vmstat.log for monitoring and in workload.log for workload"
;;

2) 
echo "---experiment for 2x 180MB load---"
echo "---APPLYNG ULIMIT 256MB---"
ulimit -v 262144

echo "---STARTING VMSTAT MONITORING---"
vmstat 1 30 | while read line; do
echo "$(date '+[%Y-%m-%d %H:%M:%S]') $line"
done > vmstat.log &
VMSTAT_PID=$!

# --- Run workload --- Next test by allocate beyond vm memory limit to see how bad the result
echo "---RUNNING MEMORY INTENSIVE WORKLOAD---"
stress-ng --vm 2 --vm-bytes 180M --timeout 30s 2>&1 | while read line; do
echo "$(date '+[%Y-%m-%d %H:%M:%S]') $line"
done > workload.log

# --- Cleanup ---
wait $VMSTAT_PID
echo "EXPERIMENT COMPLETED"
echo "Logs saved in vmstat.log for monitoring and in workload.log for workload"
;;

3) 
echo "---experiment for 1x 256MB load---"
echo "---APPLYNG ULIMIT 256MB---"
ulimit -v 262144

echo "---STARTING VMSTAT MONITORING---"
vmstat 1 30 | while read line; do
echo "$(date '+[%Y-%m-%d %H:%M:%S]') $line"
done > vmstat.log &
VMSTAT_PID=$!

# --- Run workload --- lastly applying just enough load but use only1 worker
echo "---RUNNING MEMORY INTENSIVE WORKLOAD---"
stress-ng --vm 1 --vm-bytes 256M --timeout 30s 2>&1 | while read line; do
echo "$(date '+[%Y-%m-%d %H:%M:%S]') $line"
done > workload.log

# --- Cleanup ---
wait $VMSTAT_PID
echo "EXPERIMENT COMPLETED"
echo "Logs saved in vmstat.log for monitoring and in workload.log for workload"
;;

4) 
cat vmstat.log
;;

5)
cat workload.log
;;

99)
exit 0
;;

*)
echo "Invalid option"
;;

esac

done
