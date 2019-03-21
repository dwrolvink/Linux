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
```

Set contents of `/etc/nginx/sites-available/default.conf` to:
```bash
upstream my_server {
   server 127.0.0.1:8080;
}

server { 
 listen 80; 
 server_name web001;
 location / { 
    proxy_pass http://my_server;
  }
  location /md/ {
	  proxy_pass http://127.0.0.1:8081;
  }

} 
```
Add the following to the bottom of the http block in `/etc/nginx/nginx.conf`:
```bash
include /etc/nginx/sites-enabled/*.conf;
server_names_hash_bucket_size 64;
```
Enable the default site and start nginx
```bash
ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf
systemctl enable nginx
systemctl start nginx
```

## Note
SELinux might be blocking proxy_pass. [You can turn SELinux off, or set it to permissive](https://linuxize.com/post/how-to-disable-selinux-on-centos-7/)


