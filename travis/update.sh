#!/bin/bash

dpkg --add-architecture i386
apt-get update -qq
apt-get -y install libaio1 ksh libstdc++6-4.4-dev libstdc++6-4.4-pic libstdc++5 rpm
#libpam0g:i386 numactl
DEBIAN_FRONTEND=noninteractive apt-get install -qq libpam-ldap:i386
#apt-get install libpam-modules:i386
#apt-get install libacl1:i386

