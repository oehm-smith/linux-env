#!/bin/bash
# File: ~bsmith/bin/backup.sh
# Created: Brooke Smith 8/7/2005
#		Dramatically changed with functions BS 2006 12 03
# Purpose: To use rsync to do backups

# Comments:
#	BS 2005 08 20 - Change to backing up $HOME but exclude cache dirs and files
#	BS 2006 11 29 - bsmith is too big so separate documents.
#		- Firewire drive with photos on it has gone down so exclude them
# BS 2006 12 03 - Need to upload photos so have put them in ~/pictures/iView4
#		- will backup ~/pictures/iView*
#		- Rewrite useing functions
# BS 2007 04 28 - Added backing up shared area (/Users/Shared).  No apps in there  yet.
#		- Added backup of June's Documents and Library

# Set if you want log file to be created
write_to_log_file=1

# Where to backup to
backup_base_loc=/Volumes/Backup

# Log file to use
log_file=/tmp/backup.log

# Additional options to pass to rsync
additional_options=""	#"-v"

# function: log_info
# purpose: Print to log file in $log_file if that file is set
function log_info() {
  if [ $write_to_log_file -eq 1 ] && [ -n "$log_file" ]; then
    info=$1
    echo $info > $log_file
  fi
}

# function: printContents
# purpose: Print contents of passed variable based on IFS passed as 2nd arg
# comments: Due to $1, $2 etc.. as fn args being split by " ", the contents
#		can't use " " as the IFS.
# arguments: 
#		tIFS - the Internal Field Separator to use
#   tContents - to print separated by IFS=$tIFS
function printContents() {
	echo arg: $1
	shift;
	for item in $*; do
	  echo " $item"
	done
} # printContents

# function: breakArgs
# purpose: Args use IFS="," - eg. "a,b", and need to pass "a b" to rsync
#		This creates this
# Args: IFS delimited args
# Returns: Space delimited args
function breakArgs() {
	gBrokenArgs=""
	for item in $*; do
	  gBrokenArgs="$gBrokenArgs $item"
	done
} # breakArgs()

# function: expandExcludes
# purpose: Excludes are just a list of excludes but rsync needs a list like:
#		--exclude="a" --exclude="b" ...
#		Create that in gExcludes
# Args: Excludes string with IFS delimeter=","
# Returns: None but creates gExcludes
function expandExcludes() {
	gExcludes=""
	for item in $*; do
	  gExcludes="$gExcludes --exclude=$item"
	done
} # expandExcludes()

function do_rsync() {
	tAdditionalOperators=$1
	tExcludes=$2
	tSource=$3
	tDest=$4
	tUseLog=$5
	
	SAVED_IFS=$IFS
	IFS=','
	
	breakArgs $tAdditionalOperators	# creates gBrokenArgs
	gAdditionalOperators=$gBrokenArgs
	
	expandExcludes $tExcludes # creates gExcludes
	
	if [ $write_to_log_file ] && [ -e $log_file ]; then
#		echo do_rsync:
#		printContents "tAdditionalOperators" $tAdditionalOperators
#		printContents "gAdditionalOperators" $gAdditionalOperators
#		printContents "tExcludes" $gExcludes
#		printContents "tSource" $tSource
#		printContents "tDest" $tDest
#		printContents "tUseLog" $tUseLog
		echo
		echo sudo rsync -a $gAdditionalOperators $gExcludes $tSource $tDest
		echo sudo rsync -a $gAdditionalOperators $gExcludes $tSource $tDest >> $log_file
		IFS=$SAVED_IFS
		sudo rsync -a $gAdditionalOperators $gExcludes $tSource $tDest >> $log_file
	else
		echo sudo rsync -a $gAdditionalOperators $gExcludes $tSource $tDest
		sudo rsync -a $gAdditionalOperators $gExcludes $tSource $tDest
	fi
	
} # do_rsync

if [ $write_to_log_file -eq 1 ]; then
	if [ -e $log_file ]; then
		rm $log_file
	fi
	echo Log File: $log_file
else
	echo NOT WRITING LOG FILE
fi
date=`date`
log_info "Start Backup: $date"

#################################################################
### Backups start here
#################################################################

