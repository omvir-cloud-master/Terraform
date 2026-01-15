#!/bin/bash
set -e

apt-get update -y

apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  software-properties-common \
  lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable"

apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io

systemctl start docker
systemctl enable docker
usermod -aG docker ubuntu
