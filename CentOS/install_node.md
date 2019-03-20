# Installing NodeJS on Centos
[Source]()

```bash
# Add node repo, install make tools
yum install -y gcc-c++ make
curl -sL https://rpm.nodesource.com/setup_11.x | sudo -E bash -

# Install nodejs
sudo yum install -y nodejs

# Install yarn
 curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
 sudo yum install yarn
```

## Notes
Centos7 is a weird duck in the lake. It ships with firewalld enabled. To reach a hosted website from another machine, disable firewalld with
```bash
systemctl stop firewalld
```

Or just open the port:
```bash
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --reload
```
