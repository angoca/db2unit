# Copyright (c) 2014-2014 Andres Gomez Casanova (AngocA).
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html -->
#
# Contributors:
# Andres Gomez Casanova - initial API and implementation.

# Uninstalls all the components of this utility.
#
# Version: 2014-04-30 1-Alpha
# Author: Andres Gomez Casanova (AngocA)
# Made in COLOMBIA.

# Checks if there is already a connection established
db2 connect | Out-Null
if ( ${LastExitCode} -ne 0 ) {
 echo "Please connect to a database before the execution of the uninstallation."
 echo "Load the DB2 profile with: set-item -path env:DB2CLP -value `"**`$$**`""
} else {
 if ( Test-Path -Path init.ps1 -PathType Leaf ) {
  .\init.ps1
 }
 echo "Uninstalling db2unit"
 db2 -tf ${SRC_MAIN_CODE_PATH}\Clean.sql
 db2 -tf ${SRC_MAIN_CODE_PATH}\CleanAdmin.sql
}

