# Permissions in Linux
## SSH Keys
### Generate SSH key
- Basic SSH key: `ssh-keygen -t rsa -b 4096`
- SSH key for Github `ssh-keygen -t rsa -b 4096 -C "your@email.com"` 

### Copy to server
```bash
ssh-copy-id user@server
``` 

### SSH Agent
To set up SSH agent to avoid retyping passwords, you can do two things:

1. Add an ssh config file (will be absent by default)
```bash 
vi ~/.ssh/config
```
```
Host [hostname]
    User [username]
    IdentityFile ~/.ssh/[key]
```

2. Add the key when starting bash:
```bash
echo "ssh-add ~/.ssh/id_rsa &>/dev/null" >> .bashrc
```

## Users and Groups
### Add user to group
`usermod -aG additional_groups username`

## Folder permissions
### Set permissions so everything in /var/www is readable and executable by all www-data members
#### Make it so that all files created in /var/www are owned by group www-data
`chmod g+s /var/www`

#### Set default permissions
`setfacl -d -m g::rx /var/www`

> Execute is not set on by default, even with the above. Not sure if it is needed for applications, will research later

  * https://www.linuxquestions.org/questions/linux-desktop-74/applying-default-permissions-for-newly-created-files-within-a-specific-folder-605129/
  * https://help.ubuntu.com/community/FilePermissions
  * https://chmod-calculator.com/
