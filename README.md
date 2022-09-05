# Stunnel Proxy

An extremely flexible proxy container using Stunnel. Useful if you want to limit access and encrypt the connection from one server to another.

This is particularly useful for Akash - you can deploy this container alongside any other deployment, and use it to securely proxy a connection from another location.

## How to use

To securely proxy the connection from one location to another, you run two instances of this container. One is deployed alonside the secure service you want to connect TO. The other is deployed in `client` mode on the server you want to connect FROM.

You can proxy as many services as required - the `STUNNEL_SERVICE_*` environment variables are dynamic. For example a set of `STUNNEL_SERVICE_WEB_*` variables will create one 'target' named `web`, and `STUNNEL_SERVICE_FOOBAR_*` will create another target named `foobar`.

See Stunnel docs for all available configuration options, but the main variables you need are `*_CLIENT`, `*_ACCEPT` and `*_CONNECT`.

We will use a simple web based container as an example. Note the example uses docker-compose but this can be applied to any method of running containers.

### Server (the location you want to connect TO)

The docker-compose.yml below will deploy a `web` service with a private web server exposed on port `80`. A second `stunnel` service  is deployed alongside, which allows connections on port `8080` and proxies them to the `web` service on port `80`.

Note the `web` service does not expose any public ports. The only way to access the `web` container is via the `stunnel` container on port `8080`.

The `PSK` environment variable is a 'pre shared key', and should be identical on your client deployment.

The `CLIENT=no` variable tells Stunnel that this service is receiving connections, not sending them.

```
services:
  web:
    image: traefik/whoami
  stunnel:
    image: ghcr.io/ovrclk/stunnel-proxy:v0.0.1
    environment:
      - PSK=DmtaC6N3HOWFkJZpNZs2dkabFT5yQONw
      - STUNNEL_SERVICE_WEB_CLIENT=no
      - STUNNEL_SERVICE_WEB_ACCEPT=8080
      - STUNNEL_SERVICE_WEB_CONNECT=web:80
    ports:
      - '8080:80'
```

### Client (the location you want to connect FROM)

The docker-compose.yml below will deploy a `stunnel` service which connects to your `stunnel` server on 1.2.3.4:8080. Replace `1.2.3.4` with the IP or DNS name where you deployed the Server services above. Port `8080` matches the `ACCEPT` and exposed ports in the example above.

The `PSK` variable is the 'pre shared key' and should match the server deployment.

The `CLIENT=yes` variable tells Stunnel this service is sending connections.

```
services:
  stunnel:
    image: ghcr.io/ovrclk/stunnel-proxy:v0.0.1
    environment:
      - PSK=DmtaC6N3HOWFkJZpNZs2dkabFT5yQONw
      - STUNNEL_SERVICE_WEB_CLIENT=yes
      - STUNNEL_SERVICE_WEB_ACCEPT=0.0.0.0:8080
      - STUNNEL_SERVICE_WEB_CONNECT=1.2.3.4:8080
    ports:
      - '8080:8080'
```

On your client server, you will now be able to access the `web` service from the Server deployment, via http://localhost:8080. This connection is encrypted, and can only be accessed due to the correct `PSK` variable.