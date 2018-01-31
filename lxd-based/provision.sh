#!/bin/bash

echo "Provisioning ${HOSTNAME}"

echo "Preparing iptables"
sudo modprobe br_netfilter > /dev/null
echo 'br_netfilter' | sudo tee -a /etc/modules
echo 'net.bridge.bridge-nf-call-iptables = 1' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p > /dev/null

echo "Removing default LXD"
sudo apt-get remove lxd > /dev/null

echo "Installing snapd"
sudo apt-get install snapd zfsutils-linux > /dev/null

echo "Installing lxd"
sudo snap install lxd > /dev/null

echo "Updating PATH to include /snap"
export PATH=/snap/bin:$PATH
echo 'export PATH=/snap/bin:$PATH' | tee -a /home/ubuntu/.bashrc

echo "Configure the lxd daemon"
sleep 15
lxc network create lxdbr0 ipv6.address=none ipv4.address=192.168.0.1/24 ipv4.nat=true > /dev/null
lxc storage create default dir > /dev/null
lxc config set core.https_address :8443 > /dev/null
lxc config set core.trust_password uncontained > /dev/null