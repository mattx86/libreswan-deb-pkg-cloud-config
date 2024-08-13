#!/bin/bash

apt-get install -y nginx
ufw allow http
ufw allow https
DEB_DIR="/root"
DEB_FILE="$(basename $(ls -1 $DEB_DIR/libreswan_5.0*.deb))"
ADDRESSES=$(ip addr | grep -P 'inet (?!127)' | awk '{sub(/\/[0-9]+/, "", $2); print $2}')
/bin/mkdir /var/www/html/libreswan
/bin/mv $DEB_DIR/$DEB_FILE /var/www/html/libreswan/${DEB_FILE}
cd /var/www/html/libreswan
sha256sum -b $DEB_FILE >${DEB_FILE}.sha256
openssl req -nodes -newkey rsa:2048 -keyout /etc/ssl/private/libreswan.deb.key -out /tmp/libreswan.deb.csr -subj "/C=XX/ST=Unknown/L=Unknown/O=Unknown/OU=Unknown/CN=libreswan.deb"
openssl x509 -signkey /etc/ssl/private/libreswan.deb.key -in /tmp/libreswan.deb.csr -req -days 365 -out /etc/ssl/certs/libreswan.deb.crt
echo '
server {
	listen 80 default_server;
	listen [::]:80 default_server;
	listen 443 ssl default_server;
	listen [::]:443 ssl default_server;
	ssl_certificate /etc/ssl/certs/libreswan.deb.crt;
	ssl_certificate_key /etc/ssl/private/libreswan.deb.key;
	root /var/www/html;
	default_type text/plain;
	index index.html index.nginx-debian.html;
	server_name _;
	location / {
		autoindex on;
		try_files $uri $uri/ =404;
	}
}' > /etc/nginx/sites-enabled/default
systemctl restart nginx
echo
echo "===================================="
echo "Get the LibreSwan .DEB package at:"
for ADDRESS in $ADDRESSES; do
  echo "http://${ADDRESS}/libreswan/${DEB_FILE}"
  echo "https://${ADDRESS}/libreswan/${DEB_FILE}"
done
echo "===================================="
echo
