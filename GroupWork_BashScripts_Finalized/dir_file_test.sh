#!/bin/bash

#Dihrran Chong Yun Siong
#0139028
#Purpose: stress directory operation using stress-ng --dir and --file

dir_file_stress_low (){
echo " "
echo "LOW STRESS TEST FOR DIRECTORY --dir and --fallocate"
stress-ng --dir 4 --fallocate 4 --timeout 60s --metrics-brief --temp-path /var/www/html/dummydirectory >> system_log.txt
echo "FINIHSED LOW STRESS TEST FOR DIRECTORY --dir" | tee -a system_log.txt 
echo " "
}

dir_file_stress_medium (){
echo " "
echo "MEDIUM STRESS TEST FOR DIRECTORY --dir and --fallocate"
stress-ng --dir 24 --fallocate 16 --timeout 60s --metrics-brief --temp-path /var/www/html/dummydirectory >> system_log.txt
echo "FINIHSED MEDIUM STRESS TEST FOR DIRECTORY --dir" | tee -a system_log.txt 
echo " "
}

dir_file_stress_high (){
echo " "
echo "HIGH STRESS TEST FOR DIRECTORY --dir and --fallocate"
stress-ng --dir 80 --fallocate 64 --timeout 60s --metrics-brief --temp-path /var/www/html/dummydirectory >> system_log.txt
echo "FINIHSED HIGH STRESS TEST FOR DIRECTORY --dir" | tee -a system_log.txt 
echo " "
}
option_directory_file (){
while true 
do
echo "Directory + File Stress Test"
echo "1. Low Directory + File Stress Test"
echo "2. Medium Directory + File Stress Test"
echo "3. High Directory + File Stress Test"
echo "4. Back to main menu" 
read -p "Enter your choice: " stress_choice
case $stress_choice in
1)
dir_file_stress_low
;;
2)
dir_file_stress_medium
;;
3)
dir_file_stress_high
;;
4)
echo "back to main menu"
break
;;
*)
echo "Invalid Option"
;;
esac
done
}
