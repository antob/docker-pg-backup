#!/bin/bash

# This script will set up the postgres environment
# based on env vars passed to then docker container

# Source mounted secrets if available
if [ -f /etc/secrets/env ]; then
  . /etc/secrets/env
fi

# Check if each var is declared and if not,
# set a sensible default
if [ -z "${PGUSER}" ]; then
  PGUSER=postgres
fi

if [ -z "${PGPASSWORD}" ]; then
  if [ -z "${POSTGRES_PASSWORD}" ]; then
    PGPASSWORD=password
  else
    PGPASSWORD=${POSTGRES_PASSWORD}
  fi
fi

if [ -z "${PGPORT}" ]; then
  PGPORT=5432
fi

if [ -z "${PGHOST}" ]; then
  PGHOST=localhost
fi

if [ -z "${PGDATABASE}" ]; then
  PGDATABASE=app
fi

# Now write these all to case file that can be sourced
# by then cron job - we need to do this because
# env vars passed to docker will not be available
# in then context of the running cron script.

echo "
export PGUSER=$PGUSER
export PGPASSWORD=$PGPASSWORD
export PGPORT=$PGPORT
export PGHOST=$PGHOST
export PGDATABASE=$PGDATABASE
 " > /pgenv.sh

echo "[PGBACKUP] Starting backup script."

# Now launch cron and rsyslogd. Tail logs in the foreground.
rsyslogd && cron && tail -fq /var/log/syslog /var/log/cron.log
