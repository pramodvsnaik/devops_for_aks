FROM nginx:stable-alpine3.23-perl

RUN apt-get update

COPY index.html /var/www/html/

EXPOSE 80

CMD ["nginx","-g" "daemon off;"]