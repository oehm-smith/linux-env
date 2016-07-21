#!/bin/bash

echo Run this from directory with possible duplicate files in and it will use mdfind to search all indexed files.

IFS=$'\n'
for i in $(find . -type f)
do 
    echo file: $i
    echo basename: $(basename $i)
    echo mdfind: $(mdfind $(basename $i))
    for j in $(mdfind $(basename $i))
    do 
        echo one:"$j"--
        #echo "$j"| grep "$i$"
        #AA=$?
        #echo result of grep: $AA
        if [[ $j =~ $i$ ]]; then
            /bin/ls -la $j
        else
            echo NO MATCH X.X.X.X.X.X.X.X.X.X.X.X.X.X.X.X.X.X.X.X.
        fi
    done
    echo ----
    #exit 1
done
