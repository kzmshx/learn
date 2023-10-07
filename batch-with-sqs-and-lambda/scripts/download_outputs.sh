#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
DEST_DIR=$SCRIPT_DIR/output_images

OUTPUT_BUCKET_NAME=$(make output 2>/dev/null | jq -r '.output_bucket_name.value')

aws s3 sync s3://$OUTPUT_BUCKET_NAME/ $DEST_DIR
