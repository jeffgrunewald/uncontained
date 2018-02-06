#!/usr/bin/env bash
set -e

if [ "$#" -ne 1 ]; then
    echo "Please pass a version of vault to download"
    exit 1
fi

vault_version=$1
curl -sLO https://releases.hashicorp.com/vault/${vault_version}/vault_${vault_version}_linux_amd64.zip
unzip vault_${vault_version}_linux_amd64.zip
rm vault_${vault_version}_linux_amd64.zip
chmod a+x vault

acbuild begin
acbuild set-name jeffgrunewald/vault-v${vault_version}
acbuild copy ./vault /vault
acbuild copy ./config.hcl /config.hcl
acbuild port add http tcp 8200
acbuild set-exec -- /vault server -config=/config.hcl

acbuild write --overwrite vault-v${vault_version}.aci
acbuild end