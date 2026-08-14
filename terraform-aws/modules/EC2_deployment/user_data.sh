#!/bin/bash

set -e

exec > >(tee /var/log/jenkins-user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

echo "=========================================="
echo "Starting Jenkins EC2 Setup"
echo "Ubuntu 24.04"
echo "=========================================="

export DEBIAN_FRONTEND=noninteractive

# --------------------------------------------------
# System Update
# --------------------------------------------------

apt-get update -y
apt-get upgrade -y

# --------------------------------------------------
# Basic Packages
# --------------------------------------------------

apt-get install -y \
    curl \
    wget \
    unzip \
    git \
    gnupg \
    ca-certificates \
    lsb-release \
    apt-transport-https \
    software-properties-common \
    fontconfig

# --------------------------------------------------
# Java 21
# --------------------------------------------------

echo "Installing Java 21..."

apt-get install -y openjdk-21-jdk

java -version

# --------------------------------------------------
# Docker
# --------------------------------------------------

echo "Installing Docker..."

install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    -o /etc/apt/keyrings/docker.asc

chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${VERSION_CODENAME}") stable" \
  > /etc/apt/sources.list.d/docker.list

apt-get update -y

apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

systemctl enable docker
systemctl start docker

docker --version

# Ubuntu user Docker permission
usermod -aG docker ubuntu

# --------------------------------------------------
# Jenkins Repository
# --------------------------------------------------

echo "Installing Jenkins..."

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key \
    -o /usr/share/keyrings/jenkins-keyring.asc

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
    > /etc/apt/sources.list.d/jenkins.list

apt-get update -y

apt-get install -y jenkins

systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins

# Jenkins Docker permission
usermod -aG docker jenkins

systemctl restart docker
systemctl restart jenkins

# --------------------------------------------------
# AWS CLI v2
# --------------------------------------------------

echo "Installing AWS CLI v2..."

cd /tmp

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
    -o awscliv2.zip

unzip -o awscliv2.zip

./aws/install

/usr/local/bin/aws --version

rm -rf /tmp/aws
rm -f /tmp/awscliv2.zip

# --------------------------------------------------
# Terraform
# --------------------------------------------------

echo "Installing Terraform..."

TERRAFORM_VERSION="1.13.1"

wget \
    "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
    -O /tmp/terraform.zip

unzip -o /tmp/terraform.zip -d /usr/local/bin/

chmod +x /usr/local/bin/terraform

terraform version

rm -f /tmp/terraform.zip

# --------------------------------------------------
# kubectl
# --------------------------------------------------

echo "Installing kubectl..."

KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)

curl -L \
    "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
    -o /tmp/kubectl

install -o root -g root -m 0755 \
    /tmp/kubectl \
    /usr/local/bin/kubectl

kubectl version --client

rm -f /tmp/kubectl

# --------------------------------------------------
# Helm
# --------------------------------------------------

echo "Installing Helm..."

curl -fsSL \
    https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \
    -o /tmp/get_helm.sh

chmod 700 /tmp/get_helm.sh

/tmp/get_helm.sh

helm version

rm -f /tmp/get_helm.sh

# --------------------------------------------------
# Permissions
# --------------------------------------------------

usermod -aG docker ubuntu
usermod -aG docker jenkins

systemctl restart docker
systemctl restart jenkins

# --------------------------------------------------
# Verification
# --------------------------------------------------

echo "=========================================="
echo "Installation Verification"
echo "=========================================="

echo "Java:"
java -version

echo "Docker:"
docker --version

echo "Git:"
git --version

echo "AWS CLI:"
aws --version

echo "Terraform:"
terraform version

echo "kubectl:"
kubectl version --client

echo "Helm:"
helm version

echo "Jenkins:"
systemctl is-active jenkins || true

echo "Docker:"
systemctl is-active docker || true

echo "Port 8080:"
ss -lntp | grep 8080 || true

echo "=========================================="
echo "Jenkins Initial Admin Password"
echo "=========================================="

if [ -f /var/lib/jenkins/secrets/initialAdminPassword ]; then
    cat /var/lib/jenkins/secrets/initialAdminPassword
else
    echo "Password file not available"
fi

echo "=========================================="
echo "Ubuntu Jenkins EC2 Setup Completed"
echo "=========================================="