#!/usr/bin/env bash

# USAGE: ./bin/docker-compose-attach web
docker-compose up -d && docker attach $(docker-compose ps -q $1)


