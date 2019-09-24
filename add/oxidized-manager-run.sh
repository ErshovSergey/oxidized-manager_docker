#!/bin/bash
set -e

[ -z "`ls /home/oxidized/oxidized-manager/`" ] && cp -R /home/oxidized/oxidized-manager.orig/* /home/oxidized/oxidized-manager/
rm /root/.config/oxidized/config && ln -s /home/oxidized/.config/oxidized/config  /root/.config/oxidized/config

/db_sqlite_add.sh

cd /home/oxidized/oxidized-manager
/usr/bin/env bundle exec puma -e production--pidfile/home/oxidized/oxidized-manager.pid

sleep infinity
