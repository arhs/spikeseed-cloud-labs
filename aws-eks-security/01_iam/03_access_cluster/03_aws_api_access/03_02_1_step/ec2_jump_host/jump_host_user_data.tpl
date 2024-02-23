#!/bin/bash -xe
USERNAME="ec2-user"

pip3 uninstall awscli -y
echo "Installing AWS CLI v2"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
./aws/install -i /usr/aws-cli -b /usr/bin --update
rm -f awscliv2.zip


echo "Installing kubectl"
curl -LO "https://dl.k8s.io/release/${k8s_version}/bin/linux/amd64/kubectl" -o "kubectl"
chmod +x ./kubectl
mv ./kubectl /usr/bin/kubectl
echo 'source <(kubectl completion bash)' >>/etc/profile.d/kubectl_completion.sh

echo "Creating kubeconfig for the Cluster"
aws eks --region ${aws_region} update-kubeconfig --name ${cluster_name}

mv /root/.kube /home/$USERNAME/
chown $USERNAME: -R /home/$USERNAME/.kube