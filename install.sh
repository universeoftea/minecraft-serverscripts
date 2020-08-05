#!/bin/bash
# Call with ./install.sh uninstall to remove an installation

install()
{
	echo "Adding user minecraft to manage server"
	echo "Please set password"
	useradd minecraft
	passwd minecraft

	echo "Please enter the path to the server"
	echo "(This is the folder in which you have the server.jar file)"
	read INSTALLPATH

	echo "Please enter path to install server to or press enter for default"
	echo "/var/minecraft-server"
	read SERVERPATH
	if [ -z $SERVERPATH ]
	then
		SERVERPATH=/var/minecraft-server
	fi

	echo "Please enter path to backups for server or press enter for default"
	echo "/home/minecraft"
	read BACKUPPATH
	if [ -z $BACKUPPATH ]
	then
		BACKUPPATH=/home/minecraft
	fi

	echo "Please set server memory usage or press enter for default"
	echo "8G"
	read MEMOPTS
	if [ -z $MEMOPTS ]
	then
		MEMOPTS=8G
	fi

	echo "Please enter how many days of backups to keep when cleaning, enter for default"
	echo "7"
	read BACKUPTIME
	if [ -z $BACKUPTIME ]
	then
		BACKUPTIME=7
	fi


	echo "Setting vars"
	sed -i 's,SERVERPATH=.*,SERVERPATH='"$SERVERPATH"',' minecraft-server.sh
	sed -i 's,BACKUPPATH=.*,BACKUPPATH='"$BACKUPPATH"',' minecraft-server.sh
	sed -i 's,MEMOPTS=.*,MEMOPTS='"$MEMOPTS"',' minecraft-server.sh
	sed -i 's,BACKUPTIME=.*,BACKUPTIME='"$BACKUPTIME"',' minecraft-server.sh

	echo "Creating directories"
	mkdir -pv $SERVERPATH/static
	mkdir -pv $SERVERPATH/static
	mkdir -pv $SERVERPATH/live
	mkdir -pv $BACKUPPATH


	echo "Copying Files"
	cp -v minecraft-server.sh /usr/local/bin/
	cp -v minecraft-server.service /etc/systemd/system/
	cp -rv $INSTALLPATH/* $SERVERPATH/static/
	cp -v serverstart.sh $SERVERPATH/static/

	echo "Setting permissions"
	chown -Rv minecraft.minecraft $SERVERPATH
	chown -Rv minecraft.minecraft $BACKUPPATH

	echo "Adding service"
	systemctl daemon-reload
	systemctl enable minecraft-server.service
	echo "Server will be started on next reboot."
	echo "It can also manually be started with:"
	echo "systemctl start minecraft-server.service"

}
uninstall()
{
	
	echo "Are you sure you want to uninstall? Type YES (with capitals)"
	read REALLYUNINSTALL
	if [ $REALLYUNINSTALL != YES ]
	then
		exit 1
	fi
	echo "Uninstalling"
	SERVERPATH=$(grep SERVERPATH= /usr/local/bin/minecraft-server.sh|sed 's,SERVERPATH=,,')
	echo "SERVERPATH: $SERVERPATH"
	BACKUPPATH=$(grep BACKUPPATH= /usr/local/bin/minecraft-server.sh|sed 's,BACKUPPATH=,,')
	echo "BACKUPPATH: $BACKUPPATH"

	sleep 30

	echo "Stopping and removing service"
	sudo -u minecraft -g minecraft /ust/local/bin/minecraft-server.sh stop
	systemctl disable minecraft-server.service

	echo "Deleting server files and backups"
	rm -rvf $SERVERPATH
	rm -rvf $BACKUPPATH
	echo "Deleting service scripts"
	rm /usr/local/bin/minecraft-server.sh
	rm /etc/systemd/system/minecraft-server.service
	echo "Deleting minecraft user"
	userdel minecraft
	groupdel minecraft
}

if [ $(whoami) != root ]
then
	echo "Install requires root privileges, run with sudo."
	exit 1
fi
case $1 in
	uninstall)
		uninstall
		;;
	*)
		install
		;;
esac
