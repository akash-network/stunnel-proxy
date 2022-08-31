FROM debian:buster

RUN apt-get update && apt-get -y --no-install-recommends install stunnel4

COPY configure.sh /usr/local/configure.sh
RUN chmod +x /usr/local/configure.sh

ENTRYPOINT [ "/usr/local/configure.sh" ]

CMD [ "stunnel" ]
