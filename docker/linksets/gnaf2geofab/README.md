To run the harvest, simple pick the `create[year/month].sh` and run it from the `gnaf2geofab` directory

The scripts pull confguration from the /common/common.sh script. This sets a bunch of common variables to ensure all the 
containers are consistent with each other.

The scripts will upload the harvest files to the AWS automatically, and as such need credentials. By default the common.sh will look for: 

`LOCI_S3_ACCESS_KEY_ID`
`LOCI_S3_SECRET_ACCESS_KEY`


