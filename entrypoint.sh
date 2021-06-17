#!/bin/sh
#/etc/init.d/dovecot start
echo Starting dovecot
dovecot -c /etc/dovecot/dovecot.conf
echo Start first run check
sh /firstrun.sh &
while :
do
	echo Starting notbit
	notbit -s 2525 -D /data/notbit -m /data/maildir -l /data/notbit.log
	sleep 15
	#sh nohup.sh
	#sleep $[ ( $RANDOM % 7200 )  + 3600 ]s
	#killall notbit
done

