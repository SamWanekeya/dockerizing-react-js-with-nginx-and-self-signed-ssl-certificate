# base image
FROM node:13.10.1-alpine as builder

# send signal to containers to stop them
STOPSIGNAL SIGTERM
# create working directory
RUN mkdir -p /usr/src/app
# set working directory
WORKDIR /usr/src/app
# copy package.json file to working directory
COPY package*.json ./
# install dependencies with precise, for more stories visit - https://yarnpkg.com/lang/en/docs/cli/install/
RUN yarn install --silent --non-interactive --frozen-lockfile --ignore-optional
COPY . .
RUN PUBLIC_URL=/ yarn run build

FROM nginx:1.17.9-alpine as app

# Add bash
RUN apk add --no-cache bash

FROM debian:10.3-slim

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
COPY --from=builder /usr/src/app/docker/nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /usr/src/app/docker/nginxconfig/general.conf /etc/nginx/general.conf
COPY --from=builder /usr/src/app/docker/nginxconfig/security.conf /etc/nginx/security.conf
COPY --from=builder /usr/src/app/build /usr/share/nginx/html
COPY --from=builder /usr/src/app/.env /usr/share/nginx/html/.env

EXPOSE 80 443
CMD ["/bin/bash", "-c", "nginx -g \"daemon off;\""]