#!/bin/sh

#This script is created by ssparser automatically. The parser first created by MaoShouyan
printf "Content-type: application/javascript
Cache-Control: no-cache

"
echo -n "";

# ram disk
RAM_DISK="/usr/ramdisk"

# app name
APP_NAME=frpc

# app run path
APP_RUN_ROOT="${RAM_DISK}/app/${APP_NAME}"

if [ -f ../../../app_env ]; then
    . ../../../app_env
else
    . "${APP_RUN_ROOT}/app_env"
fi

cat ${APP_WEB_STATIC_FOLDER}/js/app.js