

# Setting up vnc server in centos
source: https://www.tecmint.com/install-and-configure-vnc-server-in-centos-7/
```bash
sudo yum install tigervnc-server
vncpasswd
sudo cp /lib/systemd/system/vncserver@.service  /etc/systemd/system/vncserver@:1.service
sudo vi /etc/systemd/system/vncserver@\:1.service # change <USER> to your username
sudo systemctl daemon-reload
sudo systemctl start vncserver@:1 # systemctl status vncserver@:1
sudo systemctl enable vncserver@:1
```

If your server has the same domain name as the client, this will do it. 
If it has a different domain name, connections will not be allowed, and you will need to do the following:

```bash
firewall-cmd --add-port=5901/tcp
firewall-cmd --add-port=5901/tcp --permanent
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
- For me, these graphics settings created the best result:
  - `Color Depth = True color (32 bpp)`
  - `Quality = Medium`


