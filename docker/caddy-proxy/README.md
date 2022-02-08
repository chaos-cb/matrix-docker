
# Caddy as Reverse Proxy

For an introduction to Caddy, see the web: https://caddyserver.com/docs/

## Service Description

### docker-compose.yml

#### Volumes

The Caddy Docker container uses two volumes: one for the **data** directory and one for the **config** directory.

According to https://caddyserver.com/docs/conventions the config directory does not need to be persisted, so it will stay as an **anonymous volume** and could be deleted without concerns (e.g. `docker-compose down -v`).

The **data directory however must not be treated as cache**.
That's why it is mounted as a **named volume** and marked as **external**. That way it is not possible to delete it accidentally (e.g. by executing docker-compose down -v). It also needs to be created manually in advance: `docker create volume proxy-caddydata`.

Instead of bind mounting the Caddyfile, we bind mount a directory instead, containing the Caddyfile. This is kind of a workaround for the case where you want to propagate changes in this file from host to container. Some editors (like vim) do not update files appropriately, instead they create a new file and copy it into the the place. However, this creates a new inode and effectively destroys the bind mount.

#### Network

This service will run on the named network `proxy-network`. Other services, which want to be accessible behind this reverse proxy need to join the same network (i.e. needs to be specified in the other service's docker-compose.yml files).

#### Ports

Obviously, we need to expose to the host machine all the ports at which we want our services to be accessible. Usually that would be at least 80 and 443.

### Caddyfile

The Caddyfile contains a `proxy` site block (with `proxy` being the hostname under which this service will be reachable within the Docker network). There we switch on the **ACME server** and the **internal CA**. You can use this to establish TLS within your infrastructure, i.e. your backend services can be configured to obtain a certificate from the CA running on the frontend reverse proxy. However, this is not part of this documentation. Check out this article in the Caddy community: https://caddy.community/t/use-caddy-for-local-https-tls-between-front-end-reverse-proxy-and-lan-hosts/11650

For every site (address/domain) the reverse proxy shall handle the Caddyfile needs to contain a corresponding site block. By specifying the site block, Caddy will take care of all the HTTPS stuff automatically (https://caddyserver.com/docs/automatic-https).

Within these site blocks there are directives which determine how to handle request for that site. Usually it will be the `reverse_proxy` directive, effectively forwarding the request to some backend service.

## Useful commands

Reload config while container is running

```
docker exec proxy caddy reload --config /etc/caddy/Caddyfile
```

(Optionally, you can include parameter `-d` to suppress outputs, e.g. when calling this command automatically from a script.)
