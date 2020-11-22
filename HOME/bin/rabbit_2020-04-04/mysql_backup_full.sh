#!/bin/bash

source /home2/bin/mysql.profile

FILE=`date +%Y-%m-%d`
FILE=${FILE}_full.sql
sudo mysqldump --single-transaction --flush-logs --master-data=2 --all-databases --delete-master-logs -u root -p h89jj*8k | gzip > $MYSQL_BACKUP_DIR/$FILE.gz
