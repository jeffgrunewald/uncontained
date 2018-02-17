### Rkt Walkthrough ###

Clone the repo into your rkt-enabled environment
```
git clone https://github.com/jeffgrunewald/uncontained.git \
    && cd uncontained/rkt/
```

Build the two container images using the acbuild scripts
```
chmod +x build-consul.sh build-vault.sh

./build-consul.sh && ./build-vault.sh
```

Generate the gpg keys
```
gpg --batch --gen-key gpg-batch (may need to run sudo rngd -r /dev/urandom)
```

Grab the fingerprint of the key for signing the images (the first sequence)
```
gpg --no-default-keyring --secret-keyring ./rkt.sec --keyring ./rkt.pub --list-keys
```

Trust the key
```
gpg --no-default-keyring \
    --secret-keyring ./rkt.sec \
    --keyring ./rkt.pub \
    --edit-key <fingerprint> trust
```
Approve with level '5', confirm with 'y' and 'quit' gpg

Export the public key
```
gpg --no-default-keyring \
    --armor \
    --secret-keyring ./rkt.sec \
    --keyring ./rkt.pub \
    --export <you@youremail.com> > pubkeys.gpg
```

Sign the acis with the rkt gpg keys
```
gpg --no-default-keyring \
    --armor \
    --secret-keyring ./rkt.sec \
    --keyring ./rkt.pub \
    --output consul-v1.0.3.aci.asc \
    --detach-sig consul-v1.0.3.aci

gpg --no-default-keyring \
    --armor \
    --secret-keyring ./rkt.sec \
    --keyring ./rkt.pub \
    --output vault-v0.9.3.aci.asc \
    --detach-sig vault-v0.9.3.aci
```

Jump back to the LXD tutorial to retrieve your artifacts

From within the rkt vm, retrieve the artifacts
```
curl -sLO https://github.com/jeffgrunewald/uncontained/releases/download/v0.1.0/consul-v1.0.3.aci
curl -sLO https://github.com/jeffgrunewald/uncontained/releases/download/v0.1.0/consul-v1.0.3.aci.asc
curl -sLO https://github.com/jeffgrunewald/uncontained/releases/download/v0.1.0/pubkeys.gpg
curl -sLO https://github.com/jeffgrunewald/uncontained/releases/download/v0.1.0/vault-v0.9.3.aci
curl -sLO https://github.com/jeffgrunewald/uncontained/releases/download/v0.1.0/vault-v0.9.3.aci.asc
```

Trust the keys for the images you approve
```
sudo rkt trust --prefix=jeffgrunewald/consul ./pubkeys.gpg
sudo rkt trust --prefix=jeffgrunewald/vault ./pubkeys.gpg
```

Run the image without the need to downgrade security with the manual command and the pod manifest
```
sudo rkt run \
    --port=consul:8500 \
    --port=vault:8200 \
    --volume=consul-data,kind=host,source=/consul \
    consul-v1.0.3.aci \
    vault-v0.9.3.aci

sudo rkt run --pod-manifest=consul-vault-pod.json
```

Ensure the acis are in the vagrant home directory and the service unit file is copied to /etc/systemd and run the pod with systemd
```
sudo cp consul-vault.service /etc/systemd/system/consul-vault.service
sudo systemctl start consul-vault
```