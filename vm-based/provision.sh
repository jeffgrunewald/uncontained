#!/bin/bash

echo "Provisioning ${HOSTNAME}"

echo "Updating apt sources for docker and kubernetes projects"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - > /dev/null
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /dev/null
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - > /dev/null
add-apt-repository "deb [arch=amd64] http://apt.kubernetes.io/ kubernetes-xenial main" > /dev/null

echo "Updating sources cache and installing docker and kubernete packages"
apt-get update > /dev/null
apt-get install -y docker-ce=17.03.2~ce-0~ubuntu-xenial > /dev/null
apt-get install -y kubelet=1.9.1-00 kubeadm=1.9.1-00 kubernetes-cni=0.6.0-00 > /dev/null

echo "Ensure vagrant user can run docker"
usermod -a -G docker vagrant