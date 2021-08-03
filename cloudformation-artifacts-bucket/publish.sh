#!/bin/bash

set -euo pipefail

# TODO - flatten these once published to all regions
REGIONS=("us-east-1" "us-east-2" "us-west-1" "us-west-2" "ca-central-1" "ap-south-1" "ap-northeast-1" "ap-northeast-2" "ap-southeast-1" "ap-southeast-2" "eu-central-1" "eu-west-1" "eu-west-2" "eu-west-3" "eu-north-1" "sa-east-1")
TYPE_NAME="Symphonia::OpenSource::CloudFormationArtifactsBucket::MODULE"

cfn validate --verbose

publish() {
  REGION=$1
  COMMON_ARGS="--region $REGION --type MODULE --type-name $TYPE_NAME"

  echo "Submitting to region $REGION"
  echo
  cfn submit --region "$REGION" --verbose --set-default
  VERSION_ID=$(aws cloudformation describe-type $COMMON_ARGS --query "DefaultVersionId" --output text)
  echo "New module version $VERSION_ID successfully submitted"
  echo

  echo "Testing"
  echo
  aws cloudformation test-type $COMMON_ARGS
# If desired, add a 'log-delivery-bucket' parameter to the above
#    --log-delivery-bucket "mybucket"

  TEST_STATUS=""
  until [ "$TEST_STATUS" = "PASSED" ] || [ "$TEST_STATUS" = "FAILED" ]
  do
    sleep 1
    echo "Querying testing status"
    TEST_STATUS=$(aws cloudformation describe-type $COMMON_ARGS \
      --version-id "$VERSION_ID" \
      --query "TypeTestsStatus" --output text)

    echo "Latest TypeTestsStatus = $TEST_STATUS"
    echo
  done

  if [ "$TEST_STATUS" = "FAILED" ]
  then
    echo "Module testing failed - aborting"
    exit 1
  fi

  echo "Module testing succeeded. Attempting to publish."
  echo
  aws cloudformation publish-type $COMMON_ARGS
  echo "Successfully published new module version $VERSION_ID of $TYPE_NAME to $REGION !"
  echo
}

for REGION in ${REGIONS[*]}; do
  publish "$REGION"
done


