# Pterodactyl Wings #

## Disclaimer ##
As with anything else, exposing your system to the Internet incurs risks!  This container does its best to be as secure as possible, but makes no guarantees to being completely impenetrable.  Use at your own risk, and feel free to suggest changes that can further increase security.

## About ##
The Pterodactyl project is an impressive one to me, but I wanted a way to make use of it in Unraid without installing it to the system.  Thus, this set of containers was born.  Wings specifically uses the official [Docker in a Docker](https://hub.docker.com/_/docker) image to connect to the host Docker environment and maximize performance.

## Features ##
* Built on Alpine Linux for a minimal footprint
* Connects to the host's docker.sock to provide maximum performance

## Configuration ##
Because of how the Docker works while containerized in this fashion, any files accessed by Docker **MUST** share the same path in the container as on the host!  If you fail to mirror the host path to the container path, containers cannot be created.

Additionally, a requirement of the Docker-in-Docker container is for it to be run in Privileged mode, so make sure `--privileged` is part of the run command.

### Variables ###
| Variable | Default | Note | Example |
|----------|---------|------|---------|
| DATADIR | /var/lib/pterodactyl | Used to mirror container data path to host data directory | `-e DATADIR="/path/to/configfolder"` |

### Volumes ###
| Volume | Note | Example |
|--------|------|---------|
| /var/run/docker.sock | Grants container access to the Docker sockfile | `-v "/var/run/docker.sock":"/var/run/docker.sock"` |
| /var/lib/docker | Grants container access to the Docker application files | `-v "/var/lib/docker/":"/var/lib/docker"` |
| /tmp/pterodactyl | While not necessary, this can help reduce the Docker image size | `-v "/tmp/pterodactyl":"/tmp/pterodactyl"` |
| /le-ssl | This is not a published volume, but is useful for providing an external cert to Wings | `-v "/letsencrypt/cert/directory":"/le-ssl"` |
| DATADIR | This is a dynamic mount path used to mirror the host Docker volume path to the container | `-v "/var/lib/pterodactyl":"/var/lib/pterodactyl"` |

### Ports ###
| Port | Note | Example |
|------|---------|---------|
| 2022 | SFTP port | `-p 2022:2022/tcp` |
| 8080 | Wings service port | `-p 8080:8080/tcp` |

## Setup ##
The majority of this container's setup takes place in the mapping of volumes.  Once that is complete, all that is left is to provide a completed config.yml in `DATADIR`, which is created in Panel.  It is important to note that some of the paths provided in the config file may need to be manually edited to point to the correct location.  Pay attention to any errors Wings generates - if they're stating an issue with a directory, verify that it's actually using the right one.

Example run command:

    docker run \
        --privileged \
        --name="Wings" \
        -v "/var/run/docker.sock":"/var/run/docker.sock" \
        -v "/var/lib/docker/":"/var/lib/docker" \
        -v "/tmp/pterodactyl":"/tmp/pterodactyl" \
        -v "/var/lib/pterodactyl":"/var/lib/pterodactyl" \
        -v "/letsencrypt/cert/directory":"/le-ssl" \
        -p 2022:2022/tcp \
        -p 8080:8080/tcp \
    gethec/pterodactyl-wings