#!/bin/sh
# See resolveAlias.sh
# REQUIRED - file './originals.txt' must exist with a list of files and this will copy them here

SAVEIFS=$IFS
#IFS=$(echo -en "\n")
IFS=$'\n'

for i in $(cat originals.txt )      
do
	# If file already exists append a unique extension 
	RND=$(LC_ALL=C tr -dc 0-9 </dev/urandom | head -c 4; echo)
	DIR=$(dirname "$i")
	EXT="${i##*.}"
	FILE=$(basename "$i")
	FILENAME="${FILE%.*}"
	#echo source: $i
	#echo DIR: $DIR
	#echo FILE: $FILENAME
	#echo EXT: $EXT
	if [ -e "./$FILE" ]; then
	  echo cp "$i" "./$FILENAME-dupe$RND.$EXT"
	  cp "$i" "./$FILENAME-dupe$RND.$EXT"
	else
	  echo cp "$i" .
	  cp "$i" .
	fi
done

IFS=$SAVEIFS