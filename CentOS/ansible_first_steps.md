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
```
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

