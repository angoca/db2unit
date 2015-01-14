#!/bin/bash

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