#!/bin/bash

echo "==== System Monitoring Script ===="
echo "Date: $(date)"
echo

# CPU Usage
echo "== CPU Usage =="
top -b -n 1 | grep "Cpu(s)" | awk '{print "CPU Usage: " $2+$4 "%"}'
echo

# Memory Usage
echo "== Memory Stats =="
free -h | awk '/Mem/{print "Total: "$2", Used: "$3", Free: "$4}'
echo

# Disk Usage
echo "== Disk Usage =="
df -h --total | awk '/total/{print "Total Disk: "$2", Used: "$3", Free: "$4}'
echo

# Network Stats
echo "== Network Stats =="
echo "Active Connections: $(ss -tun | wc -l)"
echo

# Top 5 Processes
echo "== Top Processes =="
ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 6
