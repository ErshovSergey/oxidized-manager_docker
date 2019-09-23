#!/bin/bash
set -e
cd /home/oxidized/oxidized-manager
/usr/bin/env bundle exec puma -e production--pidfile/home/oxidized/oxidized-manager.pid
sleep infinity

