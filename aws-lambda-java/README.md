# Testing the code

## Requirements

- [An AWS Account](https://aws.amazon.com/account/)
- An IAM user with [programmatic access](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)
- The AWS CLI with a [profile](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) configured
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) (on Windows you will need [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10))

## Configuration

    cd db-migrator-infra
    # Update the file `vars/common-vars.asb.yml` with appropriate values
    ansible-playbook aws/init/main.asb.yml --check -vvv
    ansible-playbook aws/init/main.asb.yml

    # Insert secrets into SSM Parameter Store
    # Create a Python script from aws/.ssm-vault/ssm-template.py.template and change the profile and the value
    # This file will be named ssm-labs.py in this example
    cd aws/.ssm-vault
    python ssm-labs.py # dry run
    python ssm-labs.py --check # check un/managed parameters
    python ssm-labs.py --nodryrun # execute the script

    # Push the code into the repository
    cd ../.. # go back to the root folder
    git init
    git remote add origin codecommit::us-east-1://spikeseed-labs@lambda-java-app
    git add -A
    git commit -m "Demo application"
    git push origin master

    ansible-playbook aws/cicd/main.asb.yml --check -vvv
    ansible-playbook aws/cicd/main.asb.yml

### Cleanup

1. Remove the S3 Bucket
1. Remove the stacks
1. Remove the CodeCommit repositories
1. Remove the SSM Parameter
