#!/bin/bash

set -euo pipefail

REGIONS=("us-east-1")

cfn validate --verbose

submit() {
    echo "Submitting to region $1"
    echo
    cfn submit --region "$1" --verbose --set-default
}

for REGION in ${REGIONS[*]}; do
    submit "$REGION"
done
