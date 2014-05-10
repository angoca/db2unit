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
:: Version: 2014-05-01 1-Alpha
:: Author: Andres Gomez Casanova (AngocA)
:: Made in COLOMBIA.

db2 connect > NUL
if %ERRORLEVEL% NEQ 0 (
 echo Please connect to a database before the execution of the test
 echo Remember that to call the script the command is 'test <TestSuite> {i} {x}'
 echo i for installing (by default)
 echo x for executing
 echo The test file should have this structure: Test_<SCHEMA_NAME>.sql
) else (
 set SCHEMA=%1
 set OPTION_1=%2
 set OPTION_2=%3
 :: Execute the tests.
 :: if "%OPTION_1%" EQU "" -o "%OPTION_1%" EQU "i" -o "%OPTION_2%" EQU "i" (
 :: A OR B OR C = not [ not { not ( not A and not B ) } and not C ]
 if (not if (not if (not if (not "%OPTION_1%" EQU "") if (not "%OPTION_1%" EQU "i"))) if (not "%OPTION_2%" EQU "i")) (
  :: Prepares the installation.
  db2 "DELETE FROM LOGS" > NUL
  db2 "DROP TABLE %1.REPORT_TESTS" > NUL
  db2 "CALL SYSPROC.ADMIN_DROP_SCHEMA('%SCHEMA%', NULL, 'ERRORSCHEMA', 'ERRORTABLE')" > NUL
  db2 "SELECT VARCHAR(SUBSTR(DIAGTEXT, 1, 256), 256) AS ERROR FROM ERRORSCHEMA.ERRORTABLE" 2> NUL
  db2 "DROP TABLE ERRORSCHEMA.ERRORTABLE" > NUL

  :: Installs the tests.
  db2 -td@ -f ../sql-pl/Tests_%SCHEMA%.sql
 )

 :: Execute the tests.
 ::if "%OPTION_1%" EQU "x" -o "%OPTION_2%" EQU "x" (
 if (not "%OPTION_1%" EQU "x") if ("%OPTION_2%" EQU "x") (
  db2 "CALL DB2UNIT.CLEAN()"
  db2 "CALL DB2UNIT.RUN_SUITE('%SCHEMA%')"
  db2 "CALL DB2UNIT.CLEAN()"
 )
)

