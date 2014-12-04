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
:: Version: 2014-04-30 V2_BETA
:: Author: Andres Gomez Casanova (AngocA)
:: Made in COLOMBIA.

:: Global variables
set continue=1
set adminInstall=1
set retValue=0

:: Main call.
:: Checks if there is already a connection established
db2 connect > NUL
if %ERRORLEVEL% EQU 0 (
 call:init %1
) else (
 echo Please connect to a database before the execution of the installation.
 set retValue=2
)
exit /B %retValue%
goto:eof

:: Installs a given script.
:: It uses the continue global variable to stop the execution if an error occurs.
:installScript
 set script=%~1
 echo %script%
 db2 -tsf %script%
 if %ERRORLEVEL% NEQ 0 (
  set continue=0
 )
 set script=
goto:eof

:: Function that installs the utility.
:install
 echo Checking prerequisites
 if %continue% EQU 1 call:installScript %DB2UNIT_SRC_MAIN_CODE_PATH%\00-Prereqs.sql
 echo Installing utility
 if %adminInstall% EQU 1 (
  if %continue% EQU 1 call:installScript %DB2UNIT_SRC_MAIN_CODE_PATH%\01-ObjectsAdmin.sql
 )
 if %continue% EQU 1 call:installScript %DB2UNIT_SRC_MAIN_CODE_PATH%\02-Objects.sql
 if %continue% EQU 1 call:installScript %DB2UNIT_SRC_MAIN_CODE_PATH%\03-Headers.sql
 if %continue% EQU 1 call:installScript %DB2UNIT_SRC_MAIN_CODE_PATH%\04-Body.sql
 if %continue% EQU 1 call:installScript %DB2UNIT_SRC_MAIN_CODE_PATH%\05-Asserts.sql
 if %continue% EQU 1 call:installScript %DB2UNIT_SRC_MAIN_CODE_PATH%\06-AssertsNoMessage.sql
 if %continue% EQU 1 call:installScript %DB2UNIT_SRC_MAIN_CODE_PATH%\07-Version.sql
goto:eof

:: This function checks the parameter and assign it to a global variable.
:checkParam
 set param1=%1
 if /I "%param1%" == "-A" (
  set adminInstall=0
 )
goto:eof

:: Main function that starts the installation.
:init
 :: Initialize the environment.
 if EXIST init.bat (
  call init.bat
 )

 echo db2unit is licensed under the terms of the GNU General Public License v3.0

 :: Check the given parameters.
 call:checkParam %1

 call:install

 echo Please visit the wiki to learn how to use and configure this utility
 echo https://github.com/angoca/db2unit/wiki
 echo To report an issue or provide feedback, please visit:
 echo https://github.com/angoca/db2unit/issues
 echo.
 if %continue% EQU 1 (
  echo db2unit was successfully installed
  db2 -x "values 'Database: ' || current server"
  db2 -x "values 'Version: ' || db2unit.version"
  db2 -x "select 'Schema: ' || base_moduleschema from syscat.modules where moduleschema = 'SYSPUBLIC' and modulename = 'DB2UNIT'"
  set retValue=0
 ) else (
  echo Check the ERROR^(s^) and reinstall the utility
  echo For more information visit check the FAQs:
  echo https://github.com/angoca/db2unit/wiki/FAQs
  echo You can also check the install guide:
  echo https://github.com/angoca/db2unit/wiki/Install
  set retValue=1
 )

 :: Clean environment.
 set adminInstall=
 if EXIST uninit.bat (
  call uninit.bat
 )
goto:eof

