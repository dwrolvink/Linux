```bash
server {
        listen 443 ssl;

        ssl_certificate         /etc/ssl/certs/konishi.club.pem;
        ssl_certificate_key     /etc/ssl/private/konishi.club.key;

        server_name backend.konishi.club;

        location / {
                proxy_pass https://localhost:4000;

                proxy_set_header Host $host;
#               proxy_set_header Referer $https_referer;
#               proxy_set_header Scheme https;
        }
}

server {
        listen 443 ssl default_server;
        server_name konishi.club www.konishi.club;

        ssl_certificate         /etc/ssl/certs/konishi.club.pem;
        ssl_certificate_key     /etc/ssl/private/konishi.club.key;

        location / {
                index index.html;
                try_files $uri $uri/ =404;
                root /var/www/konishi.club;
        }
}

```
