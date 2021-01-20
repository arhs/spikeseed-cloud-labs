# Testing the code

## Requirements

- [An AWS Account](https://aws.amazon.com/account/)
- An IAM user with [programmatic access](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)
- The AWS CLI with a [profile](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) configured
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) (on Windows you will need [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10))

## Configuration

    cd quarkus-aws-initialization
    # Update the file `vars/common-vars.asb.yml` with appropriate values
    ansible-playbook init/main.asb.yml --check -v
    ansible-playbook init/main.asb.yml

    cd ../quarkus-codebuild-graalvm
    git init
    git remote add origin codecommit::us-east-1://spikeseed-labs@quarkus-codebuild-graalvm
    git add -A
    git commit -m "Demo application"
    git push origin master

    cd ../quarkus-app
    git init
    git remote add origin codecommit::us-east-1://spikeseed-labs@quarkus-app
    git add -A
    git commit -m "Demo application"
    git push origin master

    cd ../quarkus-aws-initialization
    ansible-playbook cicd/main.asb.yml --check -v
    ansible-playbook cicd/main.asb.yml --tags graalvm

    # Wait for the Docker image to be available

    ansible-playbook cicd/main.asb.yml --tags app

    # Now the API Gateway API and the Lambda should be deployed

### Cleanup

1. Remove the stacks
2. Remove the CodeCommit repositories
3. Remove the ECR repository
4. Remove the S3 Buckets
