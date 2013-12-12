#!/bin/bash
################################################################################
# Date    : 2013/12/12
# Author  : Vignesh Gurusamy
# Program : Moodle backup script
################################################################################

# MySQL Variable
MYSQL_HOST_NAME="localhost"
MYSQL_USER_NAME="root"
MYSQL_USER_PWD=""
MYSQL_DB_NAME="test"

# Backup variable
HN=`hostname | awk -F. '{print $1}'`
BK_PATH="/opt/backup"

# Log variable
LOG_FILE_NAME="backuplog.log"

# Enable backup removal (true or false)
BK_REMOVE="true"
# Days after sql dump should be deleted from the system
BK_REMOVE_DAYS=10

# Create the folder if the backup location is not available
if [ ! -d "$BK_PATH/$(date +%Y-%m-%d)" ]; then
    mkdir -p "$BK_PATH/$(date +%Y-%m-%d)"
fi

# Create the log file if it is not available
if [ ! -f "$BK_PATH/$LOG_FILE_NAME" ]; then
    echo "" > "$BK_PATH/$LOG_FILE_NAME"
fi

# Remove the old backup dumps
if [ $BK_REMOVE == "true" ]; then
    find $BK_PATH -maxdepth 1 -type d -mtime +$BK_REMOVE_DAYS -exec rm -rf {} \;
fi

# Backup database on the system
mysqldump --user=$MYSQL_USER_NAME --password=$MYSQL_USER_PWD --opt $MYSQL_DB_NAME | gzip > "$BK_PATH/`date +%Y-%m-%d`/mysqldump-$HN-$MYSQL_DB_NAME-$(date +%Y-%m-%d).sql.gz";

echo "Backup completed for `date +%Y-%m-%d`" >> "$BK_PATH/$LOG_FILE_NAME"




