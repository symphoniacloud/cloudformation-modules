#!/bin/bash

set -euo pipefail

# For more details, see https://docs.aws.amazon.com/cloudformation-cli/latest/userguide/publish-extension.html#publish-extension-prereqs

# These regions have already been registered - don't do them again
#REGIONS=("us-east-1" "us-east-2" "us-west-1" "us-west-2" "ca-central-1" "ap-south-1" "ap-northeast-1" "ap-northeast-2" "ap-southeast-1" "ap-southeast-2" "eu-central-1" "eu-west-1" "eu-west-2" "eu-west-3" "eu-north-1" "sa-east-1")
# As of last update to this file, CodeStar is not available in "af-south-1" "ap-east-1" "ap-northeast-3" "eu-south-1" "me-south-1"

REGIONS=()

# This was previously registered manually, and is only necessary once, globally
SYMPHONIA_CONNECTION_NAME="github-connection-to-opensource"
CONNECTION_ARN=$(aws codestar-connections list-connections --query "Connections[?ConnectionName=='$SYMPHONIA_CONNECTION_NAME'].ConnectionArn" --output text)
echo "Found CodeStar connection $CONNECTION_ARN"
echo

register() {
  REGION=$1
  echo "Registering in region $REGION"

  aws cloudformation register-publisher \
    --region "$REGION" \
    --accept-terms-and-conditions \
    --connection-arn "$CONNECTION_ARN"
}

for REGION in ${REGIONS[*]}; do
  register "$REGION"
done
