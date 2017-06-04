#!/bin/sh
# Run the local client and connect to CrashPlan running on home-nas.local

uiinfo=.ui_info.piglet_local

# Fix up .ui_info
cd /Library/Application\ Support/CrashPlan
if [ ! -L .ui_info ]; then
	echo ERROR - $(pwd)/.ui_info should be a sym link
	exit 1
fi

if [ ! -f $uiinfo ]; then
	echo ERROR - crashPlan running in Docker in NAS requires the file: $uiinfo
	exit 2
fi

sudo rm .ui_info
sudo ln -s $uiinfo .ui_info

# Create ssh port forwarding - not needed for local Crashplan

# Start the app
/Applications/CrashPlan.app/Contents/MacOS/CrashPlan



