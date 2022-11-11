FROM debian:buster

ARG CONFD_VERSION=0.16.0
ARG TARGETARCH

COPY confd /etc/confd
COPY configure.sh /usr/local/configure.sh
ADD https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-${TARGETARCH} /usr/local/bin/confd

RUN \
    apt-get update \
 && apt-get -y --no-install-recommends \
        install \
        stunnel4 \
        tini \
 && chmod +x /usr/local/configure.sh \
 && chmod +x /usr/local/bin/confd \
 && rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "/usr/bin/tini", "--", "/usr/local/configure.sh" ]

CMD [ "stunnel" ]
