# Debian-base docker

The base image for debian-based dockers. Provides some common setup for running services in docker containers.

## Features

1. Customizable root password.
1. `en_US.UTF-8` locales.
1. Basic toolkit (`procps`, `wget`, `unzip`).
1. SSH server for external docker access.
1. Entrypoint script supporting:
    - One-time initialization script
    - Startup script for multiple services
    - Shutdown script for graceful shutdown
    - Sigterm shutdown support (on `Ctrl+C`, `docker stop`, etc)
    
## How to use

To use this image provide you own `Dockerfile` which is based on this image:

```
FROM l0coful/debian-base
```

You should provide three bash scripts for you image with required services:

1. `/bootstrap-init.sh` - this script will be run only once on first container start.
1. `/bootstrap-start.sh` - this script should runs all services required by the container in background.
1. `/bootstrap-stop.sh` - this script should gracefully stop all services run by the start script.

### Root password customization

To customize root password provide `ROOTPASS` environment variable during `docker run` command:

```
docker run -e "ROOTPASS=mypass" [...]
```

The default root password for this image is `root`.

### SSH access

To enable SSH access you need to bind exposed `22` port to the host container during `docker run` (in the example below container port `22` is bound to host `8022` port:

```
docker run -p 8022:22 [...]
```

The you can access docker container OS using SSH:

```
ssh -p 8022 root@host
```

## How to build

```bash
docker build --tag l0coful/debian-base .
```