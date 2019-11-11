#!/bin/bash
set -e

source ../../../common/common.sh

docker-compose up -f docker-compose.base.yml -d --build --force-recreate
