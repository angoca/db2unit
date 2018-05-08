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
:: Version: 2015-01-14 V2_BETA
:: Author: Andres Gomez Casanova (AngocA)
:: Made in COLOMBIA.

db2 force applications all
db2 drop db db2unit

echo Creating database...
db2 create db db2unit
db2 connect to db2unit
db2 create tablespace systoolspace

echo Installing log4db2
cd ../../../../log4db2
install

echo Environment was configured

