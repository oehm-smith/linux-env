#!/bin/bash
# EEOW-2 - script to backup list of servers in given directories (such /usr/local)

# Array of server directories - how do array?
SERVER_DIR=/usr/local
OUTDIR=/Users/bsmith/Documents/backup

/bin/ls -la $SERVER_DIR > $OUTDIR/serverapps_`uname -n`.list