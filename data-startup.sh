#!/bin/bash

SERVICES="php8.2-fpm nginx openmediavault-engined postfix cron rrdcached anacron collectd"

for EACH in ${SERVICES}; do
    echo "enable ${EACH}"
    systemctl enable ${EACH}
done

for EACH in ${SERVICES}; do
    echo "start ${EACH}"
    systemctl start ${EACH}
done

