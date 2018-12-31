#!/bin/sh

if [ "$(id -u)" != "0" ]; then
	echo "Script has to be run as root, exiting."
	exit 1
fi

printstep(){
        BLUE='\033[0;34m'
        REEE='\033[0;31m'
        NC='\033[0m' # No Color

        ERROR=1

        if [[ $2 -eq $ERROR ]];
        then
              echo -e "${REEE} ${1} ${NC}"
        else
              echo -e "${BLUE} ${1} ${NC}"
        fi
}


#############################################
printstep "[Updating system and installing applications]"
#############################################

# Update
printstep "Updating repository"
pacman -Syuu


# Install applications
pacman -S yay 				--noconfirm
printstep "Installing Chrome"
pacman -S chromium 			--noconfirm
printstep "Installing minor applications"
pacman -S pcmanfm 			--noconfirm
pacman -S smbclient 			--noconfirm
pacman -S lxappearance 			--noconfirm
pacman -S manjaro-settings-samba 	--noconfirm


#############################################
printstep "[Installing user settings]"
#############################################

# Terminal settings
unalias cp
echo "VISUAL=nano; export VISUAL EDITOR=nano; export EDITOR" 	>> /home/dorus/.profile
echo "URxvt.transparent: true" 					>> /home/dorus/.Xresources
echo "URxvt.shading:20"						>> /home/dorus/.Xresources

# Create directories
sudo -u dorus mkdir /home/dorus/nwd

# Copy files over
cp -f .i3/config 	/home/dorus/.i3/config			# i3 config
cp    mountnwd.service 	/etc/systemd/system/mountnwd.service	# Mount network drive
cp    20-radeon.conf 	/etc/X11/xorg.conf.d/20-radeon.conf 	# anti tearing

# Mount network drive
cp -f mountnwd.service /etc/systemd/system/mountnwd.service
systemctl enable /etc/systemd/system/mountnwd.service

#############################################

prinstep "Run 'unalias cp' as yourself, and then reboot to finish installation." 0

