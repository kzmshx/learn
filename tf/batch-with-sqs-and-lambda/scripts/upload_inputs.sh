#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
SRC_DIR=$SCRIPT_DIR/input_images

INPUT_BUCKET_NAME=$(make output 2>/dev/null | jq -r '.input_bucket_name.value')

aws s3 cp $SRC_DIR s3://$INPUT_BUCKET_NAME/ --recursive
