# Automation of Linkset Creation

Code to automate the process of linkset creation. Currently for meshblocks and contracted catchments and riverregions to contracted catchments.

## Requirements

Requires environment variables configured in `../../common/common.sh` and in `./.env`

additionally valid `LOCI_S3_ACCESS_KEY_ID`, `LOCI_S3_SECRET_ACCESS_KEY` and `AWS_SESSION_TOKEN` must be set prior to run

## Optional

Optionally set LOAD_LIMIT to test the link build process by loading a limited subset of input data

## Running

### Meshblocks to Contracted Catchments

Run with `createMBtoCC.sh` to execute the default workflow

### RiverRegions to Contracted Catchments

Run with `createRRtoCC.sh` to execute the default workflow

### Dev mode

Run `start.sh` docker-compose.yml enable manual execution then docker-compose exec linksets to execute manual commands in the `/app/` directory.

### Linkset upload

To upload a new version of the asgs 2016 mb data from WFS to S3 enter dev mode above and execute `cd /app/mb2cc/mb2cc && python preload_asgs_wfs.py` in the linksets container
