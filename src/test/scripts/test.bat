@echo off
::  This file is part of db2unit: A unit testing framework for DB2 LUW.
:: Copyright (C)  2014  Andres Gomez Casanova (@AngocA)
::
:: db2unit is free software: you can redistribute it and/or modify
:: it under the terms of the GNU General Public License as published by
:: the Free Software Foundation, either version 3 of the License, or
:: (at your option) any later version.
::
:: db2unit is distributed in the hope that it will be useful,
:: but WITHOUT ANY WARRANTY; without even the implied warranty of
:: MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
:: GNU General Public License for more details.
::
:: You should have received a copy of the GNU General Public License
:: along with this program.  If not, see <http://www.gnu.org/licenses/>.
::
:: Andres Gomez Casanova <angocaATyahooDOTcom>

:: Install and/or execute a suite of tests.
::
:: In order to run this script, it is necessary to define the environment
:: variable DB2UNIT_SRC_TEST_CODE_PATH with the directory where the test suite
:: file is.
::
::   set DB2UNIT_SRC_TEST_CODE_PATH=C:\DB2\MyTests
::
:: Version: 2014-05-01 V2_BETA
:: Author: Andres Gomez Casanova (AngocA)
:: Made in COLOMBIA.

:: Global variables
set install=0
set execute=0
set onlyExec=0

db2 connect > NUL
if %ERRORLEVEL% NEQ 0 (
 echo Please connect to a database before the execution of the test
 echo Remember that to call the script the command is 'test ^<TestSuite^> {i} {x}'
 echo i for installing by default
 echo x for executing
 echo The test file should have this structure: Test_^<SCHEMA_NAME^>.sql
) else (
 set SCHEMA=%1
 call:checkParams %2 %3

 call:process
)
goto:eof

:: Checks if the script should install
:checkParams
 set param1=%1
 set param2=%2
 if "%param1%" == "" (
  set install=1
 )
 if /I "%param1%" == "i" (
  set install=1
 )
 if /I "%param2%" == "i" (
  set install=1
 )
 if /I "%param1%" == "x" (
  set execute=1
  if /I "%param2%" == "" (
   set onlyExec=1
  )
 )
 if /I "%param2%" == "x" (
  set execute=1
 )
 set param1=
 set param2=
goto:eof

:: Process the test file
:process
 :: Install the tests.
 if %install% EQU 1 (
  :: Prepares the installation.
  db2 "DELETE FROM LOGS" > NUL
  db2 "DROP TABLE %SCHEMA%.REPORT_TESTS" > NUL
  db2 "CALL SYSPROC.ADMIN_DROP_SCHEMA('%SCHEMA%', NULL, 'ERRORSCHEMA', 'ERRORTABLE')" > NUL
  db2 "SELECT VARCHAR(SUBSTR(DIAGTEXT, 1, 256), 256) AS ERROR FROM ERRORSCHEMA.ERRORTABLE" 2> NUL
  db2 "DROP TABLE ERRORSCHEMA.ERRORTABLE" > NUL
  db2 "DROP SCHEMA ERRORSCHEMA RESTRICT" > NUL

  :: Installs the tests.
  db2 -td@ -f %DB2UNIT_SRC_TEST_CODE_PATH%\Tests_%SCHEMA%.sql
 )

 :: Execute the tests.
 if %execute% EQU 1 (
  db2 "CALL DB2UNIT.CLEAN()"
  db2 "CALL DB2UNIT.RUN_SUITE('%SCHEMA%')"
  db2 "CALL DB2UNIT.GET_LAST_EXECUTION_ORDER()"
  db2 "CALL DB2UNIT.CLEAN()"
 )

 if %onlyExec% EQU 1 (
  db2 "CALL LOGADMIN.LOGS(min_level=>5)"
  db2 "SELECT EXECUTION_ID EXEC_ID, " ^
    "VARCHAR(SUBSTR(TEST_NAME, 1, 32), 32) TEST, " ^
    "FINAL_STATE STATE, TIME, VARCHAR(SUBSTR(MESSAGE, 1, 128), 128) MESSAGE " ^
    "FROM %SCHEMA%.REPORT_TESTS ORDER BY DATE"
 )
goto:eof

