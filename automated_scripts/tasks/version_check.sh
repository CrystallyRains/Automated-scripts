#!/bin/bash

# -----------------------------------------------------------------------------
# Description:
# This script checks if specific tools and packages are installed on the system
# and prints their installed versions. It verifies the installation of various 
# DevOps tools like Docker, Docker Compose, Terraform, MySQL client, Redis CLI, 
# Ansible, AWS CLI, Ruby, Python3, Pip3, and the Python library Boto3.
#
# Usage:
# Simply run this script after the installation script to ensure that all 
# necessary tools have been installed correctly, and it will output their 
# respective versions or notify you if any package is not installed.
#
# Example:
# $ sh ./version_check.sh
# -----------------------------------------------------------------------------

# Function to check if a package is installed and print its version
check_version() {
    PACKAGE_NAME=$1
    CHECK_COMMAND=$2
    VERSION_COMMAND=$3  # Command to check the installed version

    if command -v $CHECK_COMMAND &> /dev/null; then
        echo "$PACKAGE_NAME is installed. Version: $($VERSION_COMMAND)"
    else
        echo "$PACKAGE_NAME is NOT installed."
    fi
}

# Check versions of common packages
check_version "Docker" "docker" "docker --version"
check_version "Docker Compose" "docker-compose" "docker-compose --version"
check_version "Terraform" "terraform" "terraform --version"
check_version "MySQL Client" "mysql" "mysql --version"
check_version "Redis CLI" "redis-cli" "redis-cli --version"
check_version "Ansible" "ansible" "ansible --version"
check_version "AWS CLI" "aws" "aws --version"
check_version "Ruby" "ruby" "ruby --version"
check_version "Python3" "python3" "python3 --version"
check_version "Pip3" "pip3" "pip3 --version"

# Check boto3 installation
if python3 -c "import boto3" &> /dev/null; then
    echo "boto3 is installed. Version: $(python3 -c 'import boto3; print(boto3.__version__)')"
else
    echo "boto3 is NOT installed."
fi

echo "Version checks complete."

