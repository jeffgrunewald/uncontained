#!/usr/bin/env bash
set -e

consul_version=${1:-'1.0.3'}
curl -sLO https://releases.hashicorp.com/consul/${consul_version}/consul_${consul_version}_linux_amd64.zip
unzip consul_${consul_version}_linux_amd64.zip
rm consul_${consul_version}_linux_amd64.zip
chmod a+x consul

acbuild begin
acbuild set-name jeffgrunewald/consul-v${consul_version}
acbuild copy ./consul /consul
acbuild port add consul tcp 8500
acbuild mount add consul-data /data/consul
acbuild set-exec -- /consul agent -bind=127.0.0.1 -client=0.0.0.0 -bootstrap-expect=1 -recursor=8.8.8.8 -server -ui -datacenter="enterprise" -data-dir="/data/consul"

acbuild write --overwrite consul-v${consul_version}.aci
acbuild end

rm consul