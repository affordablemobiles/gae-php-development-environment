#!/bin/bash

echo "Starting SSH Development Endpoint..."
/srv/reverse-ssh-endpoint -c /srv/endpoint-config.yaml;

echo "Starting PHP runtime..."
serve --enable-dynamic-workers public/index.php &
WPID=$!;

echo "Sleeping while runtime starts..."
sleep 1;

echo "Copying template folder to development webroot..."
cp -r /srv/template /tmp/srv;

echo "Adjusting nginx configuration..."
php regex-nginx.php;

echo "Reloading nginx..."
nginx -c /tmp/google-config/nginx.conf -t && nginx -c /tmp/google-config/nginx.conf -s reload;

echo "Downloading rsync binary..."
wget -O /tmp/rsync https://storage.googleapis.com/a1-alpha.appspot.com/rstatic/rsync;

echo "Preparing rsync binary..."
chmod 755 /tmp/rsync;

echo "Wuhoo! Development Environment Ready!"
wait $WPID;