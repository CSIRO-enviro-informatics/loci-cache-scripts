#!/bin/sh
set -e

if [ -z "$AWS_ACCESS_KEY_ID" ]; then echo "AWS_ACCESS_KEY_ID User needs to be set."; exit 1; fi
if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then echo "AWS_SECRET_ACCESS_KEY User needs to be set."; exit 1; fi
if [ -z "$OUTPUT_FILE" ]; then echo "OUTPUT_FILE needs to be set."; exit 1; fi
if [ -z "$S3_BUCKET" ]; then echo "S3_BUCKET needs to be set."; exit 1; fi
if [ -z "$S3_REGION" ]; then echo "S3_REGION needs to be set."; exit 1; fi
if [ -z "$S3_PATH" ]; then echo "S3_PATH needs to be set."; exit 1; fi
if [ -z "$S3_SOURCE_DATA_PATH" ]; then echo "S3_SOURCE_DATA_PATH needs to be set."; exit 1; fi
if [ -z "$S3_SOURCE_FILE" ]; then echo "S3_SOURCE_FILE needs to be set relative to $S3_SOURCE_DATA_PATH."; exit 1; fi
if [ -z "$SUBJECT_DATASET_URI" ]; then echo "SUBJECT_DATASET_URI needs to be set."; exit 1; fi
if [ -z "$LINKSET_URI" ]; then echo "LINKSET_URI needs to be set."; exit 1; fi
if [ -z "$OBJECT_DATASET_URI" ]; then echo "OBJECT_DATASET_URI needs to be set."; exit 1; fi

env

FILE_URL="https://${S3_BUCKET}.S3-${S3_REGION}.amazonaws.com${S3_SOURCE_DATA_PATH}/${S3_SOURCE_FILE}"
LOCAL_CSV_FILE="source_data.csv"
LOCAL_OUT_FILE="output.ttl"
LOCAL_HEADER_IMPORTS_FILE="header_imports.ttl"
LOCAL_HEADER_STATEMENTS_FILE="header_statements.ttl"

#Download source data
wget "$FILE_URL" -O $LOCAL_CSV_FILE

#Setup python env
pip install --no-cache-dir -r requirements.txt

#Covert CSV to ttl
python ./convert.py $LOCAL_CSV_FILE $LOCAL_OUT_FILE

#Create Header
envsubst < ./header_imports.ttl.template > $LOCAL_HEADER_IMPORTS_FILE
envsubst < ./header_statements.ttl.template > $LOCAL_HEADER_STATEMENTS_FILE

#Prepare trig file
echo "<${LINKSET_URI}> {" > head.part
echo "}" > tail.part

cat $LOCAL_HEADER_IMPORTS_FILE head.part $LOCAL_HEADER_STATEMENTS_FILE $LOCAL_OUT_FILE tail.part | gzip -k --rsyncable > ${OUTPUT_FILE}

#Upload to s3
#aws s3 cp ${OUTPUT_FILE} s3://${S3_BUCKET}${S3_PATH}/${OUTPUT_FILE}
aws s3 cp ${OUTPUT_FILE} s3://${S3_BUCKET}${S3_PATH}/${OUTPUT_FILE}
