#### Create live USB from ISO
```
sudo pacman -S pv  # for progress report
dd if=/dev/sdb | pv -s 2G | sudo dd of=DriveCopy1.dd bs=4096

```
