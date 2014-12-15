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

# Execute all tests.
#
# Version: 2014-05-10 V2_BETA
# Author: Andres Gomez Casanova (AngocA)
# Made in COLOMBIA.

.\init-dev.ps1

db2 connect | Out-Null
if ( $LastExitCode -ne 0 ) {
 echo "Please connect to a database before the execution of the tests."
 echo "Load the DB2 profile with: set-item -path env:DB2CLP -value `"**`$$**`""
} else {
 echo "Executing all tests with pauses in between."

 Write-Host "(next DB2UNIT_EMPTY)"
 & .\${DB2UNIT_SRC_TEST_SCRIPT_PATH}\test.ps1 DB2UNIT_EMPTY i x
 Write-Host "Press enter to continue (next DB2UNIT_EXECUTION)"
 $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
 & .\${DB2UNIT_SRC_TEST_SCRIPT_PATH}\test.ps1 DB2UNIT_EXECUTION i x
 Write-Host "Press enter to continue (next DB2UNIT_EXECUTION_2)"
 $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
 & .\${DB2UNIT_SRC_TEST_SCRIPT_PATH}\test.ps1 DB2UNIT_EXECUTION_2 i x
 Write-Host "Press enter to continue (next DB2UNIT_ASSERTIONS_GENERAL)"
 $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
 & .\${DB2UNIT_SRC_TEST_SCRIPT_PATH}\test.ps1 DB2UNIT_ASSERTIONS_GENERAL i x
 Write-Host "Press enter to continue (next DB2UNIT_ASSERTIONS_BOOLEAN)"
 $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
 & .\${DB2UNIT_SRC_TEST_SCRIPT_PATH}\test.ps1 DB2UNIT_ASSERTIONS_BOOLEAN i x
 Write-Host "Press enter to continue (next DB2UNIT_ASSERTIONS_DATETIME)"
 $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
 & .\${DB2UNIT_SRC_TEST_SCRIPT_PATH}\test.ps1 DB2UNIT_ASSERTIONS_DATETIME i x
 Write-Host "Press enter to continue (next DB2UNIT_ASSERTIONS_NUMBER)"
 $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
 & .\${DB2UNIT_SRC_TEST_SCRIPT_PATH}\test.ps1 DB2UNIT_ASSERTIONS_NUMBER i x
 Write-Host "Press enter to continue (next DB2UNIT_ASSERTIONS_STRING)"
 $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
 & .\${DB2UNIT_SRC_TEST_SCRIPT_PATH}\test.ps1 DB2UNIT_ASSERTIONS_STRING i x
 Write-Host "Press enter to continue (next DB2UNIT_ASSERTIONS_STRING_LONG)"
 $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
 & .\${DB2UNIT_SRC_TEST_SCRIPT_PATH}\test.ps1 DB2UNIT_ASSERTIONS_STRING_LONG i x
 Write-Host "Press enter to continue (next DB2UNIT_ASSERTIONS_TABLE)"
 $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
 & .\${DB2UNIT_SRC_TEST_SCRIPT_PATH}\test.ps1 DB2UNIT_ASSERTIONS_TABLE i x
 Write-Host "Press enter to continue (next DB2UNIT_ASSERTIONS_XML)"
 $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
 & .\${DB2UNIT_SRC_TEST_SCRIPT_PATH}\test.ps1 DB2UNIT_ASSERTIONS_XML i x
 Write-Host "Press enter to continue (next DB2UNIT_TAP)"
 $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
 & .\${DB2UNIT_SRC_TEST_SCRIPT_PATH}\test.ps1 DB2UNIT_TAP i x

 db2 "CALL DB2UNIT.REPORT_RECENT_EXECUTIONS"
}

