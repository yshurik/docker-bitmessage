#!/bin/sh
sleep 30
if [ ! -f /data/notbit/keys.dat ]
then
	echo "Generating initial address"
	export FIRSTADDR=$(notbit-keygen)
	echo $FIRSTADDR

echo -e "From: $FIRSTADDR@bitmessage\\n"\
"To: $FIRSTADDR@bitmessage\\n"\
"Subject: Welcome to Bitmessage system\\n"\
"\\n"\
"Hello from Bitmessage\\n\\n"\
"Your personal address is $FIRSTADDR@bitmessage\\n\\n" | notbit-sendmail

fi

