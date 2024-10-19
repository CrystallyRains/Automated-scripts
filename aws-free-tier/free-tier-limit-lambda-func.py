import boto3
import os

# Create clients for services
cloudwatch = boto3.client('cloudwatch')
sns = boto3.client('sns')
ec2 = boto3.client('ec2')
elbv2 = boto3.client('elbv2')

# Thresholds for free tier limits
EC2_HOURS_LIMIT = 750  # EC2 Free Tier limit (hours/month)
S3_STORAGE_LIMIT = 5    # S3 Free Tier limit (GB/month)
LAMBDA_INVOCATIONS_LIMIT = 1000000  # Lambda Free Tier limit
ALB_REQUESTS_LIMIT = 200000  # ALB Free Tier limit (requests/month)
ASG_RUNNING_INSTANCES_LIMIT = 750  # ASG Free Tier limit (hours/month)
VPC_LIMIT = 5  # VPC Free Tier limit (VPCs/month)
IGW_LIMIT = 1   # Internet Gateway Free Tier limit (1/month)

# SNS topic ARN to send notifications
SNS_TOPIC_ARN = os.environ['SNS_TOPIC_ARN']

def lambda_handler(event, context):
    # Get EC2 usage
    ec2_hours_used = get_ec2_usage()
    if ec2_hours_used > EC2_HOURS_LIMIT:
        notify(f"EC2 usage exceeded Free Tier limit: {ec2_hours_used} hours.")

    # Get S3 usage
    s3_storage_used = get_s3_usage()
    if s3_storage_used > S3_STORAGE_LIMIT:
        notify(f"S3 storage exceeded Free Tier limit: {s3_storage_used} GB.")

    # Get Lambda invocations
    lambda_invocations_used = get_lambda_usage()
    if lambda_invocations_used > LAMBDA_INVOCATIONS_LIMIT:
        notify(f"Lambda invocations exceeded Free Tier limit: {lambda_invocations_used} invocations.")

    # Get ALB requests
    alb_requests_used = get_alb_requests()
    if alb_requests_used > ALB_REQUESTS_LIMIT:
        notify(f"ALB requests exceeded Free Tier limit: {alb_requests_used} requests.")

    # Get ASG instance usage
    asg_hours_used = get_asg_usage()
    if asg_hours_used > ASG_RUNNING_INSTANCES_LIMIT:
        notify(f"ASG usage exceeded Free Tier limit: {asg_hours_used} hours.")

    # Check VPC usage
    vpc_count = get_vpc_usage()
    if vpc_count > VPC_LIMIT:
        notify(f"VPC count exceeded Free Tier limit: {vpc_count} VPCs.")

    # Check Internet Gateway usage
    igw_count = get_igw_usage()
    if igw_count > IGW_LIMIT:
        notify(f"Internet Gateway count exceeded Free Tier limit: {igw_count} IGWs.")

def get_ec2_usage():
    # Get the current month's usage for EC2
    response = cloudwatch.get_metric_statistics(
        Period=86400,
        StartTime='2024-01-01T00:00:00Z',  # Replace with the first day of the current month
        EndTime='2024-01-31T23:59:59Z',  # Replace with the last day of the current month
        MetricName='CPUUtilization',
        Namespace='AWS/EC2',
        Statistics=['Sum'],
        Dimensions=[{'Name': 'InstanceId', 'Value': 'YOUR_INSTANCE_ID'}]  # Adjust based on your resources
    )
    return sum(datapoint['Sum'] for datapoint in response['Datapoints']) / 3600  # Convert seconds to hours

def get_s3_usage():
    # Get S3 storage usage
    s3 = boto3.client('s3')
    total_size = 0
    buckets = s3.list_buckets()
    for bucket in buckets['Buckets']:
        bucket_location = s3.get_bucket_location(Bucket=bucket['Name'])
        bucket_size = s3.list_objects_v2(Bucket=bucket['Name'])
        total_size += sum(obj['Size'] for obj in bucket_size.get('Contents', []))
    return total_size / (1024 ** 3)  # Convert bytes to GB

def get_lambda_usage():
    # Get Lambda invocation count
    response = cloudwatch.get_metric_statistics(
        Period=86400,
        StartTime='2024-01-01T00:00:00Z',  # Replace with the first day of the current month
        EndTime='2024-01-31T23:59:59Z',  # Replace with the last day of the current month
        MetricName='Invocations',
        Namespace='AWS/Lambda',
        Statistics=['Sum'],
        Dimensions=[{'Name': 'FunctionName', 'Value': 'YOUR_LAMBDA_FUNCTION_NAME'}]  # Adjust based on your Lambda function name
    )
    return sum(datapoint['Sum'] for datapoint in response['Datapoints'])

def get_alb_requests():
    # Get ALB request count
    response = cloudwatch.get_metric_statistics(
        Period=86400,
        StartTime='2024-01-01T00:00:00Z',
        EndTime='2024-01-31T23:59:59Z',
        MetricName='RequestCount',
        Namespace='AWS/ApplicationELB',
        Statistics=['Sum'],
        Dimensions=[{'Name': 'LoadBalancer', 'Value': 'YOUR_ALB_ARN'}]  # Adjust based on your ALB ARN
    )
    return sum(datapoint['Sum'] for datapoint in response['Datapoints'])

def get_asg_usage():
    # Get ASG running instances
    response = ec2.describe_auto_scaling_groups()
    total_hours = 0
    for asg in response['AutoScalingGroups']:
        total_hours += len(asg['Instances'])  # Count the number of instances in the ASG
    return total_hours  # Return total hours based on instance counts

def get_vpc_usage():
    # Count the number of VPCs
    response = ec2.describe_vpcs()
    return len(response['Vpcs'])

def get_igw_usage():
    # Count the number of Internet Gateways
    response = ec2.describe_internet_gateways()
    return len(response['InternetGateways'])

def notify(message):
    # Publish a notification to SNS
    sns.publish(
        TopicArn=SNS_TOPIC_ARN,
        Message=message,
        Subject='AWS Free Tier Usage Alert'
    )

