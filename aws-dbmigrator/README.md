# Testing the code

## Requirements

- [An AWS Account](https://aws.amazon.com/account/)
- An IAM user with [programmatic access](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)
- The AWS CLI with a [profile](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) configured
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) (on Windows you will need [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10))

## Configuration

    cd db-migrator-init
    # Update the file `vars/common-vars.asb.yml` with appropriate values
    ansible-playbook prime/main.asb.yml

    cd ../cd aws-dbmigrator-app

    ansible-playbook aws/main.asb.yml

    cd ../aws-migrator-app
    git init
    git remote add origin codecommit::us-east-1://spikeseed-labs@db-migrator-app
    git add -A
    git commit -m "Demo application"
    git push origin master

    cd ../aws-migrator-init
    ansible-playbook cicd/main.asb.yml

## Extra commands

    cd aws-dbmigrator-app

    ansible-playbook aws/infra/main.asb.yml --check -v
    ansible-playbook aws/infra/main.asb.yml --tags vpc --check -vvv
    ansible-playbook aws/infra/main.asb.yml --tags sg --check -vvv
    ansible-playbook aws/infra/main.asb.yml --tags database --check -vvv

    ansible-playbook aws/lambdas/main.asb.yml --check -v
    ansible-playbook aws/lambdas/main.asb.yml --tags dbinit --check -vvv
    ansible-playbook aws/lambdas/main.asb.yml --tags dbmigrations-hw --check -vvv
    ansible-playbook aws/lambdas/main.asb.yml --tags helloworld --check -vvv

## Cleanup

1. Remove the S3 Buckets
1. Remove the stacks
1. Remove the CodeCommit repositories
1. Remove SSM Parameters
