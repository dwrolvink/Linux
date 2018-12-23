#!/bin/bash
# ---------------------------
# Creating a webserver in Nginx on Manjaro linux
# ---------------------------
# Written for: Manjaro, 2018-12-23
# Written by : D.W. Rolvink
# ---------------------------
# Steps:
# - Configuration for this script
# - Install Nginx
# - Setup folders, and privileges
# - Create site config file
# ---------------------------

# Config
# ---------------------------
$website='konishi.pcmrhub.com'
$mainUser='dorus'

# Install nginx
# ---------------------------
sudo pacman -S nginx

# Create proper folders
# ---------------------------
# Create website directory
sudo mkdir /var/www/$website

# Create sites directories
sudo mkdir /etc/nginx/sites-available/
sudo mkdir /etc/nginx/sites-enabled/

# Set rights
# ---------------------------
# Create www-data group, and add main user to it
sudo groupadd www-data
sudo usermod $mainUser -a -G www-data

# Give www-data rights to everything in /var/www/
sudo chown -R :www-data /var/www/

