#!/bin/bash

# Description:
# This script automates the installation of various development tools such as Docker, Docker Compose, Terraform, MySQL Client, Redis, Ansible,
# AWS CLI, Python3, pip3, boto3, Ruby, and Go. The script is compatible with both Debian and RedHat-based systems. 
# It checks if each package is installed, installs it if not, and verifies the installed versions.
# The script installs specific versions of each tool by default, but allows the user to confirm, skip, or provide a custom version during execution.
# The goal is to streamline the setup of a development environment with flexibility for user customization.

# Hybrid Approach:
# The script will prompt the user to:
# 1. Confirm whether to install each tool.
# 2. Optionally specify a custom version to install, or use the default version provided in the script.
# 3. Skip the installation of any tool if desired.

# Usage:
# Run this script as a user with sudo privileges.
# To execute the script, navigate to its directory and run:
# ./installation_script.sh

# Ensure the script is executable by running:
# chmod +x installation_script.sh

# Function to prompt user for confirmation and optional version input
prompt_installation() {
    PACKAGE_NAME=$1    # The name of the package (e.g., Docker, Terraform)
    DEFAULT_VERSION=$2 # The default version for the package
    CHECK_COMMAND=$3   # The command used to verify if the package is installed (e.g., 'docker', 'terraform')

    # Ask user if they want to install this package
    read -p "Do you want to install $PACKAGE_NAME? (y/n): " CONFIRM_INSTALL
    if [[ "$CONFIRM_INSTALL" != "y" ]]; then
        echo "Skipping $PACKAGE_NAME installation."
        return 1  # Skip this installation
    fi

    # Ask user if they want to use the default version or provide a custom version
    read -p "Install default version $DEFAULT_VERSION of $PACKAGE_NAME? (y/n): " USE_DEFAULT_VERSION
    if [[ "$USE_DEFAULT_VERSION" == "y" ]]; then
        VERSION=$DEFAULT_VERSION  # Use default version
    else
        read -p "Enter the version of $PACKAGE_NAME you want to install (or press Enter for default): " CUSTOM_VERSION
        VERSION=${CUSTOM_VERSION:-$DEFAULT_VERSION}  # Use custom version or default if left blank
    fi

    # Check if the package is already installed
    if command -v $CHECK_COMMAND &> /dev/null; then
        echo "$PACKAGE_NAME is already installed."
        return 1  # Skip installation
    fi

    # Proceed with the installation of the package
    install_if_not_exists $PACKAGE_NAME $CHECK_COMMAND $VERSION
}

# Function to install a package if it is not already installed
install_if_not_exists() {
    PACKAGE_NAME=$1
    CHECK_COMMAND=$2
    VERSION=$3

    # Install the package based on OS family
    echo "Installing $PACKAGE_NAME version $VERSION..."
    if [[ "$OS_FAMILY" == "debian" ]]; then
        if [[ "$PACKAGE_NAME" == "terraform" ]]; then
            echo "Adding HashiCorp repository for Terraform..."
            curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - || exit 1
            sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" || exit 1
            sudo apt-get update -y
        fi
        sudo apt-get install -y $PACKAGE_NAME=$VERSION || exit 1
    elif [[ "$OS_FAMILY" == "rhel" ]]; then
        if [[ "$PACKAGE_NAME" == "terraform" ]]; then
            echo "Adding HashiCorp repository for Terraform..."
            sudo yum install -y yum-utils || exit 1
            sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo || exit 1
        fi
        sudo yum install -y $PACKAGE_NAME-$VERSION || exit 1
    else
        echo "Unsupported OS: $OS_FAMILY"
        exit 1
    fi
}

# Detect the operating system
echo "Detecting operating system..."
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    if [[ "$ID_LIKE" == "debian" ]]; then
        OS_FAMILY="debian"
    elif [[ "$ID_LIKE" == "rhel" ]]; then
        OS_FAMILY="rhel"
    else
        echo "Unsupported OS"
        exit 1
    fi
else
    echo "Unsupported OS"
    exit 1
fi

echo "Operating System detected: $OS_FAMILY"

# Update package lists based on OS
echo "Updating package lists..."
if [[ "$OS_FAMILY" == "debian" ]]; then
    sudo apt-get update -y && sudo apt-get upgrade -y || exit 1
else
    sudo yum update -y || exit 1
fi

# Define default versions for each tool
DEFAULT_DOCKER_VERSION="20.10.21"
DEFAULT_DOCKER_COMPOSE_VERSION="1.29.2"
DEFAULT_TERRAFORM_VERSION="1.2.9"
DEFAULT_MYSQL_CLIENT_VERSION="8.0.28"
DEFAULT_REDIS_CLIENT_VERSION="6.2.6"
DEFAULT_ANSIBLE_VERSION="2.10.8"
DEFAULT_AWS_CLI_VERSION="2.11.20"
DEFAULT_RUBY_VERSION="2.7.5"
DEFAULT_PYTHON_VERSION="3.9.10"
DEFAULT_GO_VERSION="1.20.5"

# Prompt the user and install each tool based on their confirmation and version input
prompt_installation "Docker" $DEFAULT_DOCKER_VERSION "docker"
prompt_installation "Docker Compose" $DEFAULT_DOCKER_COMPOSE_VERSION "docker-compose"
prompt_installation "Terraform" $DEFAULT_TERRAFORM_VERSION "terraform"
prompt_installation "MySQL Client" $DEFAULT_MYSQL_CLIENT_VERSION "mysql"
prompt_installation "Redis" $DEFAULT_REDIS_CLIENT_VERSION "redis-cli"
prompt_installation "Ansible" $DEFAULT_ANSIBLE_VERSION "ansible"
prompt_installation "AWS CLI" $DEFAULT_AWS_CLI_VERSION "aws"
prompt_installation "Ruby" $DEFAULT_RUBY_VERSION "ruby"
prompt_installation "Python3" $DEFAULT_PYTHON_VERSION "python3"
prompt_installation "Go" $DEFAULT_GO_VERSION "go"

# Install pip3 and boto3
if command -v pip3 &> /dev/null; then
    echo "pip3 is already installed."
else
    echo "Installing pip3..."
    sudo apt-get install -y python3-pip || sudo yum install -y python3-pip || exit 1
fi

# Install boto3 using pip3
if ! python3 -c "import boto3" &> /dev/null; then
    echo "Installing boto3..."
    pip3 install boto3 || exit 1
else
    echo "boto3 is already installed."
fi

# Cleanup unused packages
echo "Cleaning up unused packages..."
if [[ "$OS_FAMILY" == "debian" ]]; then
    sudo apt-get autoremove -y || exit 1
else
    sudo yum autoremove -y || exit 1
fi

# Notify the user to source .bashrc
echo "Go has been installed successfully!"
echo "Please run 'source ~/.bashrc' to update your environment variables."

echo "All tools have been installed and verified successfully."

