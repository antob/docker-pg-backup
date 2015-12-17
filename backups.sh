#!/bin/bash

source /pgenv.sh

#echo "Running with these environment options" >> /var/log/cron.log
#set | grep PG >> /var/log/cron.log

MYDATE=`date +%Y-%m-%d`
MONTH=$(date +%m)
YEAR=$(date +%Y)
MYBASEDIR=/backups
MYBACKUPDIR=${MYBASEDIR}/${YEAR}/${MONTH}
mkdir -p ${MYBACKUPDIR}
cd ${MYBACKUPDIR}

echo "[PGBACKUP] Backup running to $MYBACKUPDIR" >> /var/log/cron.log

#
# Loop through each pg database backing it up
#

DBLIST=`psql -l | awk '{print $1}' | grep -v "+" | grep -v "Name" | grep -v "List" | grep -v "(" | grep -v "template" | grep -v "postgres" | grep -v "|" | grep -v ":"`
if [ $? -ne 0 ]; then
    echo "[PGBACKUP] Error: Failed to get list of databases." >> /var/log/cron.log
fi

# echo "Databases to backup: ${DBLIST}" >> /var/log/cron.log
for DB in ${DBLIST}
do
  echo "[PGBACKUP] Backing up DB $DB"  >> /var/log/cron.log
  FILENAME=${MYBACKUPDIR}/${DUMPPREFIX}_${DB}.${MYDATE}.dmp
  pg_dump -i -Fc -f ${FILENAME} -x -O ${DB}

  if [ $? -ne 0 ]; then
    echo "[PGBACKUP] Error: Failed to backup $DB" >> /var/log/cron.log
  fi
done
