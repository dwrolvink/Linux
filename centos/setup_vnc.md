

# Setting up vnc server in centos
source: https://www.tecmint.com/install-and-configure-vnc-server-in-centos-7/
```bash
sudo yum install tigervnc-server
vncpasswd
cp /lib/systemd/system/vncserver@.service  /etc/systemd/system/vncserver@:1.service
vi /etc/systemd/system/vncserver@\:1.service # change <USER> to your username
systemctl daemon-reload
systemctl start vncserver@:1 # systemctl status vncserver@:1
systemctl enable vncserver@:1
```
# Setting up VNC viewer in manjaro using remmina
source: https://wiki.archlinux.org/index.php/Remmina
```bash
sudo pacman -S remmina libvncserver freerdp 
#freerdp is not needed for this manual, but nice to have regardless
```
- Start remmina
- Click (+)
- `Server = <ip>:5901`


