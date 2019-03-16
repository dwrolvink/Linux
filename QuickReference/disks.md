## Format usb disk
``` bash
su
fdisk -l
fdisk /dev/sdx
r (until everything is gone)
n
t
7
umount /dev/sdx1
mkfs.ntfs /dev/sdx1 --fast
mount /dev/sdx1 /home/dorus/usb (something like that, or just reinsert the usb if you have auto mount enabled)
