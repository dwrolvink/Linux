# Home key prints character instead of going to home
[Source](https://wiki.archlinux.org/index.php/Home_and_End_keys_not_working)

### 1. Check local settings

Do `cat /etc/inputrc` on your local machine, and look at the "beginning of line" records. I have:
```bash
"\e[1~": beginning-of-line
"\e[7~": beginning-of-line
```

### 2. Check remote settings

Here, I only have:
```bash
"\e[1~": beginning-of-line
```

### 3. Add missing lines

When I added the missing line on the remote host and logged in again, the home key worked again.
