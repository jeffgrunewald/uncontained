#!/usr/bin/env bash
set -e

vault_addr="-address=http://127.0.0.1:8200"

secrets=$(mktemp)
trap "rm -rf ${secrets}" EXIT

# capture vault init output
init_result=$(vault operator init "${vault_addr}" | sed 's/\x1b\[[0-9;]*m//g' | grep ':' > "${secrets}")
keys=$(cat "${secrets}" | grep "Unseal Key" | awk "{print \$4}")
root_token=$(cat "${secrets}" | grep "Initial Root Token:" | awk "{print \$4}")

for key in $keys
do
    # provide the necessary keys to unseal in sequence
    vault operator unseal "${vault_addr}" $key
done

# login to write out initial configs
vault login "${vault_addr}" "${root_token}"

# write out kv filesystem authz policies
vault policy write "${vault_addr}" admin ./vault-configs/admin.hcl
vault policy write "${vault_addr}" project2 ./vault-configs/project2.hcl

# enable the userpass authc backend for simplicity
vault auth enable "${vault_addr}" userpass

# add a super cool user
vault write "${vault_addr}" auth/userpass/users/jeff \
    password=foo \
    policies=admin

# add another user who is less cool
vault write "${vault_addr}" auth/userpass/users/steve \
    password=bar \
    policies=project2

vault token revoke "${vault_addr}" "${root_token}"