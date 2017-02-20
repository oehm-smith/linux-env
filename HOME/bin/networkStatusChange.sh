#!/bin/bash

# 2017-01-12 - Like networkUpDown.sh, created at GA in response to the network always dropping out.
# This is a variant that only prints out when there is a change rather than every x seconds.
# Speaking to - tony.patos@ga.gov.au / 02 6249 3460.

count=0
while true;
do
	lastStat=0
	ping -c 1 8.8.8.8 > /tmp/ping
	err=$?
    	if [ $err != 0 ]; then
		echo ------------------
		date
		echo ping status $err
		cat /tmp/ping
		say f
		count=0
	else
		if [ $count -eq 0 ]; then
			echo ------------------
			date
			echo ping status $err
			count=$(expr $count + 1)
			say n
		fi
    	fi
done
