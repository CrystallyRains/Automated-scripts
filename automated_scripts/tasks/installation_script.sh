#!/bin/bash

# Function to check and install a package based on OS
install_if_not_exists() {
    PACKAGE_NAME=$1
    CHECK_COMMAND=$2
    VERSION=$3  # Optional argument for package-specific version

    if ! command -v $CHECK_COMMAND &> /dev/null; then
        echo "Installing $PACKAGE_NAME..."
        if [[ "$OS_FAMILY" == "debian" ]]; then
            if [[ "$PACKAGE_NAME" == "terraform" ]]; then
                # Add HashiCorp repository for Terraform installation on Debian-based systems
                echo "Adding HashiCorp repository for Terraform..."
                curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - || exit 1
                sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" || exit 1
                sudo apt-get update -y
            fi
            sudo apt-get install -y $PACKAGE_NAME || exit 1  # Debian-based installation
        elif [[ "$OS_FAMILY" == "rhel" ]]; then
            if [[ "$PACKAGE_NAME" == "terraform" ]]; then
                # Add HashiCorp repository for Terraform installation on RedHat-based systems
                echo "Adding HashiCorp repository for Terraform..."
                sudo yum install -y yum-utils || exit 1
                sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo || exit 1
            fi
            sudo yum install -y $PACKAGE_NAME || exit 1  # RedHat-based installation
        else
            echo "Unsupported OS: $OS_FAMILY"
            exit 1
        fi
    else
        echo "$PACKAGE_NAME is already installed."
    fi
}

# Detect OS type by reading /etc/os-release
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

# Install common packages
install_if_not_exists "docker.io" "docker"
install_if_not_exists "docker-compose" "docker-compose"
install_if_not_exists "terraform" "terraform"  # Terraform installation with HashiCorp repo handling
install_if_not_exists "mysql-client" "mysql"
install_if_not_exists "redis-tools" "redis-cli"
install_if_not_exists "ansible" "ansible"
install_if_not_exists "awscli" "aws"
install_if_not_exists "ruby" "ruby"

# Install Python3, pip3, and boto3 together
install_if_not_exists "python3" "python3"
install_if_not_exists "python3-pip" "pip3"

# Install boto3 if not already installed
if ! python3 -c "import boto3" &> /dev/null; then
    echo "Installing boto3 via pip..."
    pip3 install boto3 || exit 1
else
    echo "boto3 is already installed."
fi

# Cleanup
echo "Cleaning up..."
if [[ "$OS_FAMILY" == "debian" ]]; then
    sudo apt-get autoremove -y || exit 1
else
    sudo yum autoremove -y || exit 1
fi

echo "All required tools are installed and up-to-date."

