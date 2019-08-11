# Installing Ansible with Winrm[kerberos] support in a virtual env
At work, I am trying to set up Windows management via Ansible. To do this, I got access to a Linux VM from the Linux team.
This means I don't have sudo privileges, and that I'm not allowed to 'contaminate' their management server; I need to keep all
the changes local to my profile.

There are some packages that the sysadmin needs to install for all of this to work though. All of that is contained within the 
first section below.

The rest of these changes should be doable without an elevated account and can get you setup to start testing Windows management
with Ansible over Kerberos and WinRM.

### Install global prerequisites
Get your sysadmin to install the following packages
```bash
# Install packages needed for pywinrm[kerberos]
sudo yum -y install python-devel krb5-devel krb5-libs krb5-workstation

# Install pip if not yet installed
sudo yum install python-pip

# Install virtualenv if not yet installed
pip install virtualenv
```
### Install required python packages
Next, we create a virtual environment to keep our addons separated from the global machine. 
In this venv, we install the python packages that we need for winrm/kerberos

```bash
virtualenv wans
source wans/bin/activate
  pip install pywinrm
  pip install pywinrm[kerberos]
  pip install ansible
deactivate
```
### krb5.conf
Then, we need to alter the krb5.conf file to include our windows domain.
We can't edit the main file, so we'll create a new file, and point to it before running Ansible.
```bash
cp /etc/krb5.conf ~/krb5.conf
vi ~/krb5.conf 
```
Add realm and domain:
```bash
[realms]
    MY.DOMAIN.COM = {
        kdc = domain-controller1.my.domain.com
    }
[domain_realm]
    .my.domain.com = MY.DOMAIN.COM
    my.domain.com  = MY.DOMAIN.COM
```
Run the following command to use the new file. To have this be persistent, add the line to your .bashrc file. 
```bash
export KRB5_CONFIG=/home/<username>/krb5.conf
```
### Create an Ansible playbook
Let's first create a simple playbook, which includes all the necessary variables:
```bash
mkdir ~/wansible; cd ~/wansible
vi win_ping.yml
```
```yml
- hosts: all
  gather_facts: no # not important atm
  vars:
    ansible_user: username@MY.DOMAIN.COM
    # ansible_password: Password  # set in extra vars
    ansible_connection: winrm
    ansible_winrm_transport: kerberos
  tasks:
    - win_ping:
```
### Run Ansible Playbook
```bash
source ~/wans/bin/activate
  ansible-playbook ~/wansible/win_ping.yml -i server01.my.domain.com, -e ansible_password='blabla'
deactivate #when you're done
```
