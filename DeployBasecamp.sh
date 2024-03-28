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
