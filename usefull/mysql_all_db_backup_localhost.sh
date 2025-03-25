#!/bin/bash
 
##
# MySQL backup utility
# crontab -e
# @daily sudo bash /home/kpi/mysql_all_db_backup.sh
##

WORK_DIR="/media/db-backup/cc-swr1" 

# current date
DATE=`date +%Y%m%d`
OLD_DATE=`date -d last-week +%Y%m%d`
 
# y/m/d/h/m separately
YEAR=`date +%Y`
MONTH=`date +%m`
DAY=`date +%d`
HOURS=`date +%H`
MINUTES=`date +%M`

DB_LIST="/tmp/databases.list"

# database credentials
DB_USER="root"
DB_PASSWORD="password"
DB_HOST="127.0.0.1"

# remove expired backup
OLD_BACKUP_DIR=$WORK_DIR/mysql/$OLD_DATE 
rm -rf $OLD_BACKUP_DIR

# create list of databases
mysql -u $DB_USER -p$DB_PASSWORD -h $DB_HOST -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema|mysql|sys|149|development)" > $DB_LIST
# create backup dir (e.g. ../201112312359)
BACKUP_DIR=$WORK_DIR/mysql/$DATE

mkdir --parents --verbose $BACKUP_DIR
 
# now we can backup current database
for database in `cat $DB_LIST`
do
  echo "++ $database"
  cd $BACKUP_DIR
  backup_name="$YEAR-$MONTH-$DAY.$HOURS-$MINUTES.$database.backup.sql.gz"
  echo "   backup $backup_name"
  `mysqldump -u$DB_USER -p$DB_PASSWORD -h$DB_HOST --opt --routines $database | gzip > $BACKUP_DIR/$backup_name`
  echo "   cleanup $backup_name"
done
 
`rm /tmp/databases.list`
echo "done!"
