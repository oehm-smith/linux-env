#!/bin/bash

# 2022-11-25 - I am fixing up Lightroom and photos are 'mising' because LR has them like IMG_0477.JPG but the file
# is 2010-02-11_IMG_0477.JPG or similar
# This script drops the 2010-02-11_ part

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
	echo file: $i
	dn=$(dirname $i)
	fn=$(basename $i)
	IFS='-' read -ra arr <<< "$fn"
	echo "  dir: $dn, file: $fn -> ${arr[0]}, ${arr[1]}"
	if [ -z ${arr[1]} ]; then
		echo "    FILE IN ONE PART"
	else
		newFile=$dn/${arr[1]}
		cmd="mv $i $newFile"
		echo "    cmd: $cmd"
		if [ -n "$TESTING" ]; then
			echo "      Not running command - just showing what will be done"
		else
			echo "      run command"
			$($cmd)
		fi
	fi
done

