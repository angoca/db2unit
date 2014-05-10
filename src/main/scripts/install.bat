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


:: Installs all scripts of the utility.
::
:: Version: 2014-04-30 1-Alpha
:: Author: Andres Gomez Casanova (AngocA)
:: Made in COLOMBIA.

set continue=1

:: Checks if there is already a connection established
db2 connect > NUL
if %ERRORLEVEL% EQU 0 (
 call:init
) else (
 echo Please connect to a database before the execution of the installation.
)
goto:eof

:: Installs a given script.
:installScript
 set script=%~1
 echo %script%
 db2 -tsf %script%
 if %ERRORLEVEL% NEQ 0 (
  set continue=0
 )
goto:eof

:install
 echo Checking prerequisites
 if %continue% EQU 1 call:installScript %DB2UNIT_SRC_MAIN_CODE_PATH%\Prereqs.sql
 echo Installing utility
 if %continue% EQU 1 call:installScript %DB2UNIT_SRC_MAIN_CODE_PATH%\ObjectsAdmin.sql
 if %continue% EQU 1 call:installScript %DB2UNIT_SRC_MAIN_CODE_PATH%\Objects.sql
 if %continue% EQU 1 call:installScript %DB2UNIT_SRC_MAIN_CODE_PATH%\Headers.sql
 if %continue% EQU 1 call:installScript %DB2UNIT_SRC_MAIN_CODE_PATH%\Body.sql
 if %continue% EQU 1 call:installScript %DB2UNIT_SRC_MAIN_CODE_PATH%\Asserts.sql
 if %continue% EQU 1 call:installScript %DB2UNIT_SRC_MAIN_CODE_PATH%\AssertsNoMessage.sql

 echo Please visit the wiki to learn how to use and configure this utility
 echo https://github.com/angoca/db2unit/wiki
 echo To report an issue or provide feedback, please visit:
 echo https://github.com/angoca/db2unit/issues
 echo.
 if %continue% EQU 1 (
  echo db2unit was successfully installed
 ) else (
  echo "Check the error(s) and reinstall the utility"
 )
goto:eof

:init
 if EXIST init.bat (
  call init.bat
 )

 echo db2unit is licensed under the terms of the GNU General Public License v3.0

 call:install
goto:eof

