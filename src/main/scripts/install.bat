@echo off
:: Copyright (c) 2014-2014 Andres Gomez Casanova (AngocA).
::
:: All rights reserved. This program and the accompanying materials
:: are made available under the terms of the Eclipse Public License v1.0
:: which accompanies this distribution, and is available at
:: http://www.eclipse.org/legal/epl-v10.html -->
::
:: Contributors:
:: Andres Gomez Casanova - initial API and implementation.

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
 echo Installing utility
 if %continue% EQU 1 call:installScript %SRC_MAIN_CODE_PATH%\Objects.sql
 if %continue% EQU 1 call:installScript %SRC_MAIN_CODE_PATH%\Headers.sql
 if %continue% EQU 1 call:installScript %SRC_MAIN_CODE_PATH%\Body.sql

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

 echo db2unit is licensed under the terms of the Eclipse license v1.0

 call:install
goto:eof

