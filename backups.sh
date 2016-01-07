#!/bin/bash

source /pgenv.sh

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

for DB in ${DBLIST}
do
  echo "[PGBACKUP] Backing up DB $DB"  >> /var/log/cron.log
  FILENAME=${MYBACKUPDIR}/${DB}.${MYDATE}.dmp
  DUMP_OUTPUT="$(pg_dump -i -Fc -f ${FILENAME} -x -O ${DB} 2>&1)"

  if [ $? -ne 0 ]; then
    echo "[PGBACKUP] Error: Failed to backup $DB. Error was: $DUMP_OUTPUT" >> /var/log/cron.log
  fi
done
