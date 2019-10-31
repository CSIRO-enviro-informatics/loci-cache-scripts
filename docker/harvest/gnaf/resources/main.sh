#!/bin/sh
set -e

if [ -z "$AWS_ACCESS_KEY_ID" ]; then echo "AWS_ACCESS_KEY_ID User needs to be set."; exit 1; fi
if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then echo "AWS_SECRET_ACCESS_KEY User needs to be set."; exit 1; fi
if [ -z "$OUTPUT_FILE" ]; then echo "OUTPUT_FILE needs to be set."; exit 1; fi
if [ -z "$GRAPH_NAME" ]; then echo "GRAPH_NAME needs to be set."; exit 1; fi
if [ -z "$S3_BUCKET" ]; then echo "S3_BUCKET needs to be set."; exit 1; fi
if [ -z "$S3_REGION" ]; then echo "S3_REGION needs to be set."; exit 1; fi
if [ -z "$S3_PATH" ]; then echo "S3_PATH needs to be set."; exit 1; fi


if [ -z "$DB_HOST" ]; then echo "DB_HOST needs to be set."; exit 1; fi
if [ -z "$DB_PORT" ]; then echo "DB_PORT needs to be set."; exit 1; fi
if [ -z "$DB_DBNAME" ]; then echo "DB_DBNAME needs to be set."; exit 1; fi
if [ -z "$DB_USR" ]; then echo "DB_USR needs to be set."; exit 1; fi
if [ -z "$DB_PWD" ]; then echo "DB_PWD needs to be set."; exit 1; fi
if [ -z "$SPARQL_AUTH_USR" ]; then echo "SPARQL_AUTH_USR needs to be set."; exit 1; fi
if [ -z "$SPARQL_AUTH_PWD" ]; then echo "SPARQL_AUTH_PWD needs to be set."; exit 1; fi

env

git clone https://github.com/CSIRO-enviro-informatics/gnaf-dataset.git
cd gnaf-dataset

if [ -n "$BRANCH" ] 
then 
    echo "Changing branch: ${BRANCH}"
    git fetch --all
    git checkout ${BRANCH}
fi

pip install --no-cache-dir -r requirements.txt

export PYTHONPATH=$(pwd)
# python ./app.py --init
python ./new_graph_builder.py ${SINGLE_REGISTER}

cd instance

echo "<${GRAPH_NAME}> {" > head.part
echo "}" > tail.part

cat head.part *.nt tail.part | gzip -k --rsyncable > ${OUTPUT_FILE}

aws s3 cp ${OUTPUT_FILE} s3://${S3_BUCKET}${S3_PATH}/${OUTPUT_FILE}
