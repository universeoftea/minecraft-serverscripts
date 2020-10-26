#!/bin/bash
BACKUPTIME=7
SERVERPATH=/var/minecraft-server
BACKUPPATH=/mnt/data/minecraft-server
MEMOPTS=8G

start-server()
{
	rsync -az "$SERVERPATH/static/" "$SERVERPATH/live/"
	screen -d -U -S minecraft-server -m $SERVERPATH/live/serverstart.sh $MEMOPTS
	# Give time to load spawn
	sleep 20
	#TODO: Check for succesful server start
}
stop-server()
{
	screen -d -r -p 0 -S minecraft-server -X stuff "stop^M"
	# Give time to stop
	sleep 10
	#TODO: Check that server is stopped and screen exited
	rsync -az "$SERVERPATH/live/" "$SERVERPATH/static/"
}
restart-server()
{
	stop-server
	start-server
}
backup()
{
	stop-server
	BACKUPNUM=$(date --rfc-3339=date)
	rsync -rlpgoDz "$SERVERPATH/static/" "$BACKUPPATH/$BACKUPNUM"

}
backup-restart()
{
	backup
	start-server
}
clean()
{
	find $BACKUPPATH/* -type d -ctime +$BACKUPTIME -exec rm -rf {} \;
}


case "$1" in
	start)
		start-server
		;;

	stop)
		stop-server
		;;

	restart)
		restart-server
		;;

	backup)
		backup
		;;

	backup-restart)
		backup-restart
		;;

	clean)
		clean
		;;

	*)
		echo "Unknown argument, exiting"
		exit 1
		;;

esac

