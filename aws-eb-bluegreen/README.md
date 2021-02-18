# Testing the code

## Requirements

- [An AWS Account](https://aws.amazon.com/account/)
- An IAM user with [programmatic access](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)
- The AWS CLI with a [profile](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) configured
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) (on Windows you will need [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10))

## Configuration

    cd eb-bluegreen-infra
    # Update the file `vars/common-vars.asb.yml` with appropriate values
    ansible-playbook init/main.asb.yml --check -v
    ansible-playbook init/main.asb.yml

    ansible-playbook infra/main.asb.yml --check -v
    ansible-playbook infra/main.asb.yml

    # Insert secrets into SSM Parameter Store
    # Create a Python script from .vault/ssm-parameters/parameters.py.template (change the profile and the values) named ssm-labs.py
    cd .vault/ssm-parameters
    python ssm-labs.py
    python ssm-labs.py --nodryrun

    cd ../../../eb-bluegreen-app
    git init
    git remote add origin codecommit::us-east-1://spikeseed-labs@eb-bluegreen-app
    git add -A
    git commit -m "Demo application"
    git push origin master

    cd ../eb-bluegreen-infra
    ansible-playbook cicd/main.asb.yml --check -v
    ansible-playbook cicd/main.asb.yml

    # Wait for the Elastic BeanStalk to be created, then:

    curl -i -H "x-com-token: 0123456789" https://<aws_accounts.labs.backend_dns>/api/v1/hello # FQDN configured in common-vars.asb.yml

### Cleanup

1. Remove the S3 Buckets
1. Remove the stacks
1. Remove the CodeCommit repositories
1. Remove SSM Parameters
