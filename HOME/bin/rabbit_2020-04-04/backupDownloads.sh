#!/bin/bash
# EEOW-1 - script to produce list of _Keep items downloaded in area that is backed up so can restore by re-downloading if needed later.

DL_AREA=/downloads/_Keep
OUTDIR=/Users/bsmith/Documents/backup

find $DL_AREA > $OUTDIR/downloads_`uname -n`.list
