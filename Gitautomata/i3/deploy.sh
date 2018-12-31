#!/bin/sh

if [ "$(id -u)" != "0" ]; then
	echo "Script has to be run as root, exiting."
	exit 1
fi

# Update
pacman -Syuu

# Install applications
pacman -S yay 				--noconfirm
pacman -S chromium 			--noconfirm
pacman -S pcmanfm 			--noconfirm
pacman -S smbclient 			--noconfirm
pacman -S lxappearance 			--noconfirm
pacman -S manjaro-settings-samba 	--noconfirm

# Terminal settings
unalias cp

# Create directories
sudo -u dorus mkdir /home/dorus/nwd

# Copy files over
cp -f config /home/dorus/.i3/config
cp -f mountnwd.service /etc/systemd/system/mountnwd.service

# Mount network drive
cp -f mountnwd.service /etc/systemd/system/mountnwd.service
systemctl enable /etc/systemd/system/mountnwd.service


