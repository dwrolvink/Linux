```
# --- Server ---
sudo pacman -Syyu

sudo pacman -S qemu

cd ~
mkdir kvm-isos
mkdir kvm-pool
cd kvm-pool

# Create image file of 10 gb 
qemu-img create -f qcow2 image_file 10G

# Create overlay for the image file
qemu-img create -o backing_file=image_file,backing_fmt=qcow2 -f qcow2 img1.cow

# Get centos iso
cd ~/kvm-isos
wget <url to iso>

# Setup TigerVNC
sudo pacman -S tigervnc
vncserver

# --- Client ---
sudo pacman -S tigervnc
vncviewer <ip address>:1

# --- Continue on the vnc screen on the client (so you're working on the server) ---
qemu-system-x86_64 -cdrom /home/dorus/kvm-isos/CentOS-7-x86_64-Minimal-1810.iso `
-boot order=d -drive file=/home/dorus/kvm-pool/img1.cow,format=qcow2 -m 1G
```
