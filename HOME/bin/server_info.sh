#!/usr/bin/env bash

# From https://gist.githubusercontent.com/MohamedAlaa/58206c8ba8e3e8510496/raw/547c8fe0cd05fef33547dac8926bb8c58ed0ced7/server.sh

echo "--------------------------------------------------------------------------------"
uname -a
echo "--------------------------------------------------------------------------------"
MEMORY=`/usr/sbin/system_profiler -detailLevel full SPHardwareDataType | grep 'Memory' | awk '{print $1 $2 $3}'`
echo "$MEMORY"
echo "--------------------------------------------------------------------------------"
CORES_COUNT=`sysctl hw.ncpu | awk '{print $2}'`
echo "CPU"
sysctl -n machdep.cpu.brand_string
echo "$CORES_COUNT Cores"
echo "--------------------------------------------------------------------------------"
df -h
echo "--------------------------------------------------------------------------------"
echo Local IPs
ifconfig | grep 'inet ' | awk '{print $2}' | sed 's/addr:/ - /g'
echo "--------------------------------------------------------------------------------"
SERVER_NAME=`hostname`
echo "SERVER INFO: $SERVER_NAME"
echo "SERVER ROLE: solo"
echo "GEM_HOME:    $GEM_HOME"
echo "--------------------------------------------------------------------------------"
