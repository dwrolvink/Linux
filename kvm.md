## Installing vmware-workstation
```
uname -r 
# note the kernel version
sudo pacman -S yay # for AUR packages
sudo pacman -S fuse2 gtkmm linux-headers libcanberra pcsclite 
# chose the linux headers with your kernel version
yay -S ncurses5-compat-libs
yay -S vmware-workstation
# choose the verion with your kernel version in the name
```

## Install KVM
```
# --- Server ---
sudo pacman -Syyu

sudo pacman -S virt-manager qemu vde2 ebtables dnsmasq bridge-utils openbsd-netcat ebtables
sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service

cd ~
mkdir kvm-isos
mkdir kvm-pool
#cd kvm-pool

# Create image file of 10 gb 
#qemu-img create -f qcow2 image_file 10G

# Create overlay for the image file
#qemu-img create -o backing_file=image_file,backing_fmt=qcow2 -f qcow2 img1.cow

# Get centos iso
cd ~/kvm-isos
wget <url to iso>

# Setup TigerVNC
sudo pacman -S tigervnc
vncserver

# --- Client ---
sudo pacman -S tigervnc
vncviewer <ip address>:1

```
