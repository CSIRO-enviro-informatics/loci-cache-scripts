#!/bin/bash
set -e

source ../../../common/common.sh

docker-compose -f docker-compose.base.yml -f docker-compose.mb2cc.yml down -v
docker-compose -f docker-compose.base.yml -f docker-compose.mb2cc.yml up --build --force-recreate
