# Deploying the infrastructure

## Requirements

- Ansible
- Boto3 (python library)
- Subscribe to the CentOS 7 AMI (https://aws.amazon.com/marketplace/pp?sku=aw0evgkw8e5c1q413zgy5pjce)

## Configuration

Update the file `vars/common-vars.asb.yml` with appropriate values

## Deploy

### Common resources

    cd initialization
    ansible-playbook initialization.asb.yml

### Initial infrastructure

    cd ../step_0
    ansible-playbook step0.asb.yml

    cd ../cloudfront_bypass
    ansible-playbook cloudfront-bypass.asb.yml

### Restricting access to the ALB

    cd ../step_1
    ansible-playbook step1.asb.yml --check -v
    ansible-playbook step1.asb.yml

    cd ../lambdas
    ansible-playbook lambdas.asb.yml

To initialize the Cloudfront security groups, you need to execute the lambda once.

    aws lambda invoke --profile spikeseed-labs --region eu-west-1 --function-name cloudfront-sg-updater --payload file://cloudfront-sg-updater/init-payload.json out.log

    cat out.log

You will get an error message like:

    "MD5 Mismatch: got 752b804e2825dffc79bce7c10acaf201 expected 7fd59f5c7f5cf643036cbd4443ad3e4b"

In the `cloudfront-sg-updater/init-payload.json` file change the expected value "7fd59f5c7f5cf643036cbd4443ad3e4b" by the "got" value (752b804e2825dffc79bce7c10acaf201 in this example).

Then execute the lambda again, this time everything should be fine:

    ["Updated sg-08feaf22a4345caf5", "Updated sg-0c99a7611dece7348", "Updated 0 of 0 CloudFront_g HttpSecurityGroups", "Updated 1 of 1 CloudFront_g HttpsSecurityGroups", "Updated 0 of 0 CloudFront_r HttpSecurityGroups", "Updated 1 of 1 CloudFront_r HttpsSecurityGroups"]

### Signing a Cloudfront Distribution request to the origin

    cd ../step_2
    ansible-playbook step2.asb.yml --check -v
    ansible-playbook step2.asb.yml

### Hosts Whitelisting

    cd ../step_3
    ansible-playbook step3.asb.yml --check -v
    ansible-playbook step3.asb.yml