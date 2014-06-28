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


# Installs all scripts of the utility.
#
# Version: 2014-04-30 1-Beta
# Author: Andres Gomez Casanova (AngocA)
# Made in COLOMBIA.

${Script:continue}=1

# Installs a given script.
function installScript($script) {
 echo $script
 db2 -tsf ${script}
 if ( $LastExitCode -ne 0 ) {
  ${Script:continue}=0
 }
}

function install() {
 echo "Checking prerequisites"
 if ( ${Script:continue} ) { installScript ${DB2UNIT_SRC_MAIN_CODE_PATH}\Prereqs.sql }
 echo "Installing utility"
 if ( ${Script:continue} ) { installScript ${DB2UNIT_SRC_MAIN_CODE_PATH}\ObjectsAdmin.sql }
 if ( ${Script:continue} ) { installScript ${DB2UNIT_SRC_MAIN_CODE_PATH}\Objects.sql }
 if ( ${Script:continue} ) { installScript ${DB2UNIT_SRC_MAIN_CODE_PATH}\Headers.sql }
 if ( ${Script:continue} ) { installScript ${DB2UNIT_SRC_MAIN_CODE_PATH}\Body.sql }
 if ( ${Script:continue} ) { installScript ${DB2UNIT_SRC_MAIN_CODE_PATH}\Asserts.sql }
 if ( ${Script:continue} ) { installScript ${DB2UNIT_SRC_MAIN_CODE_PATH}\AssertsNoMessage.sql }
 if ( ${Script:continue} ) { installScript ${DB2UNIT_SRC_MAIN_CODE_PATH}\Version.sql }

 echo "Please visit the wiki to learn how to use and configure this utility"
 echo "https://github.com/angoca/db2unit/wiki"
 echo "To report an issue or provide feedback, please visit:"
 echo "https://github.com/angoca/db2unit/issues"
 echo ' '
 if ( ${Script:continue} ) {
  echo "db2unit was successfully installed"
  db2 -x "values 'Database: ' || current server"
  db2 -x "values 'Version: ' || db2unit.version"
  db2 -x "select 'Schema: ' || base_moduleschema from syscat.modules where moduleschema = 'SYSPUBLIC' and modulename = 'DB2UNIT'"
 } else {
  echo "Check the error(s) and reinstall the utility"
 }
}

function init() {
 if ( Test-Path -Path init.ps1 -PathType Leaf ) {
  .\init.ps1
 }

 echo "db2unit is licensed under the terms of the GNU General Public License v3.0"

 install
}

# Checks if there is already a connection established
db2 connect | Out-Null
if ( $LastExitCode -eq 0 ) {
 init
} else {
 echo "Please connect to a database before the execution of the installation."
 echo "Load the DB2 profile with: set-item -path env:DB2CLP -value `"**`$$**`""
}

