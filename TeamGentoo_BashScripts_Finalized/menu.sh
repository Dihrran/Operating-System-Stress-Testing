#!/bin/bash

#importing function:
source ./dir_test.sh
source ./dir_file_test.sh
source ./file_allocation.sh
source ./CombineEverything.sh
source ./FileIO.sh
source ./fsync.sh
source ./IO_latency.sh
source ./large.sh

while true
do

echo "===================================="
echo "Please select option"
echo "===================================="
echo "1. Set up firewall + Node Exporter"
echo "2. Directory Stress Test"
echo "3. Directory + File Stress Test"
echo "4. File allocation Stress Test"
echo "5. File IO Stress Test"
echo "6. Flushes data to memory Stress Test"
echo "7. Large metadata + log churn Stress Test"
echo "8. I/O Latency + persistence guarantee Stress Test"
echo "9. Everything is combined Stress Test"
echo "0. Exit"
echo "99. Kill Process for node exporter."

read -p "Enter your choice: " choice

case $choice in
 1)
 echo "Opening Port: "

#set up firewall
sudo firewall-cmd --add-port=9100/tcp --permanent
sudo firewall-cmd --add-service=http --permanent
sudo firewall-cmd --add-service=mysql --permanent
sudo firewall-cmd --reload

#set up Node Exporter
cd /home/dihrran/node_exporter-1.8.1.linux-amd64
nohup ./node_exporter --web.listen-address=":9100" & disown 

;;
 2)
option_directory
 ;;
3)
option_directory_file
;;
4)
option_file_allocation
;;
5)
FileIO
;;
6)
stress_flush
;;
7)
largeMetadata
;;
8)
file_latency
;;
9)
everything
;;
 0)
 echo "Exiting program..."
 exit 0
 ;;
99)
echo "Kill Node Exporter Process: "
ps aux | grep node
read -p "Enter PID to kill: " pid
kill $pid
;;
 *)
 echo "Invalid menu option."
 ;;
esac
done


