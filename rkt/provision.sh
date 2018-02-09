#!/bin/bash

echo "Provisioning ${HOSTNAME}"

echo "Installing build deps"
apt-get update > /dev/null
apt-get install -y unzip rng-tools > /dev/null

echo "Installing rkt packages"
wget https://github.com/rkt/rkt/releases/download/v1.29.0/rkt_1.29.0-1_amd64.deb > /dev/null
dpkg -i rkt_1.29.0-1_amd64.deb > /dev/null

echo "Grabbing the acbuild tool"
curl -sL https://github.com/containers/build/releases/download/v0.4.0/acbuild-v0.4.0.tar.gz \
    | tar -xzf - --strip-components=1 -C /usr/local/bin/ > /dev/null

echo "Prep the vm for running the pods"
mkdir /consul > /dev/null
chmod a+x build-consul.sh > /dev/null
chmod a+x build-vault.sh > /dev/null
chmod a+x initialize-vault.sh > /dev/null
chmod a+x cleanup.sh > /dev/null