#!/bin/sh

file=~/outsideIP.txt

if [ ! -e $file ]
  then
	touch $file
	echo "0.0.0.0" > $file
fi

ipa=$(cat $file)
ipb=$(curl icanhazip.com)
email="<add email here>"

if [ $ipa != $ipb ]
  then
	echo "The Outside IP address has changed from $ipa to $ipb" | mail -s "IP Address Change" $email
	echo $ipb > $file
fi
