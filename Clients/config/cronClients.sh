#!/bin/bash

#Load variables
set -a
source /root/wlan_config_clients


function retry { 
    $1 && echo "success" || (echo "fail" && retry $1) 
}

while :
do
	date

	#40-59 skip OPN
	killall dhclien-wifichallenge 2> /dev/nill &
	for N in `seq 40 46`; do
		timeout 5s dhclien-wifichallenge wlan$N 2> /dev/nill &
	done
	for N in `seq 50 59`; do
		timeout 5s dhclien-wifichallenge wlan$N 2> /dev/nill &
	done

	# Start Apache in client for Client isolation test
	service apache2 start > /root/logs/apache2.log 2>&1 &

	sleep 20

	killall dhclien-wifichallenge 2> /dev/nill &
	for N in `seq 40 46`; do
		timeout 5s dhclien-wifichallenge wlan$N 2> /dev/nill &
	done
	for N in `seq 50 59`; do
		timeout 5s dhclien-wifichallenge wlan$N 2> /dev/nill &
	done

	sleep 10

	# MGT
	curl -s "http://$MAC_MGT_MSCHAP.1/login.php" --interface $WLAN_MGT_MSCHAP --compressed -H 'Content-Type: application/x-www-form-urlencoded' -H 'Connection: keep-alive' --data-raw 'Username=CONTOSO%5Cjuan.tr&Password=Secret%21&Submit=Login' -c /tmp/userjuan -b /tmp/userjuan &
	curl -s "http://$MAC_MGT_GTC.1/login.php" --interface $WLAN_MGT_GTC --compressed -H 'Content-Type: application/x-www-form-urlencoded' -H 'Connection: keep-alive' --data-raw 'Username=CONTOSO%5CAdministrator&Password=SuperSecure%40%21%40&Submit=Login' -c /tmp/userAdmin -b /tmp/userAdmin &

	# MGT Relay
	curl -s "http://$IP_MGT_RELAY.1/login.php" --interface $WLAN_MGT_RELAY --compressed -H 'Content-Type: application/x-www-form-urlencoded' -H 'Connection: keep-alive' --data-raw 'Username=CONTOSOREG%5Cluis.da&Password=u89gh68!6fcv56ed&Submit=Login' -c /tmp/userluis -b /tmp/userluis  &

	# MGT TLS
	curl -s "http://$IP_TLS.1/login.php" --interface $WLAN_TLS --compressed -H 'Content-Type: application/x-www-form-urlencoded' -H 'Connection: keep-alive' --data-raw 'Username=GLOBAL%5CGlobalAdmin&Password=SuperSuperSecure%40%21%40&Submit=Login' -c /tmp/userGlobal -b /tmp/userGlobal  &

	# MGT TLS PHISHING
	# TODO use template, get redirect and POST
	curl -s "http://$IP_TLS_PHISHING.1/login.php" --interface $WLAN_TLS_PHISHING --compressed -H 'Content-Type: application/x-www-form-urlencoded' -H 'Connection: keep-alive' --data-raw 'Username=GLOBAL%5CGlobalManager&Password=password1%40%21&Submit=Login' -c /tmp/userPhishing -b /tmp/userPhishing  &

	# PSK, only login if cookies error
	STATUS=`curl -o /dev/null -w '%{http_code}\n' -s "http://$IP_WPA_PSK.1/lab.php" -c /tmp/userTest1 -b /tmp/userTest1`
	if [ "$STATUS" -ne 200 ] ; then
		curl -s "http://$IP_WPA_PSK.1/login.php" --interface $WLAN_WPA_PSK --compressed -H 'Content-Type: application/x-www-form-urlencoded' -H 'Connection: keep-alive' --data-raw 'Username=test1&Password=OYfDcUNQu9PCojb&Submit=Login' -c /tmp/userTest1 -b /tmp/userTest1 &
	fi

	STATUS=`curl -o /dev/null -w '%{http_code}\n' -s "http://$IP_WPA_PSK2.1/lab.php" -c /tmp/userTest2 -b /tmp/userTest2`
	if [ "$STATUS" -ne 200 ] ; then
		curl -s "http://$IP_WPA_PSK2.1/login.php" --interface $WLAN_WPA_PSK2 --compressed -H 'Content-Type: application/x-www-form-urlencoded' -H 'Connection: keep-alive' --data-raw 'Username=test2&Password=2q60joygCBJQuFo&Submit=Login' -c /tmp/userTest2 -b /tmp/userTest2 &
	fi

	# PSK NOAPP
	curl -s "http://$WLAN_PSK_NOAP.1/login.php" --interface $WLAN_PSK_NOAP --compressed -H 'Content-Type: application/x-www-form-urlencoded' -H 'Connection: keep-alive' --data-raw 'Username=anon1&Password=CRgwj5fZTo1cO6Y&Submit=Login' -c /tmp/userAnon1  -b /tmp/userAnon1 &
	curl -s "http://$WLAN_PSK_NOAP2.1/login.php" --interface $WLAN_PSK_NOAP2 --compressed -H 'Content-Type: application/x-www-form-urlencoded' -H 'Connection: keep-alive' --data-raw 'Username=anon1&Password=CRgwj5fZTo1cO6Y&Submit=Login' -c /tmp/userAnon11 -b /tmp/userAnon11 &

	# OPEN
	curl -s "http://$IP_OPN1.1/login.php" --interface $WLAN_OPN1 --compressed -H 'Content-Type: application/x-www-form-urlencoded' -H 'Connection: keep-alive' --data-raw 'Username=free1&Password=Jyl1iq8UajZ1fEK&Submit=Login' -c /tmp/userFree1 -b /tmp/userFree1 &
	curl -s "http://$IP_OPN2.1/login.php" --interface $WLAN_OPN2 --compressed -H 'Content-Type: application/x-www-form-urlencoded' -H 'Connection: keep-alive' --data-raw 'Username=free2&Password=5LqwwccmTg6C39y&Submit=Login' -c /tmp/userFree2 -b /tmp/userFree2 &
	curl -s "http://$IP_OPN3.1/login.php" --interface $WLAN_OPN3 --compressed -H 'Content-Type: application/x-www-form-urlencoded' -H 'Connection: keep-alive' --data-raw 'Username=free1&Password=Jyl1iq8UajZ1fEK&Submit=Login' -c /tmp/userFree11 -b /tmp/userFree11 &

	# TODO Phishing client connect
	dhclien-wifichallenge -r $WLAN_TLS_PHISHING 2> /tmp/dhclien-wifichallenge
	dhclien-wifichallenge -v $WLAN_TLS_PHISHING 2>> /tmp/dhclien-wifichallenge
	SERVER=`grep -E -o "from (25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" /tmp/dhclien-wifichallenge | awk '{print $2}' | head -n 1`
	URL=`curl -Ls -o /dev/null -w %{url_effective} "http://$SERVER/" -c /tmp/userTLSPhishing -b /tmp/userTLSPhishing`
	curl -L -s "$URL" --interface $WLAN_TLS_PHISHING -H 'Content-Type: application/x-www-form-urlencoded' --data-raw 'username=GLOBAL\Manager&password=CorpoGlobal2022' -c /tmp/userTLSPhishing -b /tmp/userTLSPhishing > /dev/null &
	# Responder ""vuln""
	smbmap -d 'CORPO' -u 'god' -p "123456789" -H $SERVER 2> /dev/nill

   #curl "$URL" -X POST -H 'Content-Type: application/x-www-form-urlencoded' --data-raw 'username=user1&password=pass2' -c /tmp/userTLSPhishing -b /tmp/userTLSPhishing

	# WPA3 Downgrade
    curl -s "http://$IP_DOWNGRADE.1/login.php" --interface $WLAN_DOWNGRADE --compressed -H 'Content-Type: application/x-www-form-urlencoded' -H 'Connection: keep-alive' --data-raw 'Username=manager1&Password=Aaa23dF4r&Submit=Login' -c /tmp/userManager1 -b /tmp/userManager1 &


	sleep 30

done


#curl "$URL" -X POST -H 'Content-Type: application/x-www-form-urlencoded' --data-raw 'username=user1&password=pass2'
