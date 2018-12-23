createNewSite()
{
    $website=${1}
    
    # Create website directory
    mkdir /var/www/$website

    # Configure site file
    SITE="\
    server {                              \n\
      listen 80 default_server;           \n\
      listen [::]:80 default_server;      \n\
      root /var/www/${website};           \n\
      index index.html;                   \n\
      server_name ${website};             \n\
      location / {                        \n\
        try_files $uri $uri/ =404;        \n\
      }                                   \n\
    }                                     \n\
    "
    # Write site configuration to sites-available
    sudo echo -e $SITE >> /etc/nginx/sites-available/${website}

    # Create symbolic link to sites-enabled. 
    # Note: this link must be done with full pathnames
    sudo ln -s /etc/nginx/sites-available/${website} /etc/nginx/sites-enabled/${website}
}

# CreateNewSite konishi.pcmrhub.com
