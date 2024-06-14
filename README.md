# SYSTEM-HEALTH-MONITORING
system metrics collection this program used to monitor system usage regularly like cpu,disk,memory and networking this monitoring program is written in shell scripting
variable:
#!/bin/bash

This line is called as shebang constructor specifies that the script should be run using the bash shell.

variable used:
LOG_FILE: The file where system health logs will be stored.
PID_FILE: A file to store the process ID (PID) of the running monitoring script, used to ensure only one instance runs at a time.
THRESHOLD_CPU, THRESHOLD_MEM, THRESHOLD_DISK: Threshold values for CPU, memory, and disk usage percentages, respectively.
INTERVAL: The time interval (in seconds) between each system health check.


function which are contributed in the program formation are mention below
1)start function:
Checks if the monitoring script is already running by looking for the PID file.
If the PID file exists, it exits with a message.
If not, it starts the monitoring process, saves its PID to the PID file, and enters an infinite loop to check system health at regular intervals.



2)stop function:
Checks if the monitoring script is running by looking for the PID file.
If the PID file does not exist, it exits with a message.
If the PID file exists, it stops the monitoring process by killing the process ID stored in the PID file and then removes the PID file.


3)status function:
Checks if the monitoring script is running by looking for the PID file and prints the corresponding status message.



4)system health monitoringing function:
Captures the current timestamp.
Retrieves the current CPU usage and checks if it exceeds the threshold, setting a warning message if it does.
Retrieves the current memory usage and checks if it exceeds the threshold, setting a warning message if it does.
Retrieves the current disk usage and checks if it exceeds the threshold, setting a warning message if it does.
Checks network connectivity by pinging google.com. Sets a warning message if there is no connectivity.
Logs the system status and any warning messages to the log file.

use cases:
it use to provide command to the shell file in the terminal to control the program flow like start,stop and to get the status of the system while running the program for monitoing continously in an infinite loop

HOW TO CREATE AND RUN THE SHELL FILE TO GET THE SYSTEM SYSTEM MONITOR REPORT:
use any editor like vim and make text file by .sh extension like system_monitor.sh
after creating the file make it executable by using command like "sudo chmod +x system_monitor.sh"
For running the file to get the system usage use the command "sudo ./system_health start" where start is the command line to shell scripting
Note: sudo has been used to get the super user permission to get the system metric from the system log with sudo it may not work as desire
