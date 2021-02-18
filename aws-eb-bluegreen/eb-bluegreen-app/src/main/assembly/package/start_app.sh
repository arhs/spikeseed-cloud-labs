#!/bin/bash
AWS_REGION=$(curl --silent http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)
export DATABASE_PASSWORD_1=$(aws ssm get-parameter --name /eb-bluegreen/database/password/1 --with-decryption --output text --query Parameter.Value --region $AWS_REGION)
export DATABASE_PASSWORD_2=$(aws ssm get-parameter --name /eb-bluegreen/database/password/2 --with-decryption --output text --query Parameter.Value --region $AWS_REGION)

exec java -jar -Xms2g -Xmx2g eb-bluegreen.jar --logging.config=logback.xml
