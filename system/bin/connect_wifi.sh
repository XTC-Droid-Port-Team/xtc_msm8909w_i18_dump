#! /system/bin/sh

echo "$0 $@"
#set -v on
#setenforce 0

SSID=$1

while true
do

date +%H:%M:%S
rmmod wlan
killall wpa_supplicant
echo "insmod /system/lib/modules/wlan.ko"
insmod /system/lib/modules/wlan.ko 
sleep 0.5
echo "wpa_supplicant"
wpa_supplicant -iwlan0 -Dnl80211 -c/system/etc/wifi/wpa_supplicant.conf -O/data/misc/wifi/sockets &
sleep 0.5

echo "begin wifi connect"

ifconfig wlan0 up

NETID=0
echo "wpa_cli -iwlan0 -p /data/misc/wifi/sockets remove_network $NETID"
wpa_cli -iwlan0 -p /data/misc/wifi/sockets remove_network $NETID
echo "wpa_cli -iwlan0 -p /data/misc/wifi/sockets add_network"
NETID=`wpa_cli -iwlan0 -p /data/misc/wifi/sockets add_network`
echo $NETID
echo -e wpa_cli -iwlan0 -p /data/misc/wifi/sockets set_network $NETID ssid \'\"${SSID}\"\'
wpa_cli -iwlan0 -p /data/misc/wifi/sockets set_network ${NETID} ssid '"'${SSID}'"'
echo "wpa_cli -iwlan0 -p /data/misc/wifi/sockets set_network $NETID key_mgmt NONE"
wpa_cli -iwlan0 -p /data/misc/wifi/sockets set_network $NETID key_mgmt NONE
echo "wpa_cli -iwlan0 -p /data/misc/wifi/sockets select_network $NETID"
wpa_cli -iwlan0 -p /data/misc/wifi/sockets select_network $NETID
echo "wpa_cli -iwlan0 -p /data/misc/wifi/sockets enable_network $NETID"
wpa_cli -iwlan0 -p /data/misc/wifi/sockets enable_network $NETID
sleep 0.6
i=0
STATUS=`wpa_cli -iwlan0 -p /data/misc/wifi/sockets status | grep 'wpa_state=COMPLETED'`
while [ -z "$STATUS" ] && [ "$i" != "5" ];do
    i=$(($i+1))
    echo "try to enable network $i"
    #echo "STATUS = $STATUS"
    sleep 0.5
    STATUS=`wpa_cli -iwlan0 -p /data/misc/wifi/sockets status | grep 'wpa_state=COMPLETED'`
done
if [ -z "$STATUS" ]; then
    echo "enable_network failed"
    continue
else
    echo "enable_network success"
fi

echo get ip...
ifconfig wlan0 192.168.11.10 netmask 255.255.255.0
#dhcptool wlan0
IP=`ifconfig wlan0|sed -n '/inet addr/s/^[^:]*:\([0-9.]\{7,15\}\) .*/\1/p'|cut -d '.' -f 3`
echo $IP
i=0
while [  -z "$IP" ] && [ "$i" != "3" ];do
	echo "try grep '192.168' $i"
	sleep 0.2
	IP=`ifconfig wlan0|sed -n '/inet addr/s/^[^:]*:\([0-9.]\{7,15\}\) .*/\1/p'|cut -d '.' -f 3`
	i=$(($i+1))
done

if [ -z "$IP" ] ; then
	echo "not connet to ssid $SSID"
    continue
else
	echo "Have conneted to ssid $SSID"
fi
#ping -c 1 192.168.$IP.1
#sleep 1
echo connect 192.168.$IP.1
date +%H:%M:%S
STATUS=`diag_socket_log -a 192.168.$IP.1 -p 2500`
echo $STATUS
STATUS=`echo $STATUS | grep 'Successful connect'`
if [ -n "$STATUS" ] ; then
    continue
fi

ifconfig wlan0 192.168.12.10 netmask 255.255.255.0
#dhcptool wlan0
IP=`ifconfig wlan0|sed -n '/inet addr/s/^[^:]*:\([0-9.]\{7,15\}\) .*/\1/p'|cut -d '.' -f 3`
echo $IP
i=0
while [  -z "$IP" ] && [ "$i" != "3" ];do
	echo "try grep '192.168' $i"
	sleep 0.2
	IP=`ifconfig wlan0|sed -n '/inet addr/s/^[^:]*:\([0-9.]\{7,15\}\) .*/\1/p'|cut -d '.' -f 3`
	i=$(($i+1))
done

if [ -z "$IP" ] ; then
	echo "not connet to ssid $SSID"
    continue
else
	echo "Have conneted to ssid $SSID"
fi
#ping -c 1 192.168.$IP.1
#sleep 3
echo connect 192.168.$IP.1
date +%H:%M:%S
STATUS=`diag_socket_log -a 192.168.$IP.1 -p 2500`
echo $STATUS
STATUS=`echo $STATUS | grep 'Successful connect'`
if [ -n "$STATUS" ] ; then
    continue
fi
done


