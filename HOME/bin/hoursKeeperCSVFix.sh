#!/bin/bash

if [ $# == 0 ]; then
	echo Usage: $0 file_to_fix
	exit 1
fi

~/bin/_hoursKeeperCSVFix.pl "$1"
