#!/bin/bash -x

echo "Provisioning ${HOSTNAME}"

echo "Installing docker"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - > /dev/null
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /dev/null
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - > /dev/null
add-apt-repository "deb [arch=amd64] http://apt.kubernetes.io/ kubernetes-xenial main" > /dev/null
apt-get update > /dev/null
apt-get install -y docker-ce=17.03.2~ce-0~ubuntu-xenial > /dev/null
apt-get install -y kubelet=1.9.1-00 kubeadm=1.9.1-00 kubernetes-cni=1.9.1-00 > /dev/null