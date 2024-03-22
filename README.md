# MassDeployV1S-WP
Script to massively deploy V1S&amp;WP agent to multiple linux EC@ using AWS SSM

This script and step-by-step was created based on the following AWS documentation

https://aws.amazon.com/getting-started/hands-on/remotely-run-commands-ec2-instance-systems-manager/

We are going to be using AWS System Manager - Node Management - Run Command for the following activity (Can also be triggered through AWS System Manager - Node Management - Fleet Manager)

# Pre requisites

All your instances must have a role that allows AWS SSM to access and manage them
* Steps to create and change role on the Step #

![image](https://github.com/VitorCora/MassDeployV1S-WP/assets/59590152/4f2bcfac-9f3c-4098-bd17-4fc747f0af30)

Access to Trend Vision One
*Steps to the creation of the tenant on the the Step ##

Upload the Linux agent to an AWS S3 bucket that can be accessed by the instances that will be protected
*Steps to download the agent on the Step ####
* Steps to create and allow public access of the agent in the Step #####

# Create an IAM role to enable EC2 to access AWS System Manager


Recommended Name

EnablesEC2ToAccessSystemsManagerRole

Recommended Description

Enables an EC2 instance to access Systems Manager


# Script

#!/bin/bash

DIR="agentlinux"
AGENTINSTALLER="TMServerAgent*"

if [ -d "$DIR" ]; then
    echo "Directory agentlinux exists"
    cd ~/$DIR
    wget https://linuxs3csa.s3.amazonaws.com/TMServerAgent_Linux_auto_x86_64_MAIN_Workload.tar
    tar -xvf TMServerAgent_Linux_auto_x86_64_MAIN_Workload.tar
    sudo ./tmxbc install;
else 
    echo "Directory agentlinux does not exist, Creating directory"
    mkdir $DIR
    cd ~/$DIR
    wget https://linuxs3csa.s3.amazonaws.com/TMServerAgent_Linux_auto_x86_64_MAIN_Workload.tar
    tar -xvf TMServerAgent_Linux_auto_x86_64_MAIN_Workload.tar
    sudo ./tmxbc install;
fi

![image](https://github.com/VitorCora/MassDeployV1S-WP/assets/59590152/5633c1ef-16e3-4552-ad8e-1fa3433113e5)

![image](https://github.com/VitorCora/MassDeployV1S-WP/assets/59590152/13008120-11ac-414f-9baa-896033dd660f)

