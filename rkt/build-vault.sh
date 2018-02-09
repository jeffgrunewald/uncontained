#!/usr/bin/env bash
set -e

vault_version=${1:-'0.9.3'}
curl -sLO https://releases.hashicorp.com/vault/${vault_version}/vault_${vault_version}_linux_amd64.zip
unzip vault_${vault_version}_linux_amd64.zip
rm vault_${vault_version}_linux_amd64.zip
chmod a+x vault

acbuild begin
acbuild set-name jeffgrunewald/vault-v${vault_version}
acbuild copy ./vault /vault
acbuild copy ./vault-configs/config.hcl /config.hcl
acbuild port add vault tcp 8200
acbuild set-exec -- /vault server -config=/config.hcl

acbuild write --overwrite vault-v${vault_version}.aci
acbuild end