#!/bin/sh
# See resolveAlias.sh
# REQUIRED - file './originals.txt' must exist with a list of files and this will copy them here

SAVEIFS=$IFS
#IFS=$(echo -en "\n")
IFS=$'\n'

for i in *.doc
do
	DIR=$(dirname "$i")
	EXT="${i##*.}"
	FILE=$(basename "$i")
	FILENAME="${FILE%.*}"
	NEWFN="$FILENAME.pdf"
	echo ----
	echo source: $i
	echo DIR: $DIR
	echo FILE: $FILENAME
	echo EXT: $EXT
	echo New FN: $NEWFN
	if [ -e "./$NEWFN" ]; then
	  	echo textutil -convert pdf -output "./$NEWFN-$RND" "$i"
	  	textutil -convert pdf -output "./$NEWFN-$RND" "$i"
	else
	  	echo textutil -convert pdf -output "./$NEWFN" "$i"
	  	textutil -convert pdf -output "./$NEWFN" "$i"
	fi
done
