#!/bin/bash

echo "Mounting NFS share..."
mkdir /tmp/www
sudo mount -o nolock 10.160.50.1:/var/www /tmp/www

echo "Configuring logpipe..."
mkfifo -m 600 /tmp/logpipe
cat <> /tmp/logpipe 1>&2 &
CPID=$!

echo "Starting PHP runtime..."
serve --enable-dynamic-workers --workers=50 public/index.php &
SPID=$!

echo "Wuhoo, started runtime..."
wait -n $CPID $SPID
