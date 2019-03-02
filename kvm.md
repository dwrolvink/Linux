
## Install KVM
ITT: Installing KVM, creating a VM, and connecting from the client to the guest running on the host. 

My client is Manjaro/I3, so is my server, and the client will be CentOS 7 (but that doesn't really matter much).

### Installing KVM
It's still kind of unclear to me where KVM ends and QEMU/Libvirt begin.
Anyhoe, this combination of packages seem to work.
```
# --- Server ---
sudo pacman -Syyu

sudo pacman -S virt-manager qemu vde2 ebtables dnsmasq bridge-utils openbsd-netcat ebtables
sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service
```

### Getting the Centos ISO (other OSes allowed)
```
cd ~
mkdir kvm-isos

# Get centos iso
cd ~/kvm-isos
wget http://isoredirect.centos.org/centos/7/isos/x86_64/CentOS-7-x86_64-DVD-1810.iso
```

### Setup TigerVNC
Install TigerVNC so that we can login to the server and install CentOS. There are ways to connect directly to the CentOS
installer's VNC, but that'd be different for every Distro/OS.
```
sudo pacman -S tigervnc
vncserver
```
Notice that now you'll need to start vncserver manually every time the server reboots. You can make a systemd service to
solve this.

Now we just need to install tigervnc on our client and connect to the server:
```
sudo pacman -S tigervnc
vncviewer <server ip address>:1
```
In my case, I get a couple of terminals. Type `startxfce4` to enter xfce. You might have to install xfce first.

### Create VM
We left off in a working xfce session (hopefully). Open a terminal and type `sudo virt-manager`. (It's possible to do everything with `virsh` commands, but I haven't figured all of that out yet). 

Click "create new virtual machine" > "Local install" > "Browse Local" > ~kvm-isos > Centos.iso

Leave all the other options default unless you wish it to be different.

The vm window should open after you create the VM, go through the installation process here, outside of scope. (I only set the root password for this POC, and login as root in the rest of this POC.)

While it's installing, continue with the next steps.

### Set networking
#### Create routed network adapter
In virt-manager, select the newly created vm, and click "edit" > "connection details" > "virtual networks" > "+ (Add virtual network)" 

- Name: routed1
- Forwarding to physical network
  - Any physical device
  - Mode: routed
  
I left the rest default for this POC.

#### Select new network adapter in VM settings
Go to the virtual machine window (the one that opened after creating the vm. If you closed it, right click the vm > "open") 

Then click on the little light bulb (second icon from the left) to go to vm settings.

- Change the name of the VM in the overview page (if you want)
- Go to NIC <mac id>
  - network source : routed1

Note that my default subnet here is 192.168.100.0/24

### Set static route in router
The next step might not be necessary for you. A static route in your client may suffice. I'll explain below why I need to do this though.

There may be more elegant/powerful solutions, but they are also more work and more complex. So, for our POC, a static route will suffice. 

To understand the following steps, you'll need to know a bit about my setup:
![network](https://github.com/dwrolvink/Linux/blob/master/images/network.png)

I have the modem/router from my ISP, with subnet 192.168.178.0/24, in that subnet, I have a second router, for my personal appliances, and a DMZ (everything outside the second router). 

Because of the second router, my client is in the 192.168.1.0/24 subnet, and will go to the secondary router (netgear) for clues on how to communicate with the outside world. The netgear in turn asks the ISP router, and the ISP router will ask the ISP DNS, and so on.

Both my netgear router and the ISP router have no idea the `routed1` (virbr1 in my setup) exists. We need to tell someone to knock on the servers door if they have a package for the 192.168.100.0/24 subnet, and let the server handle the rest. I chose to add this piece of info (the static route) to the netgear router, but setting it on the ISP router should work too.

To do this, I followed the following [tutorial](https://kb.netgear.com/24322/How-do-I-set-or-edit-static-routes-on-a-NETGEAR-router).

I added the following route:

![route](https://github.com/dwrolvink/Linux/blob/master/images/route.png)

If your server and client are on the same subnet, you can add a static route to your client to tell it to point to the server as gateway for 192.168.100.0/24 (or whatever your routed kvm network subnet is). If your client doubles as server than your client already knows where to go for that subnet, as it hosts it itself (through dnsmasq btw).
  
#### Enable NIC in CentOS
For some reason, in my installation of CentOS, the eth0 NIC wasn't automatically up. We'll have to change that.

Go back to the VM window and finish up the installation, then  login.

If you do ip address, you'll see eth0 doesn't have an ip address.
I don't particularly like vi, but it's hard to install anything else when we don't have an IP address, so let's use that to edit the config file for eth0:

```
vi /etc/sysconfig/network-scripts/ifcfg-eth0
```
Change onboot=no to onboot=yes.
Exit vi when you're done (I believe in you).

Now, you can either reboot or do `ifup eth0` (I guess you might just want to do the latter).

Do `ip address` (or `ip a` if you're lazy) and check if there's an ip, also note what the ip is.

#### Testing
That should be it. SSH into your server, and ping the ip of your VM. That should work regardless of the static route part. So if that doesn't work, double check:

- If the correct network device is attached to your vm
- If the network device is up: `sudo virsh net-list --all` (should be all yesssesss)
- If you typed the ip of the guest correctly
- Shit, if it still doesn't work I feel bad for you son.

Now, go to your client and ping the vm. If it works: try `ssh root@<ip of vm>`. If that works: a small victory dance is in order.

If ping doesn't work: I don't know how, but try to find out how you do tracert on linux. Try to follow how the communication goes from your client, to router, to server. Good luck, you're almost there.




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
