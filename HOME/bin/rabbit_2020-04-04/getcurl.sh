#!/bin/bash
# File: getcurl.sh
# Args:
#		$1 - URL to get
#		[$2 - optional name of page retrieved] else goes to STDOUT

if [ $# -lt 1 ]; then
	echo Usage $0: URL OPTIONAL_Page_name
fi

#PROXY="165.228.133.10:3128"
#PROXY="63.149.98.78:80"
#PROXY="220.231.124.5:8080"
PROXY="63.149.98.64:80"

if [ $# -eq 2 ]; then
	#CMD="curl -v -x $PROXY $1"# > $2"
	echo curl -# -v -x $PROXY $1 outto $2
	`curl -# -v -x $PROXY $1> $2`
else
	#CMD="curl -v -x $PROXY $1"# > /tmp/stdout.getcurl"
	echo curl -# -v -x $PROXY $1 > /tmp/stdout.getcurl
	`curl -# -v -x $PROXY $1 > /tmp/stdout.getcurl`
fi
if [ $# -eq 2 ]; then
	# Results went to specified fiel ($2)
	echo look in $2
else
	# Output file as if results redirected to STDOUT
	cat /tmp/stdout.getcurl
	echo
fi
