#!/bin/bash

SERVICES="openmediavault php8.2-fpm rrdcached sudo anacron ntp openmediavault-engined cron postfix nginx collectd rc.local"

for EACH in ${SERVICES}; do
    echo "enable ${EACH}"
    systemctl enable ${EACH}
done

for EACH in ${SERVICES}; do
    echo "start ${EACH}"
    systemctl start ${EACH}
done

