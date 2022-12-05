#!/bin/bash

# 2022-11-27 - I am fixing up Lightroom and photos are 'mising' because LR has them like 20110508-IMG_0501.JPG but the file
# is IMG_0501.JPG in directory 2011-05-08
# This script adds the 20110508- part

# Arguments
#	$1 - input directory of files.  They are recursively searched
#   $2 - anything to cause the changes to be made, else it just reports what it is going to do

if [ -z "$1" ]; then
    echo "Usage: Dir To rename dated files in and OPTIONAL anything to make rename happen (else just reports on what it will doe)"
    exit 1
fi

if [ ! -d "$1" ]; then
	echo "$1 directory must exist"
	exit 2
fi

TESTING="$2"
echo TESTING: $TESTING

for i in $(find $1 -type f)
do
	echo --------------------------------- TESTING: $TESTING
	dn=$(dirname $i)
	fn=$(basename $i)
	echo file: $i, dn: $dn, fn: $fn
	datedDirName=$(basename $dn)
	IFS='-' read -ra dnArr <<< "$datedDirName"
	IFS='-' read -ra fnArr <<< "$fn"

	echo "  dir: $dn, datedDirName parts: ${dnArr[0]}, ${dnArr[1]}, ${dnArr[2]}"
	if [ -z ${fnArr[1]} ]; then
		echo "    FILE IN ONE PART - so convert"
		newFile=$dn/${dnArr[0]}${dnArr[1]}${dnArr[2]}-${fnArr[0]}
		cmd="mv $i $newFile"
		echo "    cmd: $cmd"
		if [ -n "$TESTING" ]; then
			echo "      Not running command - just showing what will be done"
		else
			echo "      run command"
 			$($cmd)
		fi
	else
		echo "    FILE ALREADY DATED - so DO NOT convert"
	fi
done

