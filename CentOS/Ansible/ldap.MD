```bash
# Test LDAP connection to server
ldapsearch -x  -h win2019.dwrolvink.com -D <username>@DWROLVINK -b "dc=dwrolvink,dc=com" -w <Password>
