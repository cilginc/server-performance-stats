#!/bin/bash

# Function to calculate CPU usage
total_cpu_usage() {
    top -bn1 | grep "Cpu(s)" | \
        awk '{usage = 100 - $8; printf "Total CPU Usage: %.2f%%\n", usage}'
}

# Function to calculate memory usage
memory_usage() {
    free -m | awk 'NR==2{printf "Memory Usage: Used: %sMB, Free: %sMB, Usage: %.2f%%\n", $3, $4, $3*100/($3+$4)}'
}

# Function to calculate disk usage
disk_usage() {
    df -h --total | awk '/total/{printf "Disk Usage: Used: %s, Free: %s, Usage: %s\n", $3, $4, $5}'
}

# Function to list top 5 processes by CPU usage
top_processes_by_cpu() {
    echo "=========== Top 5 Processes by CPU Usage ===========:"
    ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | awk 'NR>1 {printf "PID: %s, Command: %s, CPU Usage: %.2f%%\n", $1, $2, $3}'
}

# Function to list top 5 processes by memory usage
top_processes_by_memory() {
    echo "=========== Top 5 Processes by Memory Usage ===========:"
    ps -eo pid,comm,%mem --sort=-%mem | head -n 6 | awk 'NR>1 {printf "PID: %s, Command: %s, Memory Usage: %.2f%%\n", $1, $2, $3}'
}

# Optional: Additional system stats
extra_stats() {
    echo "============= Extra Stats =============="
    echo "OS Version: $(cat /etc/os-release | grep -w PRETTY_NAME | cut -d= -f2 | tr -d '\"')"
    echo "Uptime: $(uptime -p)"
    echo "Load Average: $(uptime | awk -F 'load average:' '{print $2}' | xargs)"
    echo "Logged in Users: $(who | wc -l)"
    echo "Failed Login Attempts: $(grep 'Failed password' /var/log/auth.log 2>/dev/null | wc -l)"
}

# Main script execution
echo "============= Server Performance Stats ============="
total_cpu_usage
memory_usage
disk_usage

echo
top_processes_by_cpu

echo
top_processes_by_memory

echo
extra_stats