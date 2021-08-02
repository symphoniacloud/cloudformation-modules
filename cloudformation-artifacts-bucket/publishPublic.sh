#!/bin/bash

set -euo pipefail

# TODO - finish this

#REGIONS=("us-east-1")
#
#cfn validate --verbose
#
#submit() {
#    echo "Submitting to region $1"
#    echo
#    cfn submit --region "$1" --verbose --set-default
#}
#
#for REGION in ${REGIONS[*]}; do
#    submit "$REGION"
#done

#aws cloudformation test-type \
#  --type MODULE \
#  --type-name Symphonia::OpenSource::CloudFormationArtifactsBucket::MODULE \
#  --log-delivery-bucket cloudformation-artifacts-012345678901-us-east-1

#aws cloudformation publish-type \
#  --type MODULE \
#  --type-name Symphonia::OpenSource::CloudFormationArtifactsBucket::MODULE