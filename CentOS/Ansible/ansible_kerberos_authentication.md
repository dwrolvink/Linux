## Kerberos Authentication
[Source](https://docs.ansible.com/ansible/latest/user_guide/windows_winrm.html#id9)

### Setup
The setup is the same as the [main setup](https://github.com/dwrolvink/Linux/blob/master/CentOS/Ansible/ansible_certificate_authentication.md), only from hereon I'll have ADDS installed on the Windows machine, and promoted it to the sole DC for `dwrolvink.com` domain. I then made a new user, `dorus@dwrolvink.com` and gave it administrative access.

### (Windows) Setup DNS Reverse Lookup
I noticed that reverse lookup zones are not automatically installed, but we need this for Kerberos to work.

- Open DNS Manager
- Rightclick Reverse Lookup Zones > New Zone
- Use default settings, except for `Network ID: 192.168.178` (the IP of my win2019 machine is 192.168.178.107)
- Open the newly created reverse lookup zone, and add a PTR record: `Host Ip Address: 192.168.178.107; Hostname: win2019.dwrolvink.com`

### (Ansible) Test reverse lookup zone
Do `nslookup 192.168.178.107`. Before I set up the reverse lookup zone the result was `win2019.[router dns zone]`. After setting up the reverse lookup zone it returned the correct value: `win2019.dwrolvink.com`.

### (Ansible) Install Krb5 support
```bash
sudo yum -y install python-devel krb5-devel krb5-libs krb5-workstation
sudo yum -y install gcc
sudo pip install pywinrm[kerberos]
```

### (Ansible) Setup Krb configuration
Open `/etc/ansible/windows/vars` And change the contents to something like this:
```yaml
---
ansible_user: dorus@DWROLVINK.COM
ansible_password: "{{ vault_ansible_password }}"
ansible_connection: winrm
ansible_winrm_transport: kerberos
ansible_winrm_server_cert_validation: ignore
```
> Note: Proper Capitalization is a pretty big deal

Open `/etc/krb5.conf` and under `[realm]`, make sure it looks like the following:
```ini
[realms]
 DWROLVINK.COM = {
  kdc = win2019.dwrolvink.com
  admin_server = win2019.dwrolvink.com
 }

[domain_realm]
 .dwrolvink.com = DWROLVINK.COM
```
### Test:
```bash
ansible windows -m win_ping --ask-vault-pass
```
