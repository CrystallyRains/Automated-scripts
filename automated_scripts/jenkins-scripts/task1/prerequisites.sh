#!/bin/bash
# Prerequisite Script for setting up Jenkins, AWS CLI, and IAM Role

# 1. Update system packages
sudo apt-get update -y

# 2. Install Jenkins
sudo apt-get install -y openjdk-11-jdk
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update -y
sudo apt-get install -y jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins

# 3. Install AWS CLI
sudo apt-get install -y awscli

# 4. Verify AWS CLI installation
aws --version

# 5. Install necessary Jenkins plugins for AWS (optional, can also be done via Jenkins UI)
sudo apt-get install -y jq
JENKINS_CLI=/var/cache/jenkins/war/WEB-INF/jenkins-cli.jar
JENKINS_URL=http://localhost:8080
ADMIN_PASSWORD=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)

# Install AWS plugins
java -jar $JENKINS_CLI -s $JENKINS_URL -auth admin:$ADMIN_PASSWORD install-plugin aws-credentials aws-java-sdk

# 6. Setup IAM Role (attach via AWS Console or CLI)
# If this EC2 instance does not have an IAM role, you can create and attach one using AWS CLI
# This role should have policies like AmazonEC2FullAccess and AmazonVPCFullAccess

aws iam create-role --role-name JenkinsEC2Role --assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}'

# Attach full EC2 and VPC access policies to the role
aws iam attach-role-policy --role-name JenkinsEC2Role --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess
aws iam attach-role-policy --role-name JenkinsEC2Role --policy-arn arn:aws:iam::aws:policy/AmazonVPCFullAccess

# You need to attach the JenkinsEC2Role to the EC2 instance manually or via CLI

echo "Jenkins setup complete. Don't forget to manually attach the IAM Role to the EC2 instance if not done yet."