# ~
do_rsync "$additional_options" "*[cC]ache*,[bB]ackup,.Trash*,tmp,Deleted*,Documents,iView*,.svn,.Spotlight*" ~ $backup_base_loc/$USER

# Play
#do_rsync "$additional_options" "*[cC]ache*,[bB]ackup,.Trash,tmp,Deleted*,Documents,iView,.svn" #~/tmp/rsync_play ~/tmp/rsync_play_out

# ~/Documents
do_rsync "$additional_options" "*[cC]ache*,[bB]ackup,.Trash*,tmp,Deleted*,.svn,.Spotlight*" ~/Documents $backup_base_loc/${USER}_documents

# /downloads/_downloads_keep
do_rsync "$additional_options" "*[cC]ache*,[bB]ackup,.Trash*,tmp,Deleted*,.svn,.Spotlight*" /downloads/_downloads_keep $backup_base_loc/downloads

# /work
do_rsync "$additional_options" "*[cC]ache*,[bB]ackup,.Trash*,tmp,Deleted*,.svn,.Spotlight*" /work $backup_base_loc/work

# /home
do_rsync "$additional_options" "*[cC]ache*,[bB]ackup,.Trash*,tmp,Deleted*,.svn,.Spotlight*" /home $backup_base_loc/home

# /Library/StartupItems
do_rsync "$additional_options" "*[cC]ache*,[bB]ackup,.Trash*,tmp,Deleted*,.svn,.Spotlight*" /Library/StartupItems $backup_base_loc/StartupItems

# /Users/Shared
do_rsync "$additional_options" "*[cC]ache*,[bB]ackup,.Trash*,tmp,Deleted*,.svn,.Spotlight*" /Users/Shared $backup_base_loc/Shared

# /Users/junemac/Documents
do_rsync "$additional_options" "*[cC]ache*,[bB]ackup,.Trash*,tmp,Deleted*,.svn,.Spotlight*" /Users/junemac/Documents $backup_base_loc/JuneMacDocs

# /Users/junemac/Library
do_rsync "$additional_options" "*[cC]ache*,[bB]ackup,.Trash*,tmp,Deleted*,.svn,.Spotlight*" /Users/junemac/Library $backup_base_loc/JuneMacLib

# Library - exclude caches 

# Backup Photos
##sudo rsync -av /Volumes/pictures/iView $backup_base_loc/pictures
##sudo rsync -av /Volumes/pictures/iView2 $backup_base_loc/pictures

# BS 2006 05 03 - Photos firewire drive down but need to still upload photos.  So
#		Moving to ~/pictures/iView4.
#		- will backup ~/pictures/iView*
for i in `/bin/ls -d ~/Pictures/iView*`; do
  do_rsync "$additional_options" "" $i $backup_base_loc/pictures
done

# DP pics 2006 10 20
#sudo rsync -av /Volumes/pictures/ImagesDPGood $backup_base_loc/pictures

##!### Backup what MP3s I have (just their names)
##!###sudo find /Volumes/music -type d > $backup_base_loc/music.list
##!##
##!### BS 2006 04 12 - svn backup
##!##svndumploc=$backup_base_loc/svn/work_`date +"%Y%m%d"`.dump
##!##echo dump /svn/work to $svndumploc
##!##svnadmin dump /svn/work > $svndumploc

# BS 2007 01 01 - find the files that were backed up since last backup
find $backup_base_loc -newer $backup_base_loc/lastdump.date > $backup_base_loc/lastdump.diffs

echo Backup finished ...
date
date > $backup_base_loc/lastdump.date

##!##
##!##/bin/ls -lad $backup_base_loc/svn/*
echo NOT DOING SVN DUMPS as NOT USING SVN CURRENTLY
echo PLUS need to work out so doesnt dump if hasnt changed

if [ $write_to_log_file -eq 1 ] && [ -e $log_file ]; then
	echo >> $log_file
	echo "Files that have been backed-up (files newer than the last lastdumps.date)" >> $log_file
	echo "=========================================================================" >> $log_file
	cat $backup_base_loc/lastdump.diffs >> $log_file
	echo LOG FILE: $log_file
else
	echo DIDNT WRITE LOG FILE
	echo Diffs file is $backup_base_loc/lastdump.diffs
fi
