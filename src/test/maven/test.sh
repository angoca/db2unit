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

# Tests the object of the database.
#
# Version: 2015-01-14 V2_BETA
# Author: Andres Gomez Casanova (AngocA)
# Made in COLOMBIA.

FILE=/tmp/suites.txt
echo "Testing objects"
db2 connect to db2unit
cd src/test/scripts/
. ./init-dev
. ./allTests -np
cd ../../../
mkdir -p target/surefire-reports
SCHEMA=$(db2 connect to db2unit > /dev/null ;
  db2 -x "VALUES DB2UNIT.UTILITY_SCHEMA" | tr -d ' ')
db2 "EXPORT TO ${FILE} OF DEL MODIFIED BY NOCHARDEL
  SELECT SUITE_NAME FROM ${SCHEMA}.SUITES"
for i in $(cat ${FILE}) ; do
 db2 "CALL DB2UNIT.XML_REPORT_ONE('${i}')"
 db2 "EXPORT TO target/surefire-reports/TEST-${i}.Tests.xml
  OF DEL MODIFIED BY NOCHARDEL
  SELECT DOCUMENT
  FROM ${SCHEMA}.XML_REPORT" > /dev/null
done

