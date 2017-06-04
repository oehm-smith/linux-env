#!/bin/sh
# Run the local client and connect to CrashPlan running on home-nas.local

# Fix up .ui_info
cd /Library/Application\ Support/CrashPlan
if [ ! -L .ui_info ]; then
	echo ERROR - $(pwd)/.ui_info should be a sym link
	exit 1
fi

if [ ! -f .ui_info.nasViaPigletSSH ]; then
	echo ERROR - crashPlan running in Docker in NAS requires the file: .ui_info.nasViaPigletSSH
	exit 2
fi

sudo rm .ui_info
sudo ln -s .ui_info.nasViaPigletSSH .ui_info

# Create ssh port forwarding
# See https://support.code42.com/CrashPlan/4/Configuring/Using_CrashPlan_On_A_Headless_Computer#Alternative_Port_Forwarding_Options
# The file .ui_info.nasViaPigletSSH specifies port 4200 on localhost

# to run manually - ssh -L 4200:localhost:4243 -p 22221 root@home-nas.local
ssh -f -N -T -M -L 4200:localhost:4243 nas-crashplan-proxy

# Start the app
/Applications/CrashPlan.app/Contents/MacOS/CrashPlan

# Stop the ssh forwarding when the app exits
ssh -T -O "exit" nas-crashplan-proxy


