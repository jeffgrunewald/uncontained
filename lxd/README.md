### LXD walkthrough ###

Add the lxd host as your Mac client's "remote" as the daemon doesn't work outside of Linux
```
lxc remote add vagrant 127.0.0.1 \
    && lxc remote set-default vagrant
```

Launch a fresh container
```
lxc launch ubuntu:16.04 test1 --storage default --network lxdbr0
```

Install the packages needed to work with rkt
```
apt-get update && apt-get install rng-tools unzip
```

Write out the container as a new local image
```
lxc publish container-name --alias image-name
```

Curl the uncontained image and import it
```
curl -sLO https://github.com/jeffgrunewald/uncontained/releases/download/v0.1.0/uncontained.tar.xz
lxc image import uncontained.tar.xz --alias=uncontained
```

Create the uncontained profile for setting image properties
```
lxc profile create uncontained \
    && cat container-profile.yaml \
    | lxc profile edit uncontained
```

Stand up the rkt environment
```
lxc launch uncontained rkt-builder --profile uncontained
```

Log into the first lxd host and add the second vm as an additional remote. You'll need to approve trusting the remote host and provide the remote password (uncontained). Then copy the image and profile to the new remote.
```
vagrant ssh lxd1

lxc remote add lxd2 192.168.56.100

lxc profile copy lxd1:uncontained lxd2:uncontained

lxc image copy lxd1:uncontained lxd2: --alias=uncontained
```

Migrate the container to the second host, into the second host and verify
```
lxc move lxd1:uncontained lxd2:uncontained
```

Build and sign the rkt images (jump to the rkt portion of the tutorial), then copy the artifacts back to your Mac
```
lxc file pull \
    uncontained/uncontained/rkt/consul-v1.0.3.aci \
    uncontained/uncontained/rkt/vault-v0.9.3.aci \
    uncontained/uncontained/rkt/consul-v1.0.3.aci.asc \
    uncontained/uncontained/rkt/vault-v0.9.3.aci.asc \
    uncontained/uncontained/rkt/pubkeys.gpg \
    ./
```