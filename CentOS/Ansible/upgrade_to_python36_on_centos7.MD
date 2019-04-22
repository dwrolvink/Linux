```bash
# Run the following steps to go from a python2.7 ansible installation to python3.6 on centos 7
# This build will support winrm, ldap, and kerberos.
# See also the original (python2.7) build here [Ansible - Windows](https://github.com/dwrolvink/Linux/blob/master/CentOS/Ansible/Ansible.md)

su
  pip uninstall ansible
  yum -y install python36 python36-devel python36-setuptools openldap-devel
  sudo easy_install-3.6 pip
  pip3 install pywinrm pywinrm[kerberos] ansible python-ldap
exit
```
