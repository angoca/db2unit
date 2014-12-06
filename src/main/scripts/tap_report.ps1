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
# Version: 2014-04-30 V2_BETA
# Author: Andres Gomez Casanova (AngocA)
# Made in COLOMBIA.

# Function that installs the utility.
function install() {
 # Generates the report (any previous report is deleted).
 db2 "CALL DB2UNIT.CREATE_TAP_REPORT()" | Out-Null
 # Exports the report to a file.
 db2 "EXPORT TO $env:temp\tap.report OF DEL MODIFIED BY NOCHARDEL
  SELECT MESSAGE
  FROM DB2UNIT_2_BETA.TAP_REPORT
  ORDER BY NUMBER" | Out-Null
 # Shows the file.
 Get-Content $env:temp\tap.report 
}

# Checks if there is already a connection established
db2 connect | Out-Null
if ( $LastExitCode -eq 0 ) {
 init $Args[0]
} else {
 echo "Please connect to a database before the execution of the installation."
 echo "Load the DB2 profile with: set-item -path env:DB2CLP -value `"**`$$**`""
 echo "This script generates a report only if a test suite has been executed"
}

