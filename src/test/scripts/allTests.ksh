#!/usr/bin/env ksh
# This file is part of db2unit: A unit testing framework for Db2 LUW.
# Copyright (C)  2014  Andres Gomez Casanova (@AngocA)
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

# Execute all tests.
#
# Version: 2018-05-07 V2_BETA
# Author: Andres Gomez Casanova (AngocA)
# Made in COLOMBIA.

export RET=0

# Execute a given test.
executeTest() {
 SCHEMA=${1}
 PAUSE_INSTALL=${2}
 echo "====>Next: ${SCHEMA}"
 if [[ "${PAUSE_INSTALL}" = "true" ]] ; then
# TODO ksh
  echo "Press enter to continue"
  read
  . ${DB2UNIT_SRC_TEST_SCRIPT_PATH}/test.ksh ${SCHEMA} i x
 elif [[ "${PAUSE_INSTALL}" = "install_false" ]] ; then
  . ${DB2UNIT_SRC_TEST_SCRIPT_PATH}/test.ksh ${SCHEMA} i x
 elif [[ "${PAUSE_INSTALL}" = "install" ]] ; then
  . ${DB2UNIT_SRC_TEST_SCRIPT_PATH}/test.ksh ${SCHEMA} i
 else
  . ${DB2UNIT_SRC_TEST_SCRIPT_PATH}/test.ksh ${SCHEMA} x
  export RET=$(tail -1 /tmp/db2unit.output | awk '/Return Status/ {print $4}')
 fi
}

. ./init-dev.ksh

db2 values current date > /dev/null
if [ ${?} -ne 0 ] ; then
 echo "Please connect to a database before the execution of the tests."
 echo "Remember that to call the script the command is '. ./allTests.ksh'"
 echo
 echo "Options for this script"
 echo "-np : Do not install tests. Just execute test without pauses between them. Shows time."
 echo "-ix : Install tests and run them without pauses. Shows time."
 echo "-i  : Just install tests. Do no run tests."
 echo "No option: Install and execute all tests with pauses between them (Any other option is processed like this)."
else
 if [ "${1}" = "-np" ] ; then
  PAUSE_INSTALL=false
  TIME_INI=$(date +"%T")
  MILLIS_INI=$(date +"%s")
 elif [ "${1}" = "-ix" ] ; then
  PAUSE_INSTALL=install_false
  TIME_INI=$(date +"%T")
  MILLIS_INI=$(date +"%s")
 elif [ "${1}" = "-i" ] ; then
  PAUSE_INSTALL=install
 else
  PAUSE_INSTALL=true
 fi
 if [ "${PAUSE_INSTALL}" = "true" ] ; then
  echo "Executing all tests with pauses in between."
 elif [ "${PAUSE_INSTALL}" = "install" ] ; then
  echo "Installing all tests without pauses."
 elif [ "${PAUSE_INSTALL}" = "install_false" ] ; then
  echo "Installing and executing all tests without pauses."
 elif [ "${PAUSE_INSTALL}" = "false" ] ; then
  echo "Executing all tests."
 else
  echo "Error"
 fi

 export RET=0
 executeTest DB2UNIT_EMPTY ${PAUSE_INSTALL}
 SUM=${RET}
 export RET=0
 executeTest DB2UNIT_EXECUTION ${PAUSE_INSTALL}
 SUM=$((${SUM}+${RET}))
 export RET=0
 executeTest DB2UNIT_EXECUTION_2 ${PAUSE_INSTALL}
 SUM=$((${SUM}+${RET}))
 export RET=0
 executeTest DB2UNIT_ASSERTIONS_GENERAL ${PAUSE_INSTALL}
 SUM=$((${SUM}+${RET}))
 export RET=0
 executeTest DB2UNIT_ASSERTIONS_BOOLEAN ${PAUSE_INSTALL}
 SUM=$((${SUM}+${RET}))
 export RET=0
 executeTest DB2UNIT_ASSERTIONS_DATETIME ${PAUSE_INSTALL}
 SUM=$((${SUM}+${RET}))
 export RET=0
 executeTest DB2UNIT_ASSERTIONS_NUMBER ${PAUSE_INSTALL}
 SUM=$((${SUM}+${RET}))
 export RET=0
 executeTest DB2UNIT_ASSERTIONS_STRING ${PAUSE_INSTALL}
 SUM=$((${SUM}+${RET}))
 export RET=0
 executeTest DB2UNIT_ASSERTIONS_STRING_LONG ${PAUSE_INSTALL}
 SUM=$((${SUM}+${RET}))
 export RET=0
 executeTest DB2UNIT_ASSERTIONS_TABLE ${PAUSE_INSTALL}
 SUM=$((${SUM}+${RET}))
 export RET=0
 executeTest DB2UNIT_ASSERTIONS_XML ${PAUSE_INSTALL}
 SUM=$((${SUM}+${RET}))
 export RET=0
 executeTest DB2UNIT_TAP ${PAUSE_INSTALL}
 SUM=$((${SUM}+${RET}))

 if [ "${PAUSE_INSTALL}" != "true" -a "${PAUSE_INSTALL}" != "install" ] ; then
  db2 "CALL DB2UNIT.REPORT_RECENT_EXECUTIONS"

  MILLIS_END=$(date +"%s")
  TIME_END=$(date +"%T")
  echo "Difference:"
  echo "${TIME_INI} start"
  echo "${TIME_END} end"
  echo "$((${MILLIS_END}-${MILLIS_INI})) seconds"
 fi
fi

return ${SUM}

