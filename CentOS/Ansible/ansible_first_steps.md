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

Then, edit the windows group variable file:
```bash
sudo vi /etc/ansible/group_vars/windows
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
We now have an admin password in plain text, that is obviously not desirable. I'll first explain a simple way to encrypt passwords (bit ugly) [Source](https://stackoverflow.com/questions/30209062/ansible-how-to-encrypt-some-variables-in-an-inventory-file-in-a-separate-vault/44241343#44241343), and then continue on to a more structured solution. [Source](https://www.digitalocean.com/community/tutorials/how-to-use-vault-to-protect-sensitive-ansible-data-on-ubuntu-16-04).

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

## Structured string encryption
In the previous section, we've edited the windows.yaml file to include an encoded string. In this section, we'll be creating a directory structure instead of the one file:

```bash
# Old
/etc/ansible/group_vars/windows

# New
/etc/ansible/group_vars/windows/vars
/etc/ansible/group_vars/windows/vault
```
To convert our current setup to this new structure, do:
```bash
su
  # Rename windows to vars, and move it to ./windows/vars
  cd /etc/ansible/group_vars/
  mv windows vars
  mkdir windows
  mv vars windows/vars
  
  # Remove the password line
  vi /etc/ansible/group_vars/windows/vars.yaml # >remove the password line
  
  # Remove admin variable from the all file
  echo "" > /etc/ansible/group_vars/all  # (completely empties the all file)
exit
```
Now we're only missing the vault file, let's create it
```bash
sudo ansible-vault create windows/vault
```
Choose your vault password, and paste the following in the file that opens:
```yaml
---
vault_ansible_password: [Admin password]
```

Optionally, we can change the vars file, so it reflects which variables are in the vault file.
Below is how I've made it look (following the [source tutorial](https://www.digitalocean.com/community/tutorials/how-to-use-vault-to-protect-sensitive-ansible-data-on-ubuntu-16-04)):
```yaml
---
# non sensitive data
ansible_user: Administrator
ansible_connection: winrm
ansible_winrm_server_cert_validation: ignore

# sensitive data
ansible_password: "{{ vault_ansible_password }}"
```

### Test:
If everything is correct, you should see `ansible windows -m win_ping --ask-vault-pass` working as before.

You'd be forgiven to think that this password is received by the client in an encrypted fashion too, but the only encryption here is the SSH encryption. We can see the client has access to the plain text password by using the debug module:

```bash
ansible -m debug -a 'var=hostvars[inventory_hostname]' windows
```

This gives me:
```bash
[dorus@awx2 windows]$ ansible -m debug -a 'var=hostvars[inventory_hostname]' windows --ask-vault-pass
Vault password: 
win2019.domainlocal | SUCCESS => {
    "changed": false, 
    "hostvars[inventory_hostname]": {
        "ansible_check_mode": false, 
        "ansible_connection": "winrm", 
        "ansible_password": "[Cleartext admin password]", 
        "ansible_playbook_python": "/usr/bin/python2", 
        "ansible_user": "Administrator", 
        "ansible_version": {
            "full": "2.4.2.0", 
            "major": 2, 
            "minor": 4, 
            "revision": 2, 
            "string": "2.4.2.0"
        }, 
        "ansible_winrm_server_cert_validation": "ignore", 
        "group_names": [
            "windows"
        ], 
        "groups": {
            "all": [
                "win2019.domainlocal", 
                "awx.domainlocal"
            ], 
            "testgroup": [
                "awx.domainlocal"
            ], 
            "ungrouped": [], 
            "windows": [
                "win2019.domainlocal"
            ]
        }, 
        "inventory_dir": "/etc/ansible", 
        "inventory_file": "/etc/ansible/hosts", 
        "inventory_hostname": "win2019.domainlocal", 
        "inventory_hostname_short": "win2019", 
        "omit": "__omit_place_holder__a8e95f4f364e0233ae8c1ea0dbaa6a4fb0300fc4", 
        "playbook_dir": "/etc/ansible/group_vars/windows", 
        "vault_ansible_password": "[Cleartext admin password]"
    }
}
```

To make use of more advanced authentication methods, read on in [Ansible - Certificate Authentication](https://github.com/dwrolvink/Linux/blob/master/CentOS/Ansible/ansible_certificate_authentication.md), [Ansible - Kerberos Authentication](https://github.com/dwrolvink/Linux/blob/master/CentOS/Ansible/ansible_kerberos_authentication.md), or read the [Ansible Windows Docs](https://docs.ansible.com/ansible/latest/user_guide/windows_winrm.html#authentication-options).
