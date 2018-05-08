# This file is part of db2unit: A unit testing framework for Db2 LUW.
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
# Version: 2014-04-30 V2_BETA
# Author: Andres Gomez Casanova (AngocA)
# Made in COLOMBIA.

# Global variables
${Script:continue}=1
${Script:adminInstall}=1
${Script:retValue}=0

# Installs a given script in Db2.
# It uses the continue global variable to stop the execution if an error occurs.
function installScript($script) {
 echo $script
 db2 -tsf ${script}
 if ( $LastExitCode -ne 0 ) {
  ${Script:continue}=0
 }
}

# Function that installs the utility.
function install() {
 echo "Checking prerequisites"
 if ( ${Script:continue} ) { installScript ${DB2UNIT_SRC_MAIN_CODE_PATH}\00-Prereqs.sql }
 echo "Installing utility"
 if ( ${Script:adminInstall} ) {
  if ( ${Script:continue} ) { installScript ${DB2UNIT_SRC_MAIN_CODE_PATH}\01-ObjectsAdmin.sql }
 }
 if ( ${Script:continue} ) { installScript ${DB2UNIT_SRC_MAIN_CODE_PATH}\02-Objects.sql }
 if ( ${Script:continue} ) { installScript ${DB2UNIT_SRC_MAIN_CODE_PATH}\03-Headers.sql }
 if ( ${Script:continue} ) { installScript ${DB2UNIT_SRC_MAIN_CODE_PATH}\04-Body.sql }
 if ( ${Script:continue} ) { installScript ${DB2UNIT_SRC_MAIN_CODE_PATH}\05-Asserts.sql }
 if ( ${Script:continue} ) { installScript ${DB2UNIT_SRC_MAIN_CODE_PATH}\06-AssertsNoMessage.sql }
 if ( ${Script:continue} ) { installScript ${DB2UNIT_SRC_MAIN_CODE_PATH}\07-XMLReport.sql }
 if ( ${Script:continue} ) { installScript ${DB2UNIT_SRC_MAIN_CODE_PATH}\08-Version.sql }
}

# This function checks the parameter and assign it to a global variable.
function checkParam($p1) {
 $param1=${p1}
 if ( "${param1}" -eq "-A" ) {
  ${Script:adminInstall}=0
 }
}

# Main function that starts the installation.
function init($p1) {
 if ( Test-Path -Path init.ps1 -PathType Leaf ) {
  .\init.ps1
 }

 echo "db2unit is licensed under the terms of the GNU General Public License v3.0"

 # Check the given parameters.
 checkParam ${p1}

 install

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
  ${Script:retValue}=0
  } else {
  echo "Check the ERROR(s) and reinstall the utility"
  echo "For more information visit check the FAQs:"
  echo "https://github.com/angoca/db2unit/wiki/FAQs"
  echo "You can also check the install guide:"
  echo "https://github.com/angoca/db2unit/wiki/Install"
  ${Script:retValue}=1
  }

 # Clean environment.
 if ( Test-Path -Path uninit.ps1 -PathType Leaf ) {
  .\uninit.ps1
 }
}

# Checks if there is already a connection established
db2 connect | Out-Null
if ( $LastExitCode -eq 0 ) {
 init $Args[0]
} else {
 echo "Please connect to a database before the execution of the installation."
 echo "Load the Db2 profile with: set-item -path env:DB2CLP -value `"**`$$**`""
 ${Script:retValue}=2
}

exit ${Script:retValue}

