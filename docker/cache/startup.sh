#!/bin/bash
set -e

source ../../common/common.sh

if [ -n "$1" ]
then
    if [ "$1" == "--rebuild" ]
    then
        export FORCE_REFRESH=1

        # run and wait for exit (build)
        docker-compose up --build --force-recreate --abort-on-container-exit
        
        unset FORCE_REFRESH
    elif [ "$1" == "--local-build" ]
    then
        export SKIP_DOWNLOAD=1
        export FORCE_REFRESH=1
        echo "Skipping download phase and building"
        # run and wait for exit (build)
        echo "docker-compose -f docker-compose.local.yml up --build --force-recreate --abort-on-container-exit"
        docker-compose -f docker-compose.local.yml up --build --force-recreate --abort-on-container-exit
        
        unset FORCE_REFRESH
        unset SKIP_DOWNLOAD 
    else
        echo "--rebuild is the only valid option to this script"
        exit 1
    fi
fi

#start the service with a restart paremeter set.
docker-compose -f docker-compose.yml -f docker-compose.restart.yml up -d --build --force-recreate

#Use this to see the logs if needed
#docker-compose logs -f
