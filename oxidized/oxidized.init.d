#!/bin/sh
#
# Written by Stefan Schlesinger / sts@ono.at / http://sts.ono.at
#
### BEGIN INIT INFO
# Provides:          oxidized
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start Oxidized at boot time
# Description:       Oxidized - Network Device Configuration Backup Tool
### END INIT INFO

set -e

PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin
DAEMON=$(which oxidized)
NAME="oxidized"
DESC="Oxidized - Network Device Configuration Backup Tool"
ARGS=""
USER="oxidized"

test -x $DAEMON || exit 0

. /lib/lsb/init-functions

if [ -r /etc/default/$NAME ]; then
	. /etc/default/$NAME
fi

CONFIG="${CONFIG:-/etc/oxidized/config}"

PIDFILE=/var/run/$NAME.pid

do_start()
{
	echo
	cp -r /home/oxidized.default/*                /home/oxidized/ && echo '  Copy folder "oxidized"'
# файлы по умолчанию если не существуют
	[ -f "/home/oxidized/.config/oxidized/config" ] || ( cp /home/oxidized.default/.config/oxidized/config                /home/oxidized/.config/oxidized/ && echo '  Copy default "config"' )
	[ -f "/home/oxidized/.config/oxidized/router.db.sql" ] || ( cp /home/oxidized.default/.config/oxidized/router.db.sql  /home/oxidized/.config/oxidized/ && echo '  Copy default "router.db.sql"' )
	[ -f "/home/oxidized/oxidized-manager/config/config.yml" ] || ( cp /home/oxidized.default/.config/oxidized/config.yml /home/oxidized/oxidized-manager/config/config.yml && echo '  Copy default "config.yml"' )

# подготовка
	chown -R oxidized /home/oxidized/
	rm -rf /home/oxidized/.config/oxidized/pid $PIDFILE /home/oxidized/oxidized-manager.pid
# автоматическая перезагрузка
#	/etc/init.d/auto-reload-config.runit &

# старт oxidized-manager
	cd /home/oxidized/oxidized-manager \
	  && sudo -u oxidized -H bash -c "/usr/bin/env bundle exec puma -e production --pidfile /home/oxidized/oxidized-manager.pid &"

#	  && /usr/bin/env bundle exec puma -e production --pidfile /home/oxidized/oxidized-manager.pid &

# старт oxidized
        start-stop-daemon --start --quiet --pidfile $PIDFILE --make-pidfile  \
#        --oknodo --chuid $USER --exec $DAEMON -- -c $CONFIG $ARGS
         start-stop-daemon --start --quiet --pidfile $PIDFILE --make-pidfile  \
        --oknodo --chuid $USER --exec $DAEMON -- $ARGS
}

do_stop()
{
        start-stop-daemon --oknodo --stop --quiet -v --pidfile $PIDFILE \
        --chuid $USER --retry KILL/10 -- -c $CONFIG $ARGS
}

case "$1" in
  start)
        if [ "$ENABLED" = "no" ]; then
                log_failure_msg "Not starting $DESC: disabled via /etc/default/$NAME"
                exit 0
        fi

        log_daemon_msg "Starting $DESC..." "$NAME"
        if do_start ; then
                log_end_msg 0
        else
                log_end_msg 1
        fi
        ;;
  stop)
        log_daemon_msg "Stopping $DESC..." "$NAME"
        if do_stop ; then
                log_end_msg 0
        else
                log_end_msg 1
        fi
        ;;

  restart|force-reload)
        $0 stop
        sleep 1
        $0 start
        ;;
  status)
	status_of_proc -p $PIDFILE $DAEMON $NAME
	;;
  *)
	N=/etc/init.d/$NAME
	echo "Usage: $N {start|stop|restart|force-reload|status}" >&2
	exit 1
	;;
esac

exit 0

