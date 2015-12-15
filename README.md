# Docker PG Backup


A simple docker container that runs PosrgeSQL backups.

To restore a backup, attach to the running pb-backup container:

$ kubectl exec postgres-2ixq3 -c pg-backup bash
$ source /pgenv.sh
$ pg_restore -c -O -v -d app /backups/2015/12/PG_app.2015-12-13.dmp
