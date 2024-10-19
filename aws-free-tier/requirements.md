# AWS Free Tier Monitoring Setup

This document outlines the steps required to set up the AWS Lambda function for monitoring your Free Tier usage. Follow the steps below to ensure that your monitoring system is correctly configured.

## Prerequisites

- An **AWS Account** with Free Tier eligibility.
- Basic knowledge of AWS Lambda, SNS, and CloudWatch.
- AWS CLI installed (optional but recommended for ease of use).

## Step 1: Create an SNS Topic

1. **Navigate to the Amazon SNS Console**:
   - Go to the [Amazon SNS Console](https://console.aws.amazon.com/sns/v3/home).

2. **Create a New Topic**:
   - Click on **Topics** from the sidebar.
   - Click on **Create topic**.
   - Choose **Standard** as the type.
   - Provide a name for your topic (e.g., `FreeTierUsageAlerts`).

3. **Subscribe to the Topic**:
   - Select your newly created topic.
   - Click on **Create subscription**.
   - Choose a protocol (e.g., **Email**).
   - Enter your email address and click **Create subscription**.
   - Confirm your subscription through the email you receive.

## Step 2: Create a Lambda Function

1. **Navigate to the AWS Lambda Console**:
   - Go to the [AWS Lambda Console](https://console.aws.amazon.com/lambda/home).

2. **Create a New Lambda Function**:
   - Click on **Create function**.
   - Choose **Author from scratch**.
   - Provide a name for your function (e.g., `FreeTierUsageMonitor`).
   - Select a runtime (e.g., **Python 3.x**).
   - Set the execution role:
     - Create a new role with basic Lambda permissions.
     - Add permissions to allow the Lambda function to access SNS, EC2, CloudWatch, and other services.

3. **Set Environment Variables**:
   - Under **Configuration**, go to **Environment variables**.
   - Add a new variable with:
     - **Key**: `SNS_TOPIC_ARN`
     - **Value**: The ARN of the SNS topic you created earlier.

4. **Paste the Lambda Code**:
   - Copy the provided Lambda function code and paste it into the Lambda function code editor.

## Step 3: Set Up CloudWatch Events

1. **Navigate to the CloudWatch Console**:
   - Go to the [Amazon CloudWatch Console](https://console.aws.amazon.com/cloudwatch/home).

2. **Create a New Rule**:
   - Click on **Rules** from the sidebar.
   - Click on **Create rule**.

3. **Define Event Source**:
   - Choose **Schedule** as the event source.
   - Set the frequency to trigger your Lambda function (e.g., every day at a specific time).

4. **Select Targets**:
   - Under **Targets**, select **Lambda function**.
   - Choose your Lambda function (`FreeTierUsageMonitor`).

5. **Create the Rule**:
   - Click on **Configure details**.
   - Provide a name and description for the rule, then click **Create rule**.

## Step 4: Test the Lambda Function

1. **Manual Testing**:
   - In the AWS Lambda console, select your Lambda function.
   - Click on **Test** to create a test event.
   - Use the default test event or create a new one and click **Test** again to run the function manually.

2. **Monitor the SNS Notifications**:
   - Ensure you receive notifications for any usage that exceeds the Free Tier limits.

## Additional Considerations

- Regularly check your AWS billing dashboard to monitor your usage.
- Update the Lambda function as necessary if AWS changes Free Tier limits or you add new resources.
- Consider implementing logging within the Lambda function for better visibility into its operations.

## Conclusion

By following the above steps, you will have a fully functional monitoring system for your AWS Free Tier usage. Make sure to monitor your usage regularly and adjust the function as your resource usage evolves.


