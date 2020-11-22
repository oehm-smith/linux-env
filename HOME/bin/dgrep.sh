#!/bin/bash
# dgrep - DHS grep that searches for the given term in the current directory recursively, but avoids the node_modules and build directories.
TERM=$1
if [ -z "$TERM" ]; then
	echo "$0 <term to search for in all files recursively> - term missing"
	exit 1
fi

grep -Rin "$TERM" * | grep -v "node_modules\|build"
