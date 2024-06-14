#!/bin/bash

LOG_FILE="/var/log/system_health.log"
PID_FILE="/var/run/system_health_monitor.pid"
THRESHOLD_CPU=80
THRESHOLD_MEM=80
THRESHOLD_DISK=80
INTERVAL=60

start_monitoring() {
    if [ -f $PID_FILE ]; then
        echo "Monitoring is already running."
        exit 1
    fi

    echo "Starting system health monitoring..."
    echo $$ > $PID_FILE

    while true; do
        check_system_health
        sleep $INTERVAL
    done
}

stop_monitoring() {
    if [ ! -f $PID_FILE ]; then
        echo "Monitoring is not running."
        exit 1
    fi

    echo "Stopping system health monitoring..."
    kill -9 $(cat $PID_FILE)
    rm -f $PID_FILE
    echo "Monitoring stopped."
}

status_monitoring() {
    if [ -f $PID_FILE ]; then
        echo "Monitoring is running."
    else
        echo "Monitoring is not running."
    fi
}

check_system_health() {
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

    # CPU usage
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    CPU_WARNING=""
    if (( $(echo "$CPU_USAGE > $THRESHOLD_CPU" | bc -l) )); then
        CPU_WARNING="Warning: High CPU usage - $CPU_USAGE%"
    fi

    # Memory usage
    MEM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    MEM_WARNING=""
    if (( $(echo "$MEM_USAGE > $THRESHOLD_MEM" | bc -l) )); then
        MEM_WARNING="Warning: High memory usage - $MEM_USAGE%"
    fi

    # Disk usage
    DISK_USAGE=$(df / | grep / | awk '{ print $5}' | sed 's/%//g')
    DISK_WARNING=""
    if [ $DISK_USAGE -gt $THRESHOLD_DISK ]; then
        DISK_WARNING="Warning: High disk usage - $DISK_USAGE%"
    fi

    # Network connectivity
    PING_RESULT=$(ping -c 1 google.com &> /dev/null && echo "Connected" || echo "Disconnected")
    NET_WARNING=""
    if [ "$PING_RESULT" = "Disconnected" ]; then
        NET_WARNING="Warning: Network connectivity issue"
    fi

    # Log the status
    echo "$TIMESTAMP - CPU: $CPU_USAGE%, MEM: $MEM_USAGE%, DISK: $DISK_USAGE%, NET: $PING_RESULT" >> $LOG_FILE
    [ ! -z "$CPU_WARNING" ] && echo "$TIMESTAMP - $CPU_WARNING" >> $LOG_FILE
    [ ! -z "$MEM_WARNING" ] && echo "$TIMESTAMP - $MEM_WARNING" >> $LOG_FILE
    [ ! -z "$DISK_WARNING" ] && echo "$TIMESTAMP - $DISK_WARNING" >> $LOG_FILE
    [ ! -z "$NET_WARNING" ] && echo "$TIMESTAMP - $NET_WARNING" >> $LOG_FILE
}

case "$1" in
    start)
        start_monitoring
        ;;
    stop)
        stop_monitoring
        ;;
    status)
        status_monitoring
        ;;
    *)
        echo "Usage: $0 {start|stop|status}"
        exit 1
        ;;
esac

