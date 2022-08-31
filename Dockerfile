FROM traefik:v2.8

COPY traefik.toml /etc/traefik/traefik.toml
COPY dynamic.toml /etc/traefik/dynamic.toml
