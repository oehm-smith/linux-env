#!/bin/bash
# Run this script to setup for GA:
# 1. AWS - ssh agent for forwarding
# 2. AWS - ssh to add the specific key when forwarding

eval `ssh-agent`
ssh-add ~/.ssh/geodesy_aws_id_rsa

echo Now to login run:
echo ssh -A -i ~/.ssh/geodesy_aws_id_rsa ec2-user@NAT_BASTION_PUBLIC_IP
echo or the -i arg might be optional:
echo ssh -A ec2-user@NAT_BASTION_PUBLIC_IP
