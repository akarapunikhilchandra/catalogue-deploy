#!/bin/bash
yum install python3.11-devel python3.11-pip -y
pip3.11 install ansible botocore boto3
cd /tmp
ansible-pull -U https://github.com/akarapunikhilchandra/ansible-roles-dev.git -e component=catalogue main.yaml