#!/bin/bash
set -e
set -x
pid=0

sigterm_handler() {
  echo "sigterm handler called..."
    if [ $pid -ne 0 ]; then
      kill -TERM "$pid"
      wait "$pid"
    fi
    exit 0;
}
trap 'kill ${!}; sigterm_handler' SIGTERM

echo Starting dovecot
dovecot -c /etc/dovecot/dovecot.conf
echo Start first run check
su -l bm -c "sh /firstrun.sh &"

while true
do
  su -l bm -c "notbit -s 2525 -D /data/notbit -m /data/maildir -l /data/notbit.log" & wait ${!}
done
