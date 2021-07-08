#!/usr/bin/env bash
# safety switch, exit script if there's error.
set -e
# safety switch, uninitialized variables will stop script.
set -u
docker-compose -f docker-compose.yml down --rmi=all --volumes --remove-orphans
