#### Create live USB from ISO
```
sudo pacman -S pv  # for progress report
sudo dd if=~/Downloads/image.iso | pv -s 2G | sudo dd of=/dev/sdx bs=4096

```
