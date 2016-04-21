#!/bin/sh
#
# This script will check the current Outside IP with the IP it had last time and email if it changes
#
# If running on a Mac then it cannot use the mailx -r from flag
#
# Example:
#
# ip.sh "Mark Lintern (mark.lintern@oracle.com)" "mark.lintern@oracle.com"

FILE=~/outsideIP.txt

if [ ! -e $FILE ]
	then
	touch $FILE
	echo "0.0.0.0" > $FILE
fi

IPA=$(cat $FILE)
IPB=$(curl -4 ip.nretnil.com)
EMAIL=$2
FROM="-r \"$1\""
HOSTNAME=$(hostname)

if [ "$(uname)" == "Darwin" ]
	then
	FROM=""
fi

if [ $IPA != $IPB ]
	then
	echo "The Outside IP address on $HOSTNAME has changed from $IPA to $IPB" | mailx $FROM -s "$HOSTNAME IP Address Change" $EMAIL
	echo $IPB > $FILE
fi
