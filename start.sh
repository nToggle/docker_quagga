#!/bin/bash

sed -i 's/^zebra=.*$/zebra=yes/g' /etc/quagga/daemons

if [ -v ENABLE_BGPD ]; then
  sed -i 's/^bgpd=.*$/bgpd=yes/g' /etc/quagga/daemons
else
  sed -i 's/^bgpd=.*$/bgpd=no/g' /etc/quagga/daemons
fi

if [ -v ENABLE_OSPFD ]; then
  sed -i 's/^ospfd=.*$/ospfd=yes/g' /etc/quagga/daemons
else
  sed -i 's/^ospfd=.*$/ospfd=no/g' /etc/quagga/daemons
fi

service quagga start
/usr/bin/python /usr/lib/python2.7/dist-packages/clcmd_server.py
