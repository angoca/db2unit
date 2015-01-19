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

:: Tests the object of the database.
::
:: Version: 2015-01-14 V2_BETA
:: Author: Andres Gomez Casanova (AngocA)
:: Made in COLOMBIA.
echo on
set FILE=%TMP%\suites.txt
set SCHEMA_FILE=%TMP%\schema
echo Testing objects
db2 connect to db2unit
cd src\test\scripts\
call init-dev
::call allTests -np
cd ..\..\..\
md target 2> NUL
md target\surefire-reports 2> NUL
db2 -x "VALUES DB2UNIT.UTILITY_SCHEMA" > %SCHEMA_FILE% && for /f %%a in ('type %SCHEMA_FILE%') do set SCHEMA=%%a
db2 EXPORT TO %FILE% OF DEL MODIFIED BY NOCHARDEL ^
  SELECT SUITE_NAME FROM %SCHEMA%.SUITES
for /f %%i in ('TYPE %FILE%') do (
 echo Exporting report for %%i
 db2 "CALL DB2UNIT.XML_REPORT_ONE('%%i')" > NUL
 db2 EXPORT TO target\surefire-reports\TEST-%%i.Tests.xml ^
  OF DEL MODIFIED BY NOCHARDEL ^
  SELECT DOCUMENT ^
  FROM %SCHEMA%.XML_REPORT > NUL
 )

