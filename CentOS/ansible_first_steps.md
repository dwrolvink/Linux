# Ansible (in CentOS)
## Setup
```
- Server1
  - Name: Controller
  - OS: CentOS
  - Network name: contr.domainlocal
- Server2
  - Name: Testserver
  - OS: CentOS
  - Network name: test.domainlocal
```

## Installing Ansible
```bash
# Actual installation
sudo yum install ansible

# Make some folders to put our files in
cd
mkdir ansible
cd ansible
mkdir playbooks

# Fill our ansible hosts file with a testserver
su
cp /etc/ansible/hosts /etc/ansible/hosts_backup
echo -e "[testgroup]\ntest.domainlocal" > /etc/ansible/hosts
```

## Setup connection
Make sure the username you are logged in with at the control server exists at (all) the testserver(s), and that it has sudo priviledges. [How to add a sudo user to CentOS](https://github.com/dwrolvink/Linux/blob/master/CentOS/add_sudo_user.md).

```bash
# Make a private key
ssh-keygen -t rsa -b 4096

# Send it to the testserver
ssh-copy-id -i ~/.ssh/id_rsa test.domainlocal
```

## Check connection
For a simple connections check, do: `ansible all -m ping`
