#!/bin/sh
PROFILE_NAME=spikeseed-labs
AWS_REGION=us-east-1
BUCKET_NAME=$(aws ssm get-parameter --name /eb-solutionstack/cfn/bucket/vault --output text --query Parameter.Value --profile $PROFILE_NAME --region $AWS_REGION)
aws s3 sync --profile $PROFILE_NAME . s3://$BUCKET_NAME/ssm-parameters --exclude "*" --include "ssm-*.py"
