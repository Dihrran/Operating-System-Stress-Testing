#!/bin/bash
# Name: Zhang Hejunjie
# Student ID: 0137675
# Assign OS investigation area: Everything is combined (fallocate + file + fsync + dir)

everything()
{
OUTPUT="EverythingCombined_results" # create file first to store all the result
mkdir -p $OUTPUT
echo "Everything combined test & result: " > $OUTPUT/results.txt
echo "Test is starting, please wait for a while" # output goes to the screen

# For Idle state
printf "\n" >> $OUTPUT/results.txt
echo "Start time: $(date)" >> $OUTPUT/results.txt 
echo "Testing with idle state:......"
printf "\n" >> $OUTPUT/results.txt 
printf  "Idle state:\n" >> $OUTPUT/results.txt

# test start
# measure every 1 second, do this 60 times
iostat -x 1 5 >> $OUTPUT/results.txt  #observe the disk
vmstat 1 5 >> $OUTPUT/results.txt  #observe the system
printf "\n" >> $OUTPUT/results.txt 
echo "End time: $(date)" >> $OUTPUT/results.txt
echo "Sucessful! Idle state now is recorded."

# Low stress test  — 4 workers
printf "\n" >> $OUTPUT/results.txt 
echo "Start time: $(date)" >> $OUTPUT/results.txt
echo "Low stress test & result: " >> $OUTPUT/results.txt

# Start collect stats in background (# measure every 1 second, do this 60 times)
iostat -x 1 60 >> $OUTPUT/low_iostat.txt &
vmstat 1 60 >> $OUTPUT/low_vmstat.txt &

# Run stress test (my version of stress-ng doesn't have --fsync, it rename to --sync-file)
stress-ng --fallocate 4 --filename 4 --sync-file 4 --dir 4 --timeout 60s --metrics-brief >> $OUTPUT/results.txt
wait #wait until all the process complete
echo "End time: $(date)" >> $OUTPUT/results.txt
echo "Congratulation! Low stress test complete."

# Recovery — 60 seconds
echo "Recovering... waiting 60 seconds"
sleep 60
echo "Recovery complete."

# Medium stress test  — 16 workers
printf "\n" >> $OUTPUT/results.txt 
echo "Start time: $(date)" >> $OUTPUT/results.txt
echo "Medium stress test & result: " >> $OUTPUT/results.txt

# Start collect stats in background (# measure every 1 second, do this 60 times)
iostat -x 1 60 >> $OUTPUT/medium_iostat.txt &
vmstat 1 60 >> $OUTPUT/medium_vmstat.txt &

# Run stress test
stress-ng --fallocate 16 --filename 16 --sync-file 16 --dir 16 --timeout 60s --metrics-brief >> $OUTPUT/results.txt
wait #wait until all the process complete
echo "End time: $(date)" >> $OUTPUT/results.txt
echo "Congratulation! Medium stress test complete."

# Recovery  — 60 seconds
echo "Recovering... waiting 60 seconds"
sleep 60
echo "Recovery complete."

# High stress test  — 64 workers
printf "\n" >> $OUTPUT/results.txt 
echo "Start time: $(date)" >> $OUTPUT/results.txt
echo "High stress test & result: " >> $OUTPUT/results.txt

# Start collect stats in background (# measure every 1 second, do this 60 times)
iostat -x 1 60 >> $OUTPUT/high_iostat.txt &
vmstat 1 60 >> $OUTPUT/high_vmstat.txt &

# Run stress test
stress-ng --fallocate 64 --filename 64 --sync-file 64 --dir 64 --timeout 60s --metrics-brief >> $OUTPUT/results.txt
wait #wait until all the process complete
echo "End time: $(date)" >> $OUTPUT/results.txt
echo "Congratulation! High stress test complete."

# SUMMARY
printf "\n" >> $OUTPUT/results.txt 
echo "Test Summary:" >> $OUTPUT/results.txt
echo "End time: $(date)" >> $OUTPUT/results.txt
echo "All results saved in: EverythingCombined_results "

# Save system logs
echo "Saving system logs..."
journalctl --since "30 minutes ago" >> $OUTPUT/system_logs.txt
echo "System logs saved."
echo "All results saved in: EverythingCombined_results/results.txt & system_logs.txt"
echo "Finish all the test"
}
