#!/bin/bash
# File: ~bsmith/bin/backup.sh
# Created: Brooke Smith 8/7/2005
# Purpose: To use rsync to do backups

# Comments:
#	BS 2005 08 20 - Change to backing up $HOME but exclude cache dirs and files
#	BS 2006 11 29 - bsmith is too big so separate documents.
#		- Firewire drive with photos on it has gone down so exclude them
# BS 2006 05 03 - Need to upload photos so have put them in ~/pictures/iView4
#		- will backup ~/pictures/iView*

backup_base_loc=/Volumes/Backup
log_file=/tmp/backup.log
additional_options="-v --progress"

sudo rsync -a $additional_options --exclude="*[cC]ache*" --exclude="[bB]ackup" --exclude=".Trash*" --exclude="tmp" --exclude="Deleted*" --exclude="Documents" --exclude="iView" ~ $backup_base_loc/$USER > $log_file

sudo rsync -a $additional_options --exclude="*[cC]ache*" --exclude="[bB]ackup" --exclude=".Trash*" --exclude="tmp" --exclude="Deleted*" ~/Documents $backup_base_loc/${USER}_documents > $log_file

sudo rsync -a $additional_options /downloads $backup_base_loc/downloads > $log_file
sudo rsync -a $additional_options /work $backup_base_loc/work > $log_file
sudo rsync -a $additional_options /home $backup_base_loc/home > $log_file
sudo rsync -a $additional_options /Library/StartupItems $backup_base_loc/StartupItems > $log_file

# Library - exclude caches 

# Backup Photos
##sudo rsync -av /Volumes/pictures/iView $backup_base_loc/pictures
##sudo rsync -av /Volumes/pictures/iView2 $backup_base_loc/pictures

# BS 2006 05 03 - Photos firewire drive down but need to still upload photos.  So
#		Moving to ~/pictures/iView4.
#		- will backup ~/pictures/iView*

for i in `/bin/ls -d ~/Pictures/iView*`; do
  sudo rsync -a $additional_options $i $backup_base_loc/pictures > $log_file
done

# DP pics 2006 10 20
#sudo rsync -av /Volumes/pictures/ImagesDPGood $backup_base_loc/pictures

# Backup what MP3s I have (just their names)
#sudo find /Volumes/music -type d > $backup_base_loc/music.list

# BS 2006 04 12 - svn backup
svndumploc=$backup_base_loc/svn/work_`date +"%Y%m%d"`.dump
echo dump /svn/work to $svndumploc
svnadmin dump /svn/work > $svndumploc
echo Backup finished ...
date
date > $backup_base_loc/lastdump.date

/bin/ls -lad $backup_base_loc/svn/*
