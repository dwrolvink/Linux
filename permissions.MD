# Permissions in Linux

##Set permissions so everything in /var/www is readable and executable by all www-data members
### Make it so that all files created in /var/www are owned by group www-data
`chmod g+s /var/www`

### Set default permissions
`setfacl -d -m g::rx /var/www`
| Execute is not set on by default, even with the above. Not sure if it is needed for applications, will research later

  * https://www.linuxquestions.org/questions/linux-desktop-74/applying-default-permissions-for-newly-created-files-within-a-specific-folder-605129/
  * https://help.ubuntu.com/community/FilePermissions
  * https://chmod-calculator.com/
