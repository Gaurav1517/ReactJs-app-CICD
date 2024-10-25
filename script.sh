#!/bin/bash

# Download and install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version

# Install Ansible
sudo yum install ansible* -y
ansible --version

# Install the community.aws collection
ansible-galaxy collection install community.aws
ansible-galaxy collection list | grep community.aws

# Install aws module
ansible-galaxy collection install amazon.aws
ansible-galaxy collection list | grep amazon.aws


# Install necessary dependencies (boto3 and botocore)
pip3 install boto3 botocore
pip3 list | grep -E 'boto3|botocore'
