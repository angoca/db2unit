#!/usr/bin/env ksh
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
# If executed with the argument -A, then the administrative objects are
# not created.
#
# Version: 2018-05-06 V2_BETA
# Author: Andres Gomez Casanova (AngocA)
# Made in COLOMBIA.

# Global variables
export CONTINUE=true
export ADMIN_INSTALL=true

# Installs a given script.
# It uses the CONTINUE global variable to stop the execution if an error occurs.
installScript() {
 SCRIPT=${1}
 echo $SCRIPT
 if [[ -z ${DEVELOPMENT} ]] ; then
  db2 -tsf ${SCRIPT}
 else
  db2 -tvsf ${SCRIPT}
 fi
 if [[ ${?} -ne 0 ]] ; then
  export CONTINUE=false
 fi
 unset SCRIPT
}

# Function that installs the utility.
install() {
 echo "Checking prerequisites"

 [[ ${CONTINUE} = true ]] && installScript ${DB2UNIT_SRC_MAIN_CODE_PATH}/00-Prereqs.sql
 echo "Installing utility"
 if [[ ${ADMIN_INSTALL} = true ]] ; then
  [[ ${CONTINUE} = true ]] && installScript ${DB2UNIT_SRC_MAIN_CODE_PATH}/01-ObjectsAdmin.sql
 fi
 [[ ${CONTINUE} = true ]] && installScript ${DB2UNIT_SRC_MAIN_CODE_PATH}/02-Objects.sql
 [[ ${CONTINUE} = true ]] && installScript ${DB2UNIT_SRC_MAIN_CODE_PATH}/03-Headers.sql
 [[ ${CONTINUE} = true ]] && installScript ${DB2UNIT_SRC_MAIN_CODE_PATH}/04-Body.sql
 [[ ${CONTINUE} = true ]] && installScript ${DB2UNIT_SRC_MAIN_CODE_PATH}/05-Asserts.sql
 [[ ${CONTINUE} = true ]] && installScript ${DB2UNIT_SRC_MAIN_CODE_PATH}/06-AssertsNoMessage.sql
 [[ ${CONTINUE} = true ]] && installScript ${DB2UNIT_SRC_MAIN_CODE_PATH}/07-XMLReport.sql
 [[ ${CONTINUE} = true ]] && installScript ${DB2UNIT_SRC_MAIN_CODE_PATH}/08-ExportTools.sql
 [[ ${CONTINUE} = true ]] && installScript ${DB2UNIT_SRC_MAIN_CODE_PATH}/09-Version.sql

 RET_VALUE=${CONTINUE}
}

# This function checks the parameter and assign it to a global variable.
checkParam() {
 PARAM1=${1}
 if [[ "${PARAM1}" = "-A" ]] ; then
  export ADMIN_INSTALL=false
 fi
}

# Main function that starts the installation.
init() {
 # Initialize the environment.
 if [[ -x init.ksh ]] ; then
  . ./init.ksh
 fi

 echo "db2unit is licensed under the terms of the GNU General Public License v3.0"

 # Check the given parameters.
 checkParam ${2}

 install

 echo "Please visit the wiki to learn how to use and configure this utility"
 echo "https://github.com/angoca/db2unit/wiki"
 echo "To report an issue or provide feedback, please visit:"
 echo "https://github.com/angoca/db2unit/issues"
 echo
 if [[ "${RET_VALUE}" = "true" ]] ; then
  echo "db2unit was successfully installed"
  db2 -x "values 'Database: ' || current server"
  db2 -x "values 'Version: ' || db2unit.version"
  db2 -x "select 'Schema: ' || base_moduleschema from syscat.modules where moduleschema = 'SYSPUBLIC' and modulename = 'DB2UNIT'"
  RET_VALUE=0
 else
  echo "Check the ERROR(s) and reinstall the utility"
  echo "For more information visit check the FAQs:"
  echo "https://github.com/angoca/db2unit/wiki/FAQs"
  echo "You can also check the install guide:"
  echo "https://github.com/angoca/db2unit/wiki/Install"
  RET_VALUE=1
 fi
 unset CONTINUE

 # Clean environment.
 if [[ -x uninit.ksh ]] ; then
  . ./uninit.ksh
 fi
}

# Checks if there is already a connection established
db2 values current date > /dev/null
if [[ ${?} -eq 0 ]] ; then
 init ${1}
else
 echo "Please connect to a database before the execution of the installation."
 echo "Remember that to call the script the command is '. ./install.ksh'"
 echo "The -A parameter indicates that the administrative objects are not created."
 RET_VALUE=2
fi
unset CONTINUE

return ${RET_VALUE}

