#!/bin/bash

echo "Testing objects"
db2 connect to db2unit
cd src/test/scripts/
. ./init-dev
#. ./allTests -np
cd ../../../
mkdir -p target/surefire-reports
db2 -x "CALL DB2UNIT.XML_REPORT_ONE()" | head -5 | tail -1 > target/surefire-reports/TEST-db2unit.Tests.xml
