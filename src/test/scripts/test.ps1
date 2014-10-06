# This file is part of db2unit: A unit testing framework for DB2 LUW.
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

# Install and/or execute a suite of tests.
#
# Version: 2014-05-01 1-Beta
# Author: Andres Gomez Casanova (AngocA)
# Made in COLOMBIA.

db2 connect | Out-Null
if ( $LastExitCode -ne 0 ) {
 echo "Please connect to a database before the execution of the test."
 echo "Load the DB2 profile with: set-item -path env:DB2CLP -value `"**`$$**`""
 echo "Remember that to call the script the command is '.\test <TestSuite> {i} {x}'"
 echo "i for installing (by default)"
 echo "x for executing"
 echo "The test file should have this structure: Test_<SCHEMA_NAME>.sql"
} else {
 SCHEMA=$Args[0]
 OPTION_1=$Args[1]
 OPTION_2=$Args[2]
 # Execute the tests.
 if ( "${OPTION_1}" -eq "" -or "${OPTION_1}" -eq "i" -or "${OPTION_2}" -eq "i" ( {
  # Prepares the installation.
  db2 "DELETE FROM LOGS" | Out-Null
  db2 "DROP TABLE ${SCHEMA}.REPORT_TESTS" | Out-Null
  db2 "CALL SYSPROC.ADMIN_DROP_SCHEMA('${SCHEMA}', NULL, 'ERRORSCHEMA', 'ERRORTABLE')" | Out-Null
  db2 "SELECT VARCHAR(SUBSTR(DIAGTEXT, 1, 256), 256) AS ERROR FROM ERRORSCHEMA.ERRORTABLE" 2>&1 | Out-Null
  db2 "DROP TABLE ERRORSCHEMA.ERRORTABLE" | Out-Null
  db2 "DROP SCHEMA ERRORSCHEMA RESTRICT" | Out-Null

  # Installs the tests.
  db2 -td@ -f ${DB2UNIT_SRC_TEST_CODE_PATH}/Tests_${SCHEMA}.sql
 }

 # Execute the tests.
 if ( "${OPTION_1}" -eq "x" -or "${OPTION_2}" -eq "x" ) {
  db2 "CALL DB2UNIT.CLEAN()"
  db2 "CALL DB2UNIT.RUN_SUITE('${SCHEMA}')"
  db2 "CALL DB2UNIT.CLEAN()"
 }

 if ( "${OPTION_1}" -eq "" -or "${OPTION_1}" -eq "i" -or "${OPTION_2}" -eq "i" ( {
  db2 "CALL LOGADMIN.LOGS(min_level=>4)"
  db2 "SELECT EXECUTION_ID EXEC_ID, VARCHAR(SUBSTR(TEST_NAME, 1, 32), 32) TEST,
    FINAL_STATE STATE, TIME, VARCHAR(SUBSTR(MESSAGE, 1, 128), 128)
    FROM ${SCHEMA}.REPORT_TESTS ORDER BY DATE"
 }
}

