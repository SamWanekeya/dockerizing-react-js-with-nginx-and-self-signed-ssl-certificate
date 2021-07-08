# base image
FROM node:16.2.0-alpine as builder

# send signal to containers to stop them
STOPSIGNAL SIGTERM
# create working directory
RUN mkdir -p /usr/src/reactapp
# set working directory
WORKDIR /usr/src/reactapp
# copy package.json file to working directory
COPY package*.json ./
# install dependencies with precise, for more stories visit - https://yarnpkg.com/lang/en/docs/cli/install/
RUN yarn install --silent --non-interactive --frozen-lockfile --ignore-optional
COPY . .
RUN PUBLIC_URL=/ yarn run build

FROM nginx:1.21.0-alpine as reactapp

# Add bash
RUN apk add --no-cache bash

FROM debian:10.10-slim

RUN apt-get update \
    && apt-get install -y nginx openssl \
    && openssl req \
      -x509 \
      -subj "/C=US/ST=TX/L=Austin/O=Home/CN=samwanekeya.com" \
      -nodes \
      -days 365 \
      -newkey rsa:2048 \
      -keyout /etc/ssl/private/nginx-selfsigned.key \
      -out /etc/ssl/certs/nginx-selfsigned.crt

RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /usr/src/reactapp/docker/nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /usr/src/reactapp/docker/nginxconfig/general.conf /etc/nginx/general.conf
COPY --from=builder /usr/src/reactapp/docker/nginxconfig/security.conf /etc/nginx/security.conf
COPY --from=builder /usr/src/reactapp/build /usr/share/nginx/html
COPY --from=builder /usr/src/reactapp/.env /usr/share/nginx/html/.env

EXPOSE 80 443
CMD ["/bin/bash", "-c", "nginx -g \"daemon off;\""]
