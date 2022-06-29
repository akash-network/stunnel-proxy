FROM nginx

COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/templates/default.conf.template

COPY configure.sh /configure.sh
RUN chmod +x /configure.sh

ENTRYPOINT ["/configure.sh"]

CMD ["nginx", "-g", "daemon off;"]
