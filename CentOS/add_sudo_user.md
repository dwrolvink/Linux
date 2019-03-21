# Add user and add it to the sudo group
[Source](https://www.digitalocean.com/community/tutorials/how-to-create-a-sudo-user-on-centos-quickstart)

```bash
su
  useradd <user>
  passwd <user>
  usermod -aG wheel <user>
exit
```
