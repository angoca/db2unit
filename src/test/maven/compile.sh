#!/bin/bash

echo "Creating objects"
db2 connect to db2unit
cd src/test/scripts/
. ./init-dev
#. ./allTests -i
