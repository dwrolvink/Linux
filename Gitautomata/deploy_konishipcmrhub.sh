#!/bin/bash
 
 . nginx/new_site.sh
 
 # Install nginx if not yet installed
 # -----
 if [ ! -d "/etc/nginx" ]; then
    . nginx/install_nginx.sh
 fi
 
 # Create website folders/records
 # -----
 createNewSite konishi.pcmrhub.com
 
 # Get files from github
 # -----
 
 
