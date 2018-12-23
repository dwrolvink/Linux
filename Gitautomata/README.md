# Gitautomata
The goal of this package (this folder), is to automate everything git related.

Ther current state of the script is to get the code for the back- and frontend of [Konishi](https://github.com/konishi-project) and to get everything running again afterwards.

The pull is done in such a way that all potential changes on the server side will be overwritten with
whatever is on the github repository, but it leaves all the untracked files (such as uploaded images,
db, etc). 

A couple of config files are saved to ./zimmerman/ and ./higala (not in this repo), and those are
copied back after the freshpull to keep necessary server config working, that is not in the 
repository.

All the files prefixed with _ will be dot sourced to every script file.
