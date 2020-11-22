#!/bin/bash
# USed to CURL URLs and give unique names.
# BBEDIT: find: "^.*(http[^\"]*).*" and replace: "\1" to get URLS from files 
unique=1

file=$1  #file of urls to get

if [ -x $file ]; then
  echo Usage: file of urls
  exit 1
fi

if [ ! -r $file ]; then
  echo FIle of URLS $1 aint exit
  exit 1
fi

for i in `cat $file`; do
	bit=`basename $i`
  echo $i, ${unique}_$bit
  curl $i -o ${unique}_$bit
  (( ++unique ))	#=(( $unique + 1 ));
done
