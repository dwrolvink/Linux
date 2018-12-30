#!/bin/sh

if [ "$(id -u)" != "0" ]; then
	echo "Script has to be run as root, exiting."
	exit 1
fi

# Update
pacman -Syuu

# Install applications
pacman -S chromium
pacman -S pcmanfm
pacman -S smbclient
pacman -S lxappearance

# Terminal settings
unalias cp

# Copy files over
cp -f config /home/dorus/.i3/config
cp -f mountnwd.service /etc/systemd/system/mountnwd.service

# Mount network drive
cp -f mountnwd.service /etc/systemd/system/mountnwd.service
systemctl enable /etc/systemd/system/mountnwd.service
systemctl start mountnwd    #start directly for testing

