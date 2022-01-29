#!/usr/bin/env bash

source scripts/app_env
mkdir -p dist/temp
export APP_ID="app_tcz_fprc"
export APP_NAME=${APP_NAME}
export APP_CNAME="frpc"
export APP_DESC="frp is a fast reverse proxy to help you expose a local server behind a NAT or firewall to the internet."

export APP_WIDTH=1000
export APP_HEIGHT=700
export APP_FRPC_VERSION="0.39.0"
export APP_VERSION="$(date +%Y%m%d)_${APP_FRPC_VERSION}"
export APP_BUILD_DATE="$(date +'%Y-%m-%d %H:%M:%S')"

# download frpc bin file
curl -sL https://github.com/fatedier/frp/releases/download/v${APP_FRPC_VERSION}/frp_${APP_FRPC_VERSION}_freebsd_386.tar.gz \
 | tar -xz -C resource/bin frp_${APP_FRPC_VERSION}_freebsd_386/frpc --strip-components 1

# build package file
cp -r scripts/* dist/temp
tar -czf dist/temp/resource.tar.gz --exclude=.gitkeep -C resource .
envsubst < app.inf.template > dist/temp/app.inf
tar -czf dist/PanabitApp-${APP_NAME}_${APP_VERSION}.apx -C dist/temp . && rm -rf dist/temp