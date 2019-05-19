#!/usr/bin/env bash

source app_env

APP_VERSION=$(date +%Y%m%d)
BUILD_DATE=$(date +"%Y-%m-%d %H:%M:%S")

output_dir="dist"

mkdir -p "${output_dir}/temp"

output_file="PanabitApp-${APP_NAME}_${APP_VERSION}_${APP_FRPC_VERSION}"

export INF_APP_ID="${APP_ID}"
export INF_APP_NAME="${APP_NAME}"
export INF_APP_CNAME="${APP_CNAME}"
export INF_APP_VERSION="${APP_VERSION}_${APP_FRPC_VERSION}"
export INF_APP_BUILD_DATE="${BUILD_DATE}"
export INF_APP_DESC="${APP_DESC}"
export INF_APP_WIDTH="${APP_WIDTH}"
export INF_APP_HEIGHT="${APP_HEIGHT}"

tar -cf - \
--exclude=dist \
--exclude=.git \
--exclude=.idea \
--exclude=*.md \
--exclude=resource \
--exclude=app.inf.template \
--exclude=app_build.sh \
--exclude=.gitignore \
. | $(cd "${output_dir}/temp" && tar -xf -)

tar -czf "${output_dir}/temp/${APP_RESOURCE_TAR_FILE}" --exclude=.gitkeep -C "resource" .
envsubst < app.inf.template > "${output_dir}/temp/app.inf"

tar -czf "${output_dir}/${output_file}.apx" -C "${output_dir}/temp" . && rm -rf "${output_dir}/temp"