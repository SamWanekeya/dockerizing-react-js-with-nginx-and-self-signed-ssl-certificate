# base image
FROM node:19.4.0-alpine as builder
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
FROM nginx:1.23.3-alpine as reactapp
# Install a self signed SSL certificate with no locally cached packages
FROM debian:11.6-slim
# Open SSL Version pinning - https://debian.pkgs.org/11/debian-main-amd64/openssl_1.1.1n-0+deb11u3_amd64.deb.html
RUN apt-get update && apt-get install -y --no-install-recommends nginx openssl=1.1.1n-0+deb11u3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && openssl req \
      -x509 \
      -subj "/C=KE/ST=Nairobi/L=Nairobi/O=Company Name Ltd/OU=Portfolio website/CN=samwanekeya.com" \
      -nodes \
      -days 365 \
      -new \
      -newkey rsa:2048 \
      -keyout /etc/ssl/private/nginx-selfsigned.key \
      -out /etc/ssl/certs/nginx-selfsigned.crt

RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /usr/src/reactapp/nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /usr/src/reactapp/nginx/nginxconfig/general.conf /etc/nginx/general.conf
COPY --from=builder /usr/src/reactapp/nginx/nginxconfig/security.conf /etc/nginx/security.conf
COPY --from=builder /usr/src/reactapp/build /usr/share/nginx/html
EXPOSE 80 443
CMD ["/bin/bash", "-c", "nginx -g \"daemon off;\""]
