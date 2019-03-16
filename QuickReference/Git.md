# git

#### Change location of repository
`git remote set-url origin <url>`

#### List repository locations
`git remote`

#### Add remote location
`git remote add <nickname-for-repo> <url>`

#### Add all files to tracker
`git add .` 

## Add github ssh key
```
# generate key
ssh-keygen -t rsa -b 4096 -C "your@email.com"
# change save filename
/home/dorus/.ssh/github
# enter passphrase
#
# I got Could not open a connection to your authentication agent. So the following two lines
# Is to fix that
ssh-agent bash
ssh-agent -s

# Add key to profile
ssh-add ~/.ssh/github

cat ~/.ssh/github.pub
# copy the string and add it to github
