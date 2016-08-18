#!/bin/sh
# arg1: term to search for when using npm projects as it excludes the node_modules directory and .map files..
if [[ -z $1 ]]; then
    echo usage: arg to search for in all but node_modules
    exit 1
fi
grep -Rin --exclude-dir "./node_modules*" $1 . | grep -v "\.map" | grep --color $1
