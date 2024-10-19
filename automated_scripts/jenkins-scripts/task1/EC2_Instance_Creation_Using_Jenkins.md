
# EC2 Instance Creation Using Jenkins

## Overview
This document provides step-by-step instructions to set up a Jenkins pipeline that creates and deletes EC2 instances on AWS. The setup includes three scripts:
1. Prerequisites Script
2. EC2 Instance Creation Script
3. Resource Deletion Script

## Prerequisites
Before executing the EC2 instance creation script, ensure the following prerequisites are met:

### 1. Jenkins is Up and Running
- Access Jenkins at `http://<Jenkins-Server-IP>:8080`.
- Log in using the initial admin password (if required).

### 2. Jenkins Plugins are Installed
- Verify that the following plugins are installed:
  - AWS Credentials Plugin
  - AWS SDK Plugin
- To check, navigate to:
  - **Manage Jenkins -> Manage Plugins -> Installed**.
- Search for the plugins and ensure they are listed.

### 3. IAM Role is Attached
- Confirm that the IAM Role (`JenkinsEC2Role`) is attached to the EC2 instance where Jenkins is running:
  - Go to **AWS Console -> EC2 -> Instances**.
  - Select your Jenkins instance and go to **Actions -> Security -> Modify IAM Role**.
  - Ensure that the role `JenkinsEC2Role` is selected.

### 4. AWS CLI is Configured in Jenkins
- If using IAM roles, there is no need to manually configure AWS credentials in Jenkins.
- Verify that Jenkins has the appropriate permissions via the IAM role.

### 5. Jenkins Job Setup
- Create a Jenkins job (pipeline or freestyle project) that executes the EC2 creation script.



## Conclusion
Once all checks are completed, and you have set up your Jenkins job to execute the EC2 creation script, you can proceed with creating the instances. Follow the same steps to clean up resources using the deletion script when necessary.

For any issues or questions, please refer to the AWS and Jenkins documentation or reach out for support.
