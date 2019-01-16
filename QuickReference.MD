#### Create live USB from ISO
```
sudo pacman -S pv  # for progress report
sudo dd if=~/Downloads/image.iso | pv -s 2G | sudo dd of=/dev/sdx bs=4096

```
## Input
__Get stream of input__, like from mouse or keyboard: `sudo libinput debug-events`

## Fonts
__List all available fonts__: `fc-list`
