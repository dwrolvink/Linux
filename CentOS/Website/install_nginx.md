# Install Nginx on CentOS
[Source](https://www.cyberciti.biz/faq/how-to-install-and-use-nginx-on-centos-7-rhel-7/)

Add the following content to `/etc/yum.repos.d/nginx.repo` to add the nginx repo:
```bash
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/mainline/rhel/7/$basearch/
gpgcheck=0
enabled=1
```

Install nginx:
```
yum install -y nginx

mkdir /etc/nginx/sites-available/
mkdir /etc/nginx/sites-enabled/
touch /etc/nginx/sites-available/default.conf

# Create webdirectory, and set ownership to www-data
mkdir /var/www
chmod 775 -R /var/www

# Add user nginx and own ssh user to www-data
groupadd www-data
usermod <ssh user> -a -G www-data
usermod nginx -a -G www-data
sudo chown -R :www-data /var/www/

# (Optional) Change default directory for ssh user
# <logged in as ssh user>
echo "cd /var/www" > ~/.bashrc
```

Add the following to the bottom of the http block in `/etc/nginx/nginx.conf`:
```bash
include /etc/nginx/sites-enabled/*.conf;
server_names_hash_bucket_size 64;
```

Set contents of `/etc/nginx/sites-available/default.conf` to:
```bash
server { 
	listen 80; 
	server_name yeetbox dwrolvink.com;
	
	location / { 
		root /var/www/dwrolvink.github.io;
		index index.html
		try_uri $uri $uri/ =404;
	}
	
	location /md/ {
		proxy_pass http://localhost:8081; 
	}
} 

```

Pull website to /var/www:
```bash
yum install -y git
cd /var/www
git clone https://github.com/dwrolvink/dwrolvink.github.io.git
```

Enable the default site and start nginx
```bash
ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf
systemctl enable nginx
systemctl start nginx
```

## Note
SELinux might be blocking proxy_pass. [You can turn SELinux off, or set it to permissive](https://linuxize.com/post/how-to-disable-selinux-on-centos-7/):

Add the following line to `/etc/selinux/config`: 
```bash
SELINUX=permissive
```
Then:
```bash
sudo shutdown -r now
#  Check
sestatus
```

## Activating Markserv
As you might have noticed in the `default.conf`, `/md/` reroutes to port 8081. The idea is that Markserv runs on this port.
Go to [Installing Markserv](https://github.com/dwrolvink/Linux/blob/master/CentOS/Website/install_markserv.md) to enable Markserv.

