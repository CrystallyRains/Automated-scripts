# Jenkins Pipeline for Creating EC2 Instances in Auto Scaling Groups

This document provides an overview of the Jenkins pipeline used to create EC2 instances in Auto Scaling Groups (ASGs) on AWS, specifying both public and private instances.

## Prerequisites

1. **AWS CLI Installed**: Ensure that AWS CLI is installed and configured on the Jenkins instance.
2. **IAM Role with Permissions**:
   - Attach an IAM role to the Jenkins instance that has the following permissions:
     - `ec2:CreateLaunchTemplate`
     - `ec2:CreateAutoScalingGroup`
     - `ec2:DescribeLaunchTemplates`
     - `autoscaling:CreateAutoScalingGroup`
     - `autoscaling:DescribeAutoScalingGroups`

## Pipeline Overview

### Required Parameters

- **Launch Template Name**: 
  - Specify the name for the launch template (e.g., `PublicEC2LaunchTemplate`).

- **Instance Type**:
  - Use `t3.micro` for Free Tier eligibility.

- **Image ID (AMI)**:
  - Specify the AMI ID for the instance operating system.

- **Security Group ID**:
  - Provide the security group ID that allows appropriate inbound/outbound traffic.

- **VPC Zone Identifier**:
  - Specify the subnet ID where the EC2 instances will be launched.

### Optional Parameters

- **User Data**: 
  - You can include scripts for initialization during instance startup.

- **Tags**: 
  - Optionally add tags for organization or billing.

## Execution Instructions

1. Open Jenkins and create a new pipeline job.
2. Copy and paste the Jenkins pipeline script into the job configuration.
3. Replace the placeholder values (AMI ID, security group ID, and subnet IDs) with your actual values.
4. Save the job and execute it.

## Notes

- Ensure that the IAM role attached to Jenkins has the necessary permissions to execute AWS CLI commands.
- Monitor the Jenkins console output for success or failure messages during execution.

