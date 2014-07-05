#!/bin/bash
DATE=$(date -u +%Y-%m-%d\ %H:%M:%S\ %Z)

## First feed
wget -q -t 5 http://hosts-file.net/ad_servers.asp -O $TARGET_OUT_ROOT/temp_hosts1
sed -i -re '/^#/d ; s/#.*$//' $TARGET_OUT_ROOT/temp_hosts1

## Second feed
wget -q -t 5 "http://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext" -O $TARGET_OUT_ROOT/temp_hosts2
sed -re '/^#/d ; s/#.*$//' $TARGET_OUT_ROOT/temp_hosts2 >> $TARGET_OUT_ROOT/temp_hosts1

## Third feed
wget -q -t 5 http://winhelp2002.mvps.org/hosts.txt -O $TARGET_OUT_ROOT/temp_hosts3
sed -re '/^#/d ; s/#.*$//' $TARGET_OUT_ROOT/temp_hosts3 >> $TARGET_OUT_ROOT/temp_hosts1

## Fourth feed
wget -q -t 5 http://someonewhocares.org/hosts/hosts -O $TARGET_OUT_ROOT/temp_hosts4
sed -re '/^#/d ; s/#.*$//' $TARGET_OUT_ROOT/temp_hosts4 >> $TARGET_OUT_ROOT/vendor/pizza/tools/temp_hosts1

## Clean up
sed -i -e 's///g' -e 's/[ \t][ \t]*/ /g' $TARGET_OUT_ROOT/temp_hosts1
sed -i -e 's/^[ \t]*//;s/[ \t]*$//' $TARGET_OUT_ROOT/temp_hosts1
sed -i -re '/\:\:1.*localhost/d' $TARGET_OUT_ROOT/temp_hosts1
sed -i -n -e '/127.0.0.1/p' $TARGET_OUT_ROOT/temp_hosts1
sed -i '/^$/d' $TARGET_OUT_ROOT/temp_hosts1

(cat << EOF) > $TARGET_OUT_ROOT/hosts
##
## File created by Mustaavalkosta's hosts script
##
## Created: $DATE
##
## Sources:
## http://hosts-file.net/ad_servers.asp
## http://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext
## http://winhelp2002.mvps.org/hosts.txt
## http://someonewhocares.org/hosts/hosts
##

127.0.0.1 localhost
EOF

awk '!seen[$0]++' $TARGET_OUT_ROOT/temp_hosts1 |sort >> $TARGET_OUT_ROOT/hosts

mv $TARGET_OUT_ROOT/hosts $TARGET_HOSTS_FILE
rm $TARGET_OUT_ROOT/temp_*
