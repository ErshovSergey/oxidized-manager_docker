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
	mkdir -p /home/oxidized/.config/oxidized/
	[ -f "/home/oxidized/.config/oxidized/config" ] || ( cp /home/oxidized/.config/oxidized.default/config /home/oxidized/.config/oxidized/ && echo '  Copy default "config"' )
	[ -f "/home/oxidized/.config/oxidized/router.db.sql" ] || ( cp /home/oxidized/.config/oxidized.default/router.db.sql /home/oxidized/.config/oxidized/ && echo '  Copy default "router.db.sql"' )

	chown -R oxidized /home/oxidized/
	rm -rf /home/oxidized/.config/oxidized/pid
	/etc/init.d/auto-reload-config.runit &

#        start-stop-daemon --start --quiet --background --pidfile $PIDFILE --make-pidfile  \
        start-stop-daemon --start --pidfile $PIDFILE --make-pidfile  \
        --oknodo --chuid $USER --exec $DAEMON -- -c $CONFIG $ARGS
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

