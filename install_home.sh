#!/bin/bash

# Setup the links from ~/files to .=linux-env/HOME/*
wire_file() {
    fileName=$1 # file name (or dir) in /etc that links to absPath
    absPath=$2  # path to file in source directory
    
    echo wire_file $1 $2
    
    if [ -z $absPath ]; then
        echo wire_file requires fileName and absPath as arguments
        return
    fi
    
    if [ -h ~/$fileName ]; then
        # symlink
        echo rm ~/$fileName
        rm ~/$fileName
    else 
        if [ -e $absPath ]; then
            if [ -e ~/$fileName ]; then
                dateExt=$(date '+%Y%m%d-%H%M')
                echo mv ~/$fileName ~/${fileName}_$dateExt
                mv ~/$fileName ~/${fileName}_$dateExt
            fi
        fi
    fi
    
    echo ln -s $absPath ~/$fileName
    ln -s $absPath ~/$fileName
}

if [ "$(whoami)" != "root" ]; then
	echo "Sorry, must run with sudo (root)."
	exit 1
fi

for i in ./HOME/{*,.[^.]*}
do
    echo --------------------------
    if [[ "$i" == *".DS_Store"* ]]; then
        echo DS_STORE
    else
        echo File to wire: $i
        wire_file $(basename $i) $PWD/$i
    fi
done
