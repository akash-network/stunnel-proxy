FROM debian:buster

RUN apt-get update && apt-get -y --no-install-recommends install stunnel4

COPY confd /etc/confd
COPY configure.sh /usr/local/configure.sh
RUN chmod +x /usr/local/configure.sh

ADD https://github.com/kelseyhightower/confd/releases/download/v0.16.0/confd-0.16.0-linux-amd64 /usr/local/bin/confd
RUN chmod +x /usr/local/bin/confd

ENTRYPOINT [ "/usr/local/configure.sh" ]

CMD [ "stunnel" ]
