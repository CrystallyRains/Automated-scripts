pipeline {
    agent any
    environment {
        AWS_DEFAULT_REGION = 'us-west-2' // Set your preferred region
        INSTANCE_TYPE = 't3.micro'
    }
    stages {
        stage('Create VPC and Subnets') {
            steps {
                script {
                    // Create a VPC
                    def vpcId = sh(script: 'aws ec2 create-vpc --cidr-block 10.0.0.0/16 --query "Vpc.VpcId" --output text', returnStdout: true).trim()
                    echo "Created VPC with ID: ${vpcId}"

                    // Create Public Subnet
                    def publicSubnetId = sh(script: "aws ec2 create-subnet --vpc-id ${vpcId} --cidr-block 10.0.1.0/24 --query 'Subnet.SubnetId' --output text", returnStdout: true).trim()
                    echo "Created Public Subnet with ID: ${publicSubnetId}"

                    // Create Private Subnet
                    def privateSubnetId = sh(script: "aws ec2 create-subnet --vpc-id ${vpcId} --cidr-block 10.0.2.0/24 --query 'Subnet.SubnetId' --output text", returnStdout: true).trim()
                    echo "Created Private Subnet with ID: ${privateSubnetId}"

                    // Create an Internet Gateway
                    def igwId = sh(script: 'aws ec2 create-internet-gateway --query "InternetGateway.InternetGatewayId" --output text', returnStdout: true).trim()
                    sh "aws ec2 attach-internet-gateway --vpc-id ${vpcId} --internet-gateway-id ${igwId}"
                    echo "Attached Internet Gateway with ID: ${igwId} to VPC: ${vpcId}"

                    // Create a route table and associate it with the public subnet
                    def routeTableId = sh(script: "aws ec2 create-route-table --vpc-id ${vpcId} --query 'RouteTable.RouteTableId' --output text", returnStdout: true).trim()
                    sh "aws ec2 associate-route-table --route-table-id ${routeTableId} --subnet-id ${publicSubnetId}"
                    sh "aws ec2 create-route --route-table-id ${routeTableId} --destination-cidr-block 0.0.0.0/0 --gateway-id ${igwId}"
                    echo "Created Route Table with ID: ${routeTableId} and associated it with the Public Subnet"

                    // Launch EC2 instance in the public subnet
                    def publicInstanceId = sh(script: "aws ec2 run-instances --image-id ami-12345678 --instance-type ${INSTANCE_TYPE} --subnet-id ${publicSubnetId} --associate-public-ip-address --query 'Instances[0].InstanceId' --output text", returnStdout: true).trim()
                    echo "Launched EC2 instance in the Public Subnet with ID: ${publicInstanceId}"

                    // Launch EC2 instance in the private subnet
                    def privateInstanceId = sh(script: "aws ec2 run-instances --image-id ami-12345678 --instance-type ${INSTANCE_TYPE} --subnet-id ${privateSubnetId} --query 'Instances[0].InstanceId' --output text", returnStdout: true).trim()
                    echo "Launched EC2 instance in the Private Subnet with ID: ${privateInstanceId}"
                }
            }
        }
    }
}

