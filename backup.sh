#!/bin/bash
################################################################################
# Date    : 2013/12/12
# Author  : Vignesh Gurusamy
# Program : MySQL backup script
################################################################################

# Declare the variable 
# Please add a new vaiable for additional database
# Associative array will work only after bash version 4
declare -A db1 db2

# MySQL Variable
# MySQL user should have permission to access the database
# Create an array like this for adding a new database
# Example :
# db1=(["hostname"]="localhost" ["username"]="root" ["password"]="" ["dbname"]="test" ["siteurl"]="xyz.com")

db1=(["hostname"]="localhost" ["username"]="root" ["password"]="" ["dbname"]="test" ["siteurl"]="xyz.com")
db2=(["hostname"]="localhost" ["username"]="root" ["password"]="" ["dbname"]="test1" ["siteurl"]="xyz.com") 

# Please insert the database variable in this array
# Example :
# 	db_set=(db1 db2)
db_set=(db1 db2)

# Backup & Log Variable
db_bk_path="/opt/backup"
log_file="backuplog.log"

# Enable backup removal (true or false) and 
bk_remove="true"

# Days after sql dump will be deleted from the system
bk_remove_days=10

# Create the folder if the backup location is not available
if [ ! -d "$db_bk_path/$(date +%Y-%m-%d)" ]; then
    mkdir -p "$db_bk_path/$(date +%Y-%m-%d)"
fi

# Create the log file if it is not available
if [ ! -f "$db_bk_path/$log_file" ]; then
    echo "" > "$db_bk_path/$log_file"
fi

# Remove the old backup dumps
if [ $bk_remove == "true" ]; then
    find $db_bk_path -maxdepth 1 -type d -mtime +$bk_remove_days -exec rm -rf {} \;
fi

# Backup database on the system
for db in ${db_set[*]}
do
	hostname="$db["hostname"]"
	username="$db["username"]"
	password="$db["password"]"
	dbname="$db["dbname"]"
	siteurl="$db["siteurl"]"
	#MySQLdump cmd
	mysqldump -u ${!username} -p${!password} -h ${!hostname} ${!dbname} | gzip > "$db_bk_path/$(date +%Y-%m-%d)/mysql-${!siteurl}-${!dbname}-$(date +%Y-%m-%d).sql.gz";
done

#completed status
echo "Backup completed on `date +%Y-%m-%d %H:%M:%S`" >> "$db_bk_path/$log_file"
