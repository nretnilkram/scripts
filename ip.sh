#!/bin/sh
#
# This script will check the current Outside/Inside IP with the IP it had last time and email if it changes.
# This script has 3 required Arguments: From Email, To Email, Internal Network Device
#
# If running on a Mac then it cannot use the mailx -r from flag
#
# Example:
#
# ip.sh "fromaddress" "toaddress" "<network device>"

OUTFILE=~/outsideIP.txt
INFILE=~/insideIP.txt

if [ ! -e $OUTFILE ]
	then
	touch $OUTFILE
	echo "0.0.0.0" > $OUTFILE
fi

if [ ! -e $INFILE ]
	then
	touch $INFILE
	echo "0.0.0.0" > $INFILE
fi

OUTIPA=$(cat $OUTFILE)
OUTIPB=$(curl -4 ip.nretnil.com)
INIPA=$(cat $INFILE)
INIPB=$(ifconfig $3 | grep "inet " | awk '{print $2}')
EMAIL=$2
FROMOPTS="-r $1"
HOSTNAME=$(hostname)

# If MAC
if [ "$(uname)" == "Darwin" ]
	then
	FROMOPTS=""
fi

EMAIL_BODY=""
SEND_EMAIL=false

if [ $OUTIPA != $OUTIPB ]
	then
	EMAIL_BODY="The Outside IP address on $HOSTNAME has changed from $OUTIPA to $OUTIPB."
	echo $OUTIPB > $OUTFILE
	SEND_EMAIL=true
fi

echo $EMAIL_BODY

if [ $INIPA != $INIPB ]
	then
	EMAIL_BODY="The Inside IP address on $HOSTNAME has changed from $INIPA to $INIPB. $EMAIL_BODY"
	echo $INIPB > $INFILE
	SEND_EMAIL=true
fi

echo $EMAIL_BODY
echo $SEND_EMAIL

if [ $SEND_EMAIL ]
	then
	echo "$EMAIL_BODY" | mailx $FROMOPTS -s "$HOSTNAME IP Address Change" $EMAIL
fi
