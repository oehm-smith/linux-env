#!/bin/bash
# File: userBackup.sh
# Purpose: To backup the user partition to the user_2 backup partition excluding cache and other files
# Created: Brooke Smith 6th June 2007
# Args
#		None
# Assumptions:
#		user partition is /Volumes/Users/
#		user backup partition is /Volumes/User_2/

source=/Volumes/Users/
dest=/Volumes/User_2/

echo date sudo time rsync -a --exclude="*[cC]ache*" --exclude="" --exclude="[bB]ackup" --exclude=".Trash*" --exclude="tmp" --exclude="Deleted*" --exclude=".svn" --exclude=".Spotlight*" $source $dest

date; sudo time rsync -a --exclude="*[cC]ache*" --exclude="" --exclude="[bB]ackup" --exclude=".Trash*" --exclude="tmp" --exclude="Deleted*" --exclude=".svn" --exclude=".Spotlight*" $source $dest

