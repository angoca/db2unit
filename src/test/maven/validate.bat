@echo off
::  This file is part of db2unit: A unit testing framework for Db2 LUW.
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

:: Installs Db2, creates an instance and a database.
::
:: Version: 2018-05-12 V2_BETA
:: Author: Andres Gomez Casanova (AngocA)
:: Made in COLOMBIA.

db2 get instance > NUL 2>&1
if %ERRORLEVEL% NEQ 0 (
 echo Db2 is not installed or db2cmd is not initialized
 exit /b 1
) else (
 echo Db2 is configured.

 :: Terminates current process to have the environment clean.
 db2 terminate
 :: Attach to an instance to work with db2unit.
 db2 attach to db2unit

 echo A Db2 instance should be running.
)

