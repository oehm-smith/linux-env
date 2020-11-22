#!/bin/bash
# File: picturesBackup.sh
# Purpose: To backup the given directory under the /Volumes/Pictures partition to the /Backup/pictures directory excluding cache and other files
# Created: Brooke Smith 4th August 2007
# Args
#		Name of pictures directory - eg. iView4
# Assumptions:
#		user partition is /Volumes/Users/
#		user backup partition is /Volumes/User_2/

if [ $# -lt 1 ]; then
	echo "Usage: $0 dir_in_Volumes_Pictures"
	exit 1
fi
echo $#

source=/Volumes/Pictures/$1
dest=/Volumes/Backup/pictures/

if [ ! -d $source ]; then
  echo "Source dir aint exist: $source"
  exit 1
fi

echo date sudo time rsync -a --exclude="*[cC]ache*" --exclude="" --exclude="[bB]ackup" --exclude=".Trash*" --exclude="tmp" --exclude="Deleted*" --exclude=".svn" --exclude=".Spotlight*" $source $dest

date; sudo time rsync -a --exclude="*[cC]ache*" --exclude="" --exclude="[bB]ackup" --exclude=".Trash*" --exclude="tmp" --exclude="Deleted*" --exclude=".svn" --exclude=".Spotlight*" $source $dest

