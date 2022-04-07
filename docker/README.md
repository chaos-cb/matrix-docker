# Docker-compose services

## Reverse proxy

The idea of this docker-compose setup is to run Matrix **behind a separate, standalone reverse proxy**. Because you may want to have additional services running on the same host in the future (or you do already). 

**If you have a reverse proxy running already (often nginx is used):**

1. Adapt the network for the synapse service in the docker-compose.yml as necessary. Your reverse proxy must be able to reach the synapse service on port 8008. If your existing reverse proxy is dockerized, make sure that they are configured to be in the same Docker network. If your existing reverse proxy is not dockerized, you may have to forward the port 8008 of the synapse service to the host, so that the reverse proxy can forward to that port.
2. Proceed with the Matrix setup instructions below

**If you don't have a reverse proxy yet you can use the Caddy proxy as follows:**

1. Rename or copy `etc-caddy/Caddyfile.sample` to `etc-caddy/Caddyfile` and adjust it to your needs
2. Create Docker volume for caddy data: `docker volume create proxy-caddydata`
3. Start reverse proxy service: `docker-compose up -d`
4. Proceed with the Matrix setup instructions below

One of the advantages of Caddy is, that it automatically takes care of acquiring Let's Encrypt certificates whenever needed.

For more information on the usage of Caddy as reverse proxy, see [caddy-proxy/README.md](caddy-proxy/README.md)


## Matrix setup instructions

### Generate homeserver.yaml

Check out the synapse docker documentation on https://hub.docker.com/r/matrixdotorg/synapse

To generate a config stub, run the following command:

```
docker run -it --rm \
    -v ${PWD}/data/:/data \
    -v synapse-media:/data/media_store \
    -e SYNAPSE_SERVER_NAME=lab.chaos-cb.de \
    -e SYNAPSE_REPORT_STATS=no \
    -u 991:991 \
    matrixdotorg/synapse:latest generate
```

### Adapt homeserver.yaml to your needs

to be added


### Startup

```
docker-compose up -d
```

Right after the containers are started, we need to fix the owner of the media_store directory. For whatever reason, when Docker attaches the media volume the /data/media_store directory will be owned by root. This will lead to permission errors when users try to upload files.

Fix this by running the following command (needs to be done only once):

```
docker exec -it matrix-synapse chown 991:991 /data/media_store
```

## Matrix registration addon

This is a simple Python application enabling token-based registration.

See https://github.com/zeratax/matrix-registration for more details and documentation.

It's configured in the docker compose file as additional service `matrix-registration`. The reverse-proxy `Caddyfile` is configured accordingly to forward requests to `/register` to this application. So you can just point your user to DOMAIN.TLD/register for them to create an account.

This registration addon also has an `/api/token` endpoint to create/disable/list tokens. However, for security reasons this endpoint is not routed/forwarded by the reverse proxy (i.e. not configured in the `Caddyfile`). More on this in the documentation: https://github.com/zeratax/matrix-registration/wiki/reverse-proxy

In order to access this endpoint (e.g. to create tokens), please do this from the Docker host machine. For this, the addon's port 5000 is forwarded to the host (in docker compose file). Make sure that this port is not exposed to the internet (check the host's firewall).

There is a convenience bash script [data-registration/create_token.sh](data-registration/create_token.sh), which was taken from the matrix-registration documentation as well: https://github.com/zeratax/matrix-registration/wiki/script-examples

### Configuration

Create a `config.yaml` based on [data-registration/config.sample.yaml](data-registration/config.sample.yaml) and adapt to your needs. You mainly have to adapt

- `server_location`
- `server_name`
- `registration_shared_secret`
- `admin_api_shared_secret`

See also the documentation for the addon configuration on Github: https://github.com/zeratax/matrix-registration/wiki#configuration

