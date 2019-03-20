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
touch /etc/nginx/sites-available/default
```

```bash
SITE="\
server {                              \n\
  listen 80;                          \n\
  listen [::]:80;                     \n\
  server_name backend.konishi.club;   \n\


  location / {                                        \n\
    proxy_pass http://localhost:8080;                \n\
    proxy_set_header Host $host;                      \n\
  }                                   \n\
  
  location /md/ {                                        \n\
    proxy_pass http://localhost:8081;                \n\
    proxy_set_header Host $host;                      \n\
  }                                   \n\  
}                                     \n\
"
    
echo $SITE > /etc/nginx/sites-available/default
```
