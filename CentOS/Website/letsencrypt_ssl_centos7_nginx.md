# Installing SSL on your website hosted by nginx on Centos 7
First, make sure that your firewall allows https and http traffic (80/tcp, 443/tcp). 
Then, on the webserver, make sure that centos allows these ports as well:

```bash
firewall-cmd --list-ports 

# Output should be (at least) 80/tcp 8081/tcp 443/tcp
# If output is correct, you don't have to do the following

firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=443/tcp
firewall-cmd --reload
```
Below are the instructions for installing an SSL certificate and automatically configuring nginx. 
See [https://certbot.eff.org/instructions](https://certbot.eff.org/instructions) for the most up to date instructions.

```bash
# Install certbot
yum install certbot python2-certbot-nginx

# Run certbot. I chose all the standard options. 
certbot --nginx

# Add certbot to crontab to automatically renew
echo "0 0,12 * * * root python -c 'import random; import time; time.sleep(random.random() * 3600)' && certbot renew" | sudo tee -a /etc/crontab > /dev/null
```
