# Stage 1: Build React App
# base image
FROM node:20.5-alpine as builder
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
# Copy the entire project
COPY . .
# Build the app
RUN PUBLIC_URL=/ yarn run build
# Stage 2: Serve App with Nginx
FROM nginx:1.25.2-alpine as reactapp
# Install a self signed SSL certificate with no locally cached packages
FROM debian:11.7-slim
# Open SSL Version pinning - https://debian.pkgs.org/11/debian-main-amd64/openssl_1.1.1n-0+deb11u4_amd64.deb.html
RUN apt-get update && apt-get install -y --no-install-recommends nginx openssl=1.1.1n-0+deb11u4 \
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
      -out /etc/ssl/certs/nginx-selfsigned.crt \
# Remove the default content in the Nginx document root directory before copying the built React app into it.
RUN rm -rf /usr/share/nginx/html/*
# Copy Nginx configuration files
COPY --from=builder /usr/src/reactapp/nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /usr/src/reactapp/nginx/nginxconfig/general.conf /etc/nginx/general.conf
COPY --from=builder /usr/src/reactapp/nginx/nginxconfig/security.conf /etc/nginx/security.conf
# Copy built React app
COPY --from=builder /usr/src/reactapp/build /usr/share/nginx/html
# Expose ports
EXPOSE 80 443
# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
