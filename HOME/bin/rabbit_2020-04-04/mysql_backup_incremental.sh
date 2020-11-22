#!/bin/bash

# Flush the (incremental backup) logs and start new ones
# The directory is set with --log-bin=dir command when mysqld started
# Currently the startup is:
#  /sw/bin/mysqld_safe --log-bin=$MYSQL_BACKUP_DIR/
# Where $MYSQL_BACKUP_DIR is defined in mysql.profile and it is currently:
#	 MYSQL_BACKUP_DIR=/Volumes/Backup/MySQL
sudo mysqladmin flush-logs -u root -p
