#!/bin/bash

echo "Provisioning ${HOSTNAME}"

echo "Installing lxd and related packages"
apt-get update > /dev/null
apt-get install -y -t \
    xenial-backports \
    lxd \
    lxd-client \
    > /dev/null
apt-get install -y \
    criu \
    libnet1 \
    rng-tools \
    zfsutils-linux \
    > /dev/null
usermod -a -G lxd vagrant > /dev/null

wget https://launchpad.net/ubuntu/+source/criu/2.12-1ubuntu2/+build/12156767/+files/criu_2.12-1ubuntu2_amd64.deb
dpkg -i criu_2.12-1ubuntu2_amd64.deb

echo "Configure the lxd daemon"
sleep 15
lxc network create lxdbr0 ipv6.address=none ipv4.address=192.168.0.1/24 ipv4.nat=true > /dev/null
lxc storage create default dir > /dev/null
lxc config set core.https_address :8443 > /dev/null
lxc config set core.trust_password uncontained > /dev/null