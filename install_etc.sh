#!/bin/bash

# Setup the links from /etc/files to .=linux-env/ETC/*
wire_file() {
    fileName=$1 # file name (or dir) in /etc that links to absPath
    absPath=$2  # path to file in source directory
    
    echo wire_file $1 $2
    
    if [ -z $absPath ]; then
        echo wire_file requires fileName and absPath as arguments
        return
    fi
    
    if [ -h /etc/$fileName ]; then
        # symlink
        echo rm /etc/$fileName
        rm /etc/$fileName
    else 
        if [ -e $absPath ]; then
            if [ -e /etc/$fileName ]; then
                dateExt=$(date '+%Y%m%d-%H%M')
                echo mv /etc/$fileName /etc/${fileName}_$dateExt
                mv /etc/$fileName /etc/${fileName}_$dateExt
            fi
        fi
    fi
    
    echo ln -s $absPath /etc/$fileName
    ln -s $absPath /etc/$fileName
}

if [ "$(whoami)" != "root" ]; then
	echo "Sorry, must run with sudo (root)."
	exit 1
fi

for i in ./ETC/*
do
    echo --------------------------
    echo File to wire: $i
    wire_file $(basename $i) $PWD/$i
done
