#!/bin/bash

# USAGE: docker-build-and-push [tagname]
# thx: https://github.com/DiveIntoHacking/docker-compose-rails-6/
#
set -e


source ../.env

docker-compose -f docker-compose.build.yml build --no-cache

target_tag_image="${IMAGE_NAME}:${1}"

docker tag ${IMAGE_NAME}:latest $target_tag_image

docker push $target_tag_image
