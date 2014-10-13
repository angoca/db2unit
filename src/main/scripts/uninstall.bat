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

:: Uninstalls all the components of this utility.
::
:: Version: 2014-04-30 1
:: Author: Andres Gomez Casanova (AngocA)
:: Made in COLOMBIA.

:: Checks if there is already a connection established
db2 connect > NUL
if %ERRORLEVEL% NEQ 0 (
 echo Please connect to a database before the execution of the uninstallation.
) else (
 if EXIST init.bat (
  call init.bat
 )
 goto:uninstall
)

:: There is a problem with global variables when calling the first time.
:uninstall
 echo Uninstalling db2unit
 db2 -tf %DB2UNIT_SRC_MAIN_CODE_PATH%\98-Clean.sql
 db2 -tf PACKAGES_TO_DROP.sql
 db2 -tf %DB2UNIT_SRC_MAIN_CODE_PATH%\99-CleanAdmin.sql
 del PACKAGES_TO_DROP.sql
goto:eof

