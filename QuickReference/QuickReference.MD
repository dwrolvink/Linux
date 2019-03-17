#### Copy files over SSH
```
scp <file location> <server>:<destination_folder>
```

#### Create live USB from ISO
```
lsblk
umount <folder that usb is mounted to> # only needed when automount is enabled
dd bs=4M if=path/to/archlinux.iso of=/dev/sdx status=progress oflag=sync
```

## Processes
### Kill proces based on name
```
ps -eaf | grep <process name>
kill <pid (first int of output>
```
Or:

```
pkill <name of process>
```

## Input
__Get stream of input__, like from mouse or keyboard: `sudo libinput debug-events`
__Get xwindow name__: `xprop`

__Disable middle mouse button__, create ~/.Xmodmap and fill it with: `pointer = 1 6 3 4 5 2`; relogin

## Fonts
__List all available fonts__: `fc-list`
__Get valid font name__: `fc-match <name>`


Animated background (doesn't work with compton transparency) 
`xwinwrap -g 1920x1080 -ov -- mpv -wid WID ~/Pictures/EmotionalEminentBarnswallow.webm --loop inf`
