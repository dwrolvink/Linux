#### Create live USB from ISO
```
sudo pacman -S pv  # for progress report
sudo dd if=~/Downloads/image.iso | pv -s 2G | sudo dd of=/dev/sdx bs=4096

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

__Disable middle mouse button__, create ~/.Xmodmap and fill it with: `pointer = 1 6 3 4 5 2`; relogin

## Fonts
__List all available fonts__: `fc-list`
