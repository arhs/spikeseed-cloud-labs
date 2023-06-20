# Testing the code

## Requirements

- [An AWS Account](https://aws.amazon.com/account/)
- An IAM user with [programmatic access](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)
- The AWS CLI with a [profile](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) configured
- [Terraform](https://developer.hashicorp.com/terraform/downloads)

## Deployment

terraform apply --auto-approve


### Cleanup

terraform destroy --auto-approve

Please note that the deletion of the lambda@edge function might initially fail, because it needs some time, after it is disassociated from the Cloudfront distribution. For more information, please consult the respective [article](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/lambda-edge-delete-replicas.html). You can retry the destroy within 20-30 minutes again. 
