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

# Generates the TAP report and shows it in the standard output.
#
# Version: 2018-05-06 V2_BETA
# Author: Andres Gomez Casanova (AngocA)
# Made in COLOMBIA.

# Creates the report
report() {
 # Generates the report (any previous report is deleted).
 db2 "CALL DB2UNIT.CREATE_TAP_REPORT()" > /dev/null
 # Exports the report to a file.
 db2 "EXPORT TO /tmp/tap.report OF DEL MODIFIED BY NOCHARDEL
  SELECT MESSAGE
  FROM DB2UNIT_2_BETA.TAP_REPORT
  ORDER BY NUMBER" > /dev/null
 # Shows the file.
 cat /tmp/tap.report
}

# Checks if there is already a connection established
db2 values current date > /dev/null
if [ ${?} -eq 0 ] ; then
 report
else
 echo "Please connect to a database before the creation of the report."
 echo "Remember that to call the script the command is '. ./tap_report.ksh'"
 echo "This script generates a report only if a test suite has been executed."
fi

