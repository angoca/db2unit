# Copyright (c) 2014-2014 Andres Gomez Casanova (AngocA).
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html -->
#
# Contributors:
# Andres Gomez Casanova - initial API and implementation.

# Installs all scripts of the utility.
#
# Version: 2014-04-30 1-Alpha
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
 echo "Installing utility"
 if ( ${Script:continue} ) { installScript ${SRC_MAIN_CODE_PATH}\Objects.sql }
 if ( ${Script:continue} ) { installScript ${SRC_MAIN_CODE_PATH}\Headers.sql }
 if ( ${Script:continue} ) { installScript ${SRC_MAIN_CODE_PATH}\Body.sql }

 echo "Please visit the wiki to learn how to use and configure this utility"
 echo "https://github.com/angoca/db2unit/wiki"
 echo "To report an issue or provide feedback, please visit:"
 echo "https://github.com/angoca/db2unit/issues"
 Write-Object ' '
 if ( ${Script:continue} ) {
  echo "db2unit was successfully installed"
 } else {
  echo "Check the error(s) and reinstall the utility"
 }
}

function init() {
 if ( Test-Path -Path init.ps1 -PathType Leaf ) {
  .\init.ps1
 }

 echo "db2unit is licensed under the terms of the Eclipse license v1.0"

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

