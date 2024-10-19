pipeline {
    agent any
    environment {
        AWS_DEFAULT_REGION = 'us-west-2' // Same region as the creation
    }
    stages {
        stage('Delete EC2 Instances and VPC') {
            steps {
                script {
                    // Terminate EC2 instances
                    sh "aws ec2 describe-instances --filters 'Name=instance-state-name,Values=running' --query 'Reservations[*].Instances[*].InstanceId' --output text | xargs -n 1 aws ec2 terminate-instances --instance-ids"
                    echo "Terminated all running EC2 instances"

                    // Delete Subnets
                    sh "aws ec2 describe-subnets --query 'Subnets[*].SubnetId' --output text | xargs -n 1 aws ec2 delete-subnet --subnet-id"
                    echo "Deleted all subnets"

                    // Detach and delete Internet Gateway
                    def vpcId = sh(script: 'aws ec2 describe-vpcs --query "Vpcs[0].VpcId" --output text', returnStdout: true).trim()
                    def igwId = sh(script: "aws ec2 describe-internet-gateways --filters Name=attachment.vpc-id,Values=${vpcId} --query 'InternetGateways[0].InternetGatewayId' --output text", returnStdout: true).trim()
                    sh "aws ec2 detach-internet-gateway --internet-gateway-id ${igwId} --vpc-id ${vpcId}"
                    sh "aws ec2 delete-internet-gateway --internet-gateway-id ${igwId}"
                    echo "Deleted Internet Gateway with ID: ${igwId}"

                    // Delete VPC
                    sh "aws ec2 delete-vpc --vpc-id ${vpcId}"
                    echo "Deleted VPC with ID: ${vpcId}"
                }
            }
        }
    }
}

