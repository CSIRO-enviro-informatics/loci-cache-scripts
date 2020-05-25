# Running commands
> ./startup.sh
On start, the container will check for the presence of files in the `GRAPHDB_SOURCE` directory. If found, it will assume data has been already loaded and simply start the database.
If no files are found, it will completely refresh the cache.

> ./startup.sh --rebuild
Will force a refresh of the data, rebuild the cache, then startup the graph.

> ./startup.sh --local-build
Will force a refresh of the data based on what is in `cachedata` (without downloading), 
rebuild the cache, then startup the graph.

> ./stop.sh
Will bring down the container

# Volumes
Its probably a good idea to create volumes for both the GraphDB backend, and `GRAPHDB_SOURCE` directory so the containers don't do a full reload everytime they start up.

-v /host/datadir:/app/cachedata
-v /host/graphdbdata:/graphdb/data

The compose file does this with named volumes

# Notes on local-build

Ensure the README.md file in `cachedata` is removed before the build.
```
rm cachedata/README.md
tar xvzf cachedata-asgs16-geofabric211.tar.gz 
./startup.sh --local-build
# test the GraphDB REST API to check
curl http://localhost/rest/repositories
```
