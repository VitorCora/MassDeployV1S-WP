# MassDeployV1S-WP
Proces to massively deploy **V1S&WP** agent to multiple **linux EC2** using **AWS SSM**

This script and step-by-step was created based on the following AWS documentation:

    - https://aws.amazon.com/getting-started/hands-on/remotely-run-commands-ec2-instance-systems-manager/

We are going to be using AWS System Manager - Node Management - Run Command for the following activity (Can also be triggered through AWS System Manager - Node Management - Fleet Manager)

# Pre requisites

All your instances must have a role that allows AWS SSM to access and manage them
* Steps to create and change role on the Step #

![image](https://github.com/VitorCora/MassDeployV1S-WP/assets/59590152/4f2bcfac-9f3c-4098-bd17-4fc747f0af30)

Working Trend Vision One tenant
*Steps to the creation of the tenant on the the Step ##

Upload the Linux agent to an AWS S3 bucket accessible to the instances that will be protected
*Steps to download the agent on the Step ####
* Steps to create and allow public access of the agent in the Step #####

# Create an IAM role to enable EC2 to access AWS System Manager

Go to the **IAM** service on your AWS console and click on **Roles**
 - https://us-east-1.console.aws.amazon.com/iam/home?region=us-east-1#/roles

On the **Roles** page click on **Create Role**

![image](https://github.com/VitorCora/MassDeployV1S-WP/assets/59590152/2ec056d8-50ae-44ec-8a52-5554a186970c)

Under **Select trusted entity**, select **AWS service**

On the **Use case** selection, select **EC2**

![image](https://github.com/VitorCora/MassDeployV1S-WP/assets/59590152/dcfd853e-db23-425f-8d76-189e946a1cc7)

Click on **Next**, at the bottom right corner

On de **Add permissions** page, under the **Permissions policies**, look for the  **AmazonEC2RoleforSSM**, tick it and click on **Next**, at the bottom right corner

![image](https://github.com/VitorCora/MassDeployV1S-WP/assets/59590152/ae385a27-4171-4ae5-bb7d-29191d1d80a7)

Now we are on the last page.

On the page **Name, review, and create **

Under the **Role Name** paste 
 - EnablesEC2ToAccessSystemsManagerRole

Under the **Description** paste 
    - Enables an EC2 instance to access Systems Manager

Your should looks as follows:
![image](https://github.com/VitorCora/MassDeployV1S-WP/assets/59590152/bf98cf7e-d2eb-4935-a7ee-e431530122b4)
![image](https://github.com/VitorCora/MassDeployV1S-WP/assets/59590152/67fc2d60-7784-415f-a250-bdbac6de5053)

And click **Create role** to finish it

# Trend Vision One


# AWS S3 Bucket

## Create an AWS S3 Bucket

Create an AWS S3 bucket on the S3 service:
    - https://s3.console.aws.amazon.com/s3/get-started?region=us-east-1&bucketType=general

On the AWS S3 Page, click on the orange button that says **Create Bucket** on the right top

![image](https://github.com/VitorCora/MassDeployV1S-WP/assets/59590152/1f9a5d5a-f047-4773-903e-84a359df135b)

On the **Create Bucket** Page, under **General configuration**, chose an **unique name** for your bucket

![image](https://github.com/VitorCora/MassDeployV1S-WP/assets/59590152/aa117ad7-4097-459c-b0b2-ec29906c018b)

Under the **Block Public Access settings for this bucket** session,

Tick off the **Block all public access** and tick the **acknowledgement** that object from this bucket may now be public.

![image](https://github.com/VitorCora/MassDeployV1S-WP/assets/59590152/8a4e6e0f-662c-41d0-9b37-03c9f42adeda)

Now click on the Orange button that says **Create bucket** on the bottom right corner

## Make the agent public on the AWS S3 Bucket

Now is the time to make your agent public, so that all your accounts that need to access it may be able to download it. **Please do not store any other software, credential or classified information in the Bucket.**

Enter on your recently created bucket.

Look for the **Permissions Tab** and select it

![image](https://github.com/VitorCora/MassDeployV1S-WP/assets/59590152/7b0d62c0-6a2e-48e2-9082-71ef09318a7b)

Under the BUcket policy session, click on Edit and add the following permission:

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Allowobjectaccess",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "**<YOURBUCKETARN>**/TMServerAgent_Linux.tar"
        }
    ]
}

Your should look somewhat like the following, but with your **BUCKET ARN** at the **Resource session** 
![image](https://github.com/VitorCora/MassDeployV1S-WP/assets/59590152/2d3e2211-6fda-4316-8c13-917c8c0b3da7)

Now click on **Save Changes** at the bottom right corner

# Run Command

## Script

Copy and paste the following script into the Command Parameters session:

#!/bin/bash

DIR="agentlinux"
AGENTINSTALLER="TMServerAgent*"

if [ -d "$DIR" ]; then
    echo "Directory agentlinux exists"
    cd ~/$DIR
    wget https://**<YOUR BUCKET NAME>**.s3.amazonaws.com/TMServerAgent_Linux.tar
    tar -xvf TMServerAgent_Linux.tar
    sudo ./tmxbc install;
else 
    echo "Directory agentlinux does not exist, Creating directory"
    mkdir $DIR
    cd ~/$DIR
    wget https://**<YOUR BUCKET NAME>**.s3.amazonaws.com/TMServerAgent_Linux.tar
    tar -xvf TMServerAgent_Linux.tar
    sudo ./tmxbc install;
fi

It should look like the following:

![image](https://github.com/VitorCora/MassDeployV1S-WP/assets/59590152/c8aeed3e-4ec1-40ec-a32a-cb01db4ffe31)

Next step is to select the target instances

On the Target selection session you may choose based on "Instance TAGs", "Manually"or based on "Resource Group".

For this example I chose manually, but for a massive deployment the use of a TAG Key::Value pair is highly recommended (eg. TrendProtect::YES)

It should look similar to the following:

![image](https://github.com/VitorCora/MassDeployV1S-WP/assets/59590152/ad7ed3b6-2cef-4020-949f-6e93514aed82)

Next recommended session to be edited is Output options

On the Outputs options session choose an AWS S3 bucket of your preference to store your logs, this will ensure that you will have full access to the log history and possible errors.

It should look similar to the following:

![image](https://github.com/VitorCora/MassDeployV1S-WP/assets/59590152/dc02270b-e0c2-41bf-9a89-e061c2c57ca3)

Final result:

With Role IAM in the instances:

![image](https://github.com/VitorCora/MassDeployV1S-WP/assets/59590152/5633c1ef-16e3-4552-ad8e-1fa3433113e5)

![image](https://github.com/VitorCora/MassDeployV1S-WP/assets/59590152/13008120-11ac-414f-9baa-896033dd660f)

Without the Role IAM to 4 of the 5 instances:

![image](https://github.com/VitorCora/MassDeployV1S-WP/assets/59590152/9aa4c9ef-a40b-44c7-acf9-0ff29dc9860b)

