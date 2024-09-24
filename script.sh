#!/bin/bash

sudo yum update -y

# Install EPEL repository for Amazon Linux
sudo amazon-linux-extras install epel -y

# Install Ansible
sudo yum install ansible -y

# Verify Ansible installation
ansible --version
