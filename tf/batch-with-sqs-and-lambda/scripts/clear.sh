#!/bin/bash

INPUT_BUCKET_NAME=$(make output 2>/dev/null | jq -r '.input_bucket_name.value')
OUTPUT_BUCKET_NAME=$(make output 2>/dev/null | jq -r '.output_bucket_name.value')

aws s3 rm s3://$INPUT_BUCKET_NAME/ --recursive
aws s3 rm s3://$OUTPUT_BUCKET_NAME/ --recursive
