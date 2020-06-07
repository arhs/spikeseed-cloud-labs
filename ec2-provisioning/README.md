# Testing the code

## Requirements

- [An AWS Account](https://aws.amazon.com/account/)
- An IAM user with [programmatic access](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)
- The AWS CLI with a [profile](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) configured
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) (on Windows you will need [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10))
- Subscribe to the [CentOS 7 AMI](https://aws.amazon.com/marketplace/pp/B00O7WM7QW)

## Configuration

Update the file `ec2-provisioning/vars/common-vars.asb.yml` with appropriate values and create a keypair named 'labs-test'

## Preparing the Ansible Playbook repository

    cd ec2-provisioning
    mkdir ../../demo-ansible
    cp -R provisioning/ansible/playbook/* ../../demo-ansible
    cd ../../demo-ansible

    # With an AWS profile named 'spikeseed-labs' and a GIT repository 'demo-ansible' in 'eu-west-1'
    aws codecommit create-repository --repository-name demo-ansible --profile spikeseed-labs --region eu-west-1
    aws codecommit list-repositories --profile spikeseed-labs

    git init
    # https://docs.aws.amazon.com/codecommit/latest/userguide/setting-up-git-remote-codecommit.html

    git remote add origin codecommit::eu-west-1://spikeseed-labs@demo-ansible
    git add -A
    git commit -m "Demo application"
    git push origin master

### Deploying the Demo application

Once the AMI has been built, you can now deploy the application.

    cd ../cloudformation/demo
    ansible-playbook demo.asb.yml --check -v
    ansible-playbook demo.asb.yml

### Cleanup

1. Remove the stacks
2. Remove the repository

    aws codecommit delete-repository --repository-name demo-ansible --profile spikeseed-labs --region eu-west-1
