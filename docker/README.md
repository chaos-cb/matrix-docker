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
    -v synapse-data:/data \
    -v synapse-media:/data/media_store \
    -e SYNAPSE_SERVER_NAME=DOMAIN.TLD \
    -e SYNAPSE_REPORT_STATS=no \
    matrixdotorg/synapse:latest generate
```
