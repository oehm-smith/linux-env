#!/bin/bash

if [ $# -lt 2 ]; then
	echo Usage: $0 base_file_name revision_to_resolve_to
	exit 1;
fi

if [ ! -e "$1" ]; then
	echo $1 doesnt exist
	exit 1
fi
if [ ! -e "$1.r$2" ]; then
	echo $1.$2 doesnt exist
	exit 1
fi

echo mv $1.$2 $1
mv "$1.$2" "$1"
echo svn resolved "$1"
svn resolved "$1"
