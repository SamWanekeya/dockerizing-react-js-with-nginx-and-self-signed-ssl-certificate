#!/usr/bin/env bash
set -e
docker-compose -f docker-compose.yml down -v --rmi local