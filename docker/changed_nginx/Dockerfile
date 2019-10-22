FROM alpine:3.10.2
RUN apk update && apk add nginx=1.16.1-r0
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN mkdir -p /run/nginx/

ADD ./index.html /www/index.html
ADD ./index_nginx.conf /etc/nginx/conf.d/index_nginx.conf
RUN rm -rf /etc/nginx/conf.d/default.conf

EXPOSE 80:80
ENTRYPOINT ["nginx"]