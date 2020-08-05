# minecraft-serverscripts
Server scripts for running a headless minecraft server on Linux.

Depends on:
*rsync*
*screen*
*systemd*

To manage the minecraft server, please log in as the minecraft user created by the install script.

When the server is running, the serverconsole can be reached by executing *screen -r -d -S minecraft-server*

When the server starts it copies itself to $SERVERPATH/live from $SERVERPATH/static, this is intentional even though it adds on to startup and stopping times. This is so that servers that has a lot of RAM can mount $SERVERPATH/live as a tmpfs (virtual disk in RAM) to increase performance. This can be done by modifying /etc/fstab accordingly. Since this is an advanced OS modification, might not be possible on all systems, and ramdisk size might vary wildly, it is up to the administrator to do this manually. Do not do this unless you know how ramdisks and tmpfs in Linux works, it can make your OS unbootable!

### COPYRIGHT & LICENSE ###

    *minecraft* is not affiliated with this program.
    It is distributed separately with its own license and copyright.

    Copyright 2020, Emil Vejlens

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
