Hi all,

I got a new monitor, and it was screen tearing so I changed graphics cards. I'm now using a GeForce GT 710.

Suspend was working perfectly before, but now, when I recover from suspend I just get a black screen. 
The keyboard also doesn't light up normally anymore, the backlight stays off until I press a key, 
where normally it would come on by itself.

Also, when I use hibernate as an alternative, and I start up after that, the computer starts beeping without end, and then I have to turn it off again, and on again, and then it just restores back into my session. Can't find any posts on that.

So back on the suspend problem:
I tried the ctrl+alt+F1, ctrl+alt+f7 "trick", but it does nothing. I don't see a cursor, nor dashes, nothing.
I did get to a point where I saw dashes, because I borked a config file. At that point I could get into tty2 and change the config file back.

For those interested, I borked it by following a post in this thread: https://forum.manjaro.org/t/black-screen-on-suspension-resume/32893/13
And did 
`lspci | grep HDMI`

Which gave me:
`01:00.1 Audio device: NVIDIA Corporation GK208 HDMI/DP Audio Controller (rev a1)`

And he said: 00:02.0 will make BusID "PCI:0:2:0", so I changed /etc/X11/xorg.conf.d/90-mhwd.conf to be:
```
Section "Device"
    Identifier     "Device0"
    Driver         "nvidia"
    VendorName     "NVIDIA Corporation"
    BusID          "PCI:0:2:0"
    
EndSection
```
And that just broke it, maybe I should've used a different number there though.

Some more info about my set up:
I'm using I3WM on a desktop. 

`inxi -Fxxxz`
```
System:    Host: dorus-pc Kernel: 4.19.12-2-MANJARO x86_64 bits: 64 compiler: gcc v: 8.2.1 
           Desktop: i3 4.16 info: i3bar dm: LightDM 1.28.0 Distro: Manjaro Linux 
Machine:   Type: Desktop Mobo: MEDIONPC model: MS-7707 v: 1.1 serial: N/A BIOS: American Megatrends 
           v: E7707MLN.108 date: 12/22/2010 
CPU:       Topology: Quad Core model: Intel Core i7-2600 bits: 64 type: MT MCP arch: Sandy Bridge 
           rev: 7 L1 cache: 32 KiB L2 cache: 8192 KiB L3 cache: 8192 KiB 
           flags: lm nx pae sse sse2 sse3 sse4_1 sse4_2 ssse3 vmx bogomips: 54292 
           Speed: 1596 MHz min/max: 1600/3800 MHz Core speeds (MHz): 1: 1596 2: 1596 3: 1596 
           4: 1596 5: 1596 6: 1596 7: 1596 8: 1596 
Graphics:  Device-1: NVIDIA GK208B [GeForce GT 710] vendor: Micro-Star MSI driver: nvidia v: 415.25 
           bus ID: 01:00.0 chip ID: 10de:128b 
           Display: server: X.Org 1.20.3 driver: nvidia compositor: compton 
           resolution: 1920x1080~60Hz 
           OpenGL: renderer: GeForce GT 710/PCIe/SSE2 v: 4.6.0 NVIDIA 415.25 direct render: Yes 
Audio:     Device-1: Intel 6 Series/C200 Series Family High Definition Audio vendor: Micro-Star MSI 
           driver: snd_hda_intel v: kernel bus ID: 00:1b.0 chip ID: 8086:1c20 
           Device-2: NVIDIA GK208 HDMI/DP Audio vendor: Micro-Star MSI driver: snd_hda_intel 
           v: kernel bus ID: 01:00.1 chip ID: 10de:0e0f 
           Sound Server: ALSA v: k4.19.12-2-MANJARO 
Network:   Device-1: Intel 82579V Gigabit Network vendor: Micro-Star MSI driver: e1000e v: 3.2.6-k 
           port: f040 bus ID: 00:19.0 chip ID: 8086:1503 
           IF: eno1 state: up speed: 1000 Mbps duplex: full mac: <filter> 
Drives:    Local Storage: total: 126.11 GiB used: 55.61 GiB (44.1%) 
           ID-1: /dev/sda vendor: Kingston model: SA400S37120G size: 111.79 GiB speed: 6.0 Gb/s 
           serial: <filter> rev: B1E1 scheme: MBR 
           ID-2: /dev/sdb type: USB vendor: SanDisk model: Ultra USB 3.0 size: 14.32 GiB 
           serial: <filter> rev: 1.00 scheme: MBR 
Partition: ID-1: / size: 100.87 GiB used: 55.61 GiB (55.1%) fs: ext4 dev: /dev/sda1 
           ID-2: swap-1 size: 8.80 GiB used: 0 KiB (0.0%) fs: swap dev: /dev/sda2 
Sensors:   System Temperatures: cpu: 34.0 C mobo: N/A gpu: nvidia temp: 37 C 
           Fan Speeds (RPM): N/A gpu: nvidia fan: 50% 
Info:      Processes: 208 Uptime: 28m Memory: 5.80 GiB used: 1.22 GiB (21.0%) Init: systemd v: 239 
           Compilers: gcc: 8.2.1 Shell: bash (sudo) v: 4.4.23 running in: urxvtd inxi: 3.0.28 

```
I tried installing video-nvidia-390xx, and just uninstalling both, and going to video-linux, all to no avail.

I'm really out of my depth here. All the posts I find have different problems and/or arcane solutions that don't seem 
to do anything. (The problem with the config file was the only thing that actually seemed to do anything).

Can anybody help me with this? I'd really appreciate it.
