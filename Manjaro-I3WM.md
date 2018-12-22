# manjaro-i3

After installing the manjaro i3 community edition, these configurations were necessary to get everything working like I wanted it.


# Auto updates
On my server, I just want to install the updates automatically, because I just want the zero-day fixes and don't care as much about stability. Code below comes from https://www.techrapid.uk/2017/04/automatically-update-arch-linux-with-systemd.html . See https://wiki.archlinux.org/index.php/Systemd/Timers for more info on systemd timers.

#### Create .service
```
sudo nano /etc/systemd/system/autoupdate.service
```
```
[Unit]
 Description=Automatic Update
 After=network-online.target 

[Service]
 Type=simple
 ExecStart=/usr/bin/pacman -Syuq --noconfirm
 TimeoutStopSec=180
 KillMode=process
 KillSignal=SIGINT

[Install]
 WantedBy=multi-user.target
```
#### Create .timer
```
sudo nano /etc/systemd/system/autoupdate.timer
```
```
[Unit]
 Description=Automatic update every day

[Timer]
 OnCalendar=daily
 Persistent=true
 Unit=autoupdate.service

[Install]
 WantedBy=multi-user.target
 ```
 
 #### Enable timer
 ```
 sudo systemctl enable /etc/systemd/system/autoupdate.timer
 ```

# I3WM Config
When changes are made to i3, you can reload i3 with Mod+Shift+r

## Change mod key to alt
```
nano .i3/config
```
Change Mod4 to Mod1 (one of the first lines).

## Change keybind for close window
1. Edit ~/.i3/config, find mod+Shift+q
2. Change that to mod+q
3. Search for split toggle (has the same binding) and change that to mod+Shift+q

## Change auto screen lock
```
nano .i3/config
```
Comment out the following line: `exec --no-startup-id xautolock -time 10 -locker blurlock`

## Edit colors
Here is a nice .XResources file with a lot of settings: https://gist.github.com/whit/1307597

### Edit xterm (terminal) colors
1. Edit file ~/.XResources
2. Transparency: 
```
URxvt.transparent: true
URxvt.shading:20
```
3. Folder colors (links): `URxvt*color12: #FF0000`
2. Reload xterm settings: `xrdb .XResources`

http://terminal.sexy/

### Edit i3status bar colors
That ugly color "lan: 192.168.etc" is hard to find. It's configured not in bar {} in .i3/config but in the i3status.conf file.

1. Copy the file over to the user directory: `cp i3status.conf ~/.i3status.conf`
2. `gedit ~/.i3status.conf` the color you are searching for is general{color_good}


## Change theme
mod+d > `lxappearance`

### Install theme
1. Download gtk 2/3 theme
2. Extract in ~/.themes `tar xf ~/Downloads/nameoftar.tar.xz`
3. Extract icon packs in ~/.icons

# Sound
For some reason, the correct sound card was not loaded and changing it manually didn't save any of the settings. The solution was found here: https://wiki.manjaro.org/index.php?title=Setting_the_Default_Sound_Device

1. When right clicking the audio icon > open mixer > f6 you can see which audio device shows up as working. Notice that changing to the correct card here did nothing for me, but it can help you pick the right one later on

2. In a terminal, do `cat /proc/asound/cards` and note the number of the sound card that appears functional
3. SU into root, and then open `/etc/asound.conf`
4. Add these lines to the end of the file: (where 1 was the number of the sound card that I picked)
```
defaults.pcm.card 1
defaults.ctl.card 1
```
5. Save file, and test the audio. It directly worked for me after this. You might want to log in again (mod+shift+e) if it doesnt

# Used applications
## Text editor
1. sudo pacman -S gedit
2. Edit preferences in gedit to show line numbers, colors, show grid, show overview

## AUR manager
1. sudo pacman -S yay

## Spotify
1. sudo yay -S spotify
2. --> pick spotify

## Browser
### Vivaldi
1. Add herecura to /etc/pacman.conf:
```
[herecura]
Server = https://repo.herecura.be/$repo/$arch
```
2. `sudo pacman -Sy` to reload pacman
3. `sudo pacman -S vivaldi`

Vivaldi can't do everything (spotify, for example), so install Chromium too

## Citrix receiver
`yay -S icaclient --noconfirm`

## Virtualbox
1. `uname -r`  gives you the kernel version
2. `sudo pacman -S virtualbox` pick the option with your kernel version
3. reboot linux or 
4. https://wiki.manjaro.org/index.php?title=VirtualBox
5. sudo VBoxManage extpack install /tmp/$file --replace
6. sudo vboxreload
7. Turn autoresize off
8. Turn the status bar off (also in machine settings: turn off mini bar in fullscreen)

