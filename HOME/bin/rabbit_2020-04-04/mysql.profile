#!/bin/bash

source /home2/bin/functions.profile

# 20/2/2009 - See http://eeow.local:8080/JSPWiki/Wiki.jsp?page=Mysql
MYSQLBASE=/usr/local/mysql
pathAppend $MYSQLBASE/bin

# Where backups - full and incremental, go to
MYSQL_BACKUP_DIR=/Volumes/Backup/MySQL
# Startup script
SCRIPT="/usr/local/mysql/support-files/mysql.server"
