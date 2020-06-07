# Testing the code

## Requirements

- [An AWS Account](https://aws.amazon.com/account/)
- An IAM user with [programmatic access](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)
- The AWS CLI with a [profile](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) configured
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) (on Windows you will need [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10))
- Subscribe to the [CentOS 7 AMI](https://aws.amazon.com/marketplace/pp/B00O7WM7QW)

## Configuration

Update the file `aws-ami-factory/vars/common-vars.asb.yml` with appropriate values and create a keypair named 'labs-test'

## Deployment

    cd aws-ami-factory

### Deploying the CICD infrastructure

    cd cloudformation/cicd
    ansible-playbook cicd.asb.yml --check -v
    ansible-playbook cicd.asb.yml

### Pushing the AMI provisioning code

    cd aws-ami-factory
    mkdir ../../demo-ansible
    cp -R provisioning/* ../../demo-ansible
    cd ../../demo-ansible
    git init
    # https://docs.aws.amazon.com/codecommit/latest/userguide/setting-up-git-remote-codecommit.html
    # with an AWS profile named 'spikeseed-labs' and a GIT repository 'demo-ansible' in 'eu-west-1'
    git remote add origin codecommit::eu-west-1://spikeseed-labs@demo-ansible
    git add -A
    git commit -m "Demo application"
    git push origin master

The git push command should trigger the CodePipeline.

### Deploying the Demo application

Once the AMI has been built, you can now deploy the application.

    cd ../cloudformation/demo
    ansible-playbook demo.asb.yml --check -v
    ansible-playbook demo.asb.yml
