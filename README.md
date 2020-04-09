# gae-php-development-environment
A development environment for App Engine Standard 2nd Generation Runtimes, running on App Engine itself, to give the closest emulation of how a real deployed service will behave, while allowing full access to all of the cloud services available in GCP.

### Architecture
This repository pairs with https://github.com/a1comms/ssh-reverse-concentrator , as you'll see, since we need to use an outbound connection from App Engine instances, we need a service to accept those connections and use them to provide a reverse shell.

The basic connection flow looks like this:
```
App Engine Instance (relay endpoint) -> HTTPS/WebSocket -> relay-server (GCE?) <- SSH connection <- your SSH client, sftp, rsync, etc.
```

And an rsync flow that continually keeps a folder synchronised to your remote instance works like this:
```
lsyncd (rsync with inotify watch) -> relay-server (GCE) -> App Engine Instance ( relay endpoint -> Go based SSHd -> static rsync binary) -> /tmp (tmpfs)
```

Since the only writable filesystem on the instances is `/tmp` as `tmpfs` (in RAM), we reload nginx on startup to serve files from `/tmp` instead.

This also means we need to use a bigger instance size than normal, as all your application files need to fit into RAM, while leaving enough RAM free for the application to run, too.

You'll note that we also set `maximum_instances` to `1` in `app.yaml` and this is because you can't realistically sync more than one instance at once, so we restrict each version to a single instance.

Because of this, each development environment "version", is designed to be deployed & used (including web access) by only a single developer at any one time.

To handle this, we deploy statically named version for each developer (e.g. "dev-smelrose") and use IAP to enforce access controls.

### Setup

This guide assumes you already have the relay server running and exposed, as that is beyond the scope of this guide.

1. Clone `gae-php-development-environment` and `cd` into the folder.
2. Copy `endpoint-config.example.yaml` to `endpoint-config.yaml` and configure it
    * Generate a server key with `ssh-keygen`: `ssh-keygen -t rsa -f ./host_key`
    * Copy the contents of the file `host_key` just generated into the `serverKey` variable of `endpoint-config.yaml`
    * Make sure you have your own SSH key, or if not, create on with `ssh-keygen -t rsa`
    * Copy the contents of `~/.ssh/id_rsa.pub` into an array element of `allowedClientKeys` in `endpoint-config.yaml`
3. Copy `nginx-additional-rewrites.example.conf` to `nginx-additional-rewrites.conf` to configure it
    * Any static folders or assets that you'd like to be exposed need to be listed here, in the same format as the others
    * It should be pre-configured for a basic Laravel install
4. Edit `app.yaml` to add the service name if required, e.g. `service: example`
5. Deploy to App Engine: `gcloud app deploy --project={development-project} --no-promote ./app.yaml --
version=dev-{username}`
    * We recommend using an isolated project specifically for development environments, rather than mixing it with your production versions.
6. Visit the URL specifically assigned to that version (can be found in Cloud Console)
7. Check it is connected to the relay (you can call /status.json), see https://github.com/a1comms/ssh-reverse-concentrator
8. Develop on your instance: ssh, rsync, lsyncd
    * You can't get an interactive shell on the instance, as `/dev/fd` isn't mounted: instead, try to run commands, e.g. `ssh -p 7801 root@localhost ls /tmp`
    * When calling rsync (directly or via lsyncd), remember to set the remote binary path of `/tmp/rsync`, as it isn't installed natively.
