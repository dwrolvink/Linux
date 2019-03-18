# Ansible (in CentOS)
## Setup
```yaml
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

# https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html#id10
cd /etc/ansible
su
  mkdir group_vars
  mkdir host_vars
exit

# Fill our ansible hosts file with a testserver
su
    cp /etc/ansible/hosts /etc/ansible/hosts_backup
    echo -e "[testgroup]\ntest.domainlocal" > /etc/ansible/hosts
exit
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

## Hello World Playbook
In the installation step we've already made a playbook folder. It doesn't matter where you create this folder btw.

Let's create a playbook in that folder, called HelloWorld.yml. [Source](https://codingbee.net/ansible/ansible-a-hello-world-playbook).

```bash
vi ~/ansible/playbooks/HelloWorld.yml
```
Paste:
```yaml
---
- name: This is a hello-world example
  hosts: testgroup
  tasks: 
  - name: Create a file called '/tmp/testfile.txt' with the content 'hello world'.
    copy: 
      content: "hello world\n" 
      dest: /tmp/testfile.txt
```
> Note: you could also just call the testserver directly by writing `hosts: test.domainlocal`

Now run this playbook: `ansible-playbook HelloWorld.yml`

The output should be like the following:

```
PLAY [This is a hello-world example] *******************************************

TASK [Gathering Facts] *********************************************************
ok: [test.domainlocal]

TASK [Create a file called '/tmp/testfile.txt' with the content 'hello world'.] ***
ok: [test.domainlocal]

PLAY RECAP *********************************************************************
test.domainlocal              : ok=2    changed=0    unreachable=0    failed=0   
```

# Connect to Windows PCs
[Source](https://www.ansible.com/blog/connecting-to-a-windows-host)
## Setup
```yaml
- Server1
  - Name: Controller
  - OS: CentOS
  - Network name: contr.domainlocal
- Server2
  - Name: Testserver
  - OS: Windows Server 2019 (Desktop)
  - Network name: win2019.domainlocal
```

## Enable access on the Windows machine
Run the following script in powershell (admin): `https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1`

## Install extra package on the Ansible controller machine
[Source](https://linuxize.com/post/how-to-install-pip-on-centos-7/)
```bash
su
    yum install epel-release
    yum install python-pip
    pip install --upgrade pip
    pip install pywinrm
exit
```

## Add a windows group to your Ansible hosts file
```bash
sudo vi /etc/ansible/hosts
```
Paste:
```
[windows]
win2019.domainlocal
```
```bash
sudo vi /etc/ansible/group_vars/windows.yaml
```
Paste:
```yaml
---
ansible_user: [Admin user on windows]
ansible_password: [Admin password]
ansible_connection: winrm
ansible_winrm_server_cert_validation: ignore
``` 

## Test
```bash
ansible windows -m win_ping
```

# Password encryption
We now have an admin password in plain text, that is obviously not desirable. I'll first explain a simple way to encrypt passwords (bit ugly) [Source](https://stackoverflow.com/questions/30209062/ansible-how-to-encrypt-some-variables-in-an-inventory-file-in-a-separate-vault/44241343#44241343), and then continue on to a more structured solution. [Source](http://duffney.io/SecureGroupVarsWithAnsibleValut).

## Simple string encryption
```bash
# Encrypt the string "[admin password]"
ansible-vault encrypt_string [admin password] --ask-vault-pass

# Create a file in /etc/ansible/group_vars called all (will always be loaded)
sudo vi /etc/ansible/group_vars/all
```
Paste (change everything behind the colon with your result from the previous step):
```yaml
windows_admin_password: !vault |
    $ANSIBLE_VAULT;1.1;AES256
    66386439653236336462626566653063336164663966303231363934653561363964363833
    3136626431626536303530376336343832656537303632313433360a626438346336353331
```

Change line 2 in `/etc/ansible/group_vars/windows` to: 
```bash
ansible_password: "{{ windows_admin_password }}"
```

### Test:
`ansible windows -m win_ping --ask-vault-pass`
