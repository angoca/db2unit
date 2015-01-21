#!/bin/bash
# This file is part of db2unit: A unit testing framework for DB2 LUW.
# Copyright (C)  2014, 2015  Andres Gomez Casanova (@AngocA)
#
# db2unit is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# db2unit is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Andres Gomez Casanova <angocaATyahooDOTcom>

# Installs DB2, creates an instance and a database.
#
# Version: 2015-01-14 V2_BETA
# Author: Andres Gomez Casanova (AngocA)
# Made in COLOMBIA.

TEMP_WIKI_DOC=db2-link-server_t.md
DB2_INSTALLER=v10.5fp5_linuxx64_server_t.tar.gz
DB2_RSP_FILE_INSTALL_URL=https://raw.githubusercontent.com/angoca/db2-docker/master/install/10.5/server_t/db2server_t.rsp
DB2_RSP_FILE_INSTANCE_URL=https://raw.githubusercontent.com/angoca/db2-docker/master/instance/server_t/db2server_t.rsp
DB2_RSP_FILE=db2server_t.rsp
INSTANCE_NAME=db2inst1
DB2_DIR=/opt/ibm/db2/V10.5

DIR=$(strings /var/db2/global.reg 2> /dev/null | grep -s '^\/' | sort | uniq | grep -v sqllib | grep -v das | head -1)
echo "Directory $DIR"
if [ ! -x ${DIR}/bin/db2 ] ; then
 echo "DB2 non installed"

 # Install libraries
 #sudo apt-get update
 #sudo apt-get install libaio1 lib32stdc++6 -y
 #sudo DEBIAN_FRONTEND=noninteractive apt-get install -qq libpam-ldap:i386
 #sudo ln -s /lib/i386-linux-gnu/libpam.so.0 /lib/libpam.so.0
 #sudo apt-get install -y aria2 curl

 wget https://raw.githubusercontent.com/wiki/angoca/db2-docker/db2-link-server_t.md
 URL=$(cat $(ls -1rt | tail -1) | tail -1)
 echo "URL: ${URL}"
 # aria2c -x 16  ${URL}
 tar -zxf ${DB2_INSTALLER}
 rm ${DB2_INSTALLER}
 wget ${DB2_RSP_FILE_INSTALL_URL}

 ls -l
 RSP=$(cat $(ls -1rt | tail -1) | tail -1)
 echo "Response file ${DB2_RSP_FILE} old"
 echo "Response file ${RSP}"
 #cat ${RSP}
 cd server_t
 ls -l
 ./db2setup -r ../${RSP}
else
 echo "Installed"
fi

INSTANCE_NAME=$(${DIR}/instance/db2ilist | grep db2inst1)
if [ "${INSTANCE_NAME}" != "db2inst1" ] ; then
 echo "Instance ${INSTANCE_NAME} does not exist"
 wget ${DB2_RSP_FILE_INSTANCE_URL}
 ${DB2_DIR}/instance/db2isetup -r ${DB2_RESP_FILE}
 su -c "db2start" - db2inst1
fi

su -c "db2 create db db2unit" - db2inst1

echo "Environment was configured"

