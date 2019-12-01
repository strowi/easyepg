#!/bin/bash

if [[ ! -d /src/easyepg  ]]; then
  git clone --depth 1 https://github.com/sunsettrack4/easyepg.git /src/easyepg
fi

cd /src/easyepg && "$@"

# run via cron
if [[ -n "${CRON}" ]]; then
  echo "# setting up cronjob: ${CRON}"
  ( crontab -l; echo "PATH=${PATH}"; echo "${CRON} cd /src/easyepg && /src/easyepg/epg.sh >> /var/log/easyepg.log" ) |crontab -
else
  echo "No con schedule specified, exiting..."
fi
