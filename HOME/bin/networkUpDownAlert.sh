#!/bin/bash

# 2017-01-05 - created at GA in response to the network always dropping out.
# Since rebooting I haven't seen this problem.  Tony said to contact him if it
# starts up again - tony.patos@ga.gov.au / 02 6249 3460.

while true;
do
	echo ------------------
	date
	ping -c 1 google.com
	err=$?
	echo ping status $err
    	if [ $err != 0 ]; then
		say No Network
    	fi
    	sleep 10
done
