## Format usb disk
``` bash
su
fdisk -l
fdisk /dev/sdx
d #repeat until everything is gone
n #use defaults
t
7
w #save changes
umount /dev/sdx1
mkfs.ntfs /dev/sdx1 --fast
mount /dev/sdx1 /home/dorus/usb (something like that, or just reinsert the usb if you have auto mount enabled)
