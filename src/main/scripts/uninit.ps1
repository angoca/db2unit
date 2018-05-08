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

# Cleans the environment variables.
#
# Version: 2014-06-28 V2_BETA
# Author: Andres Gomez Casanova (AngocA)
# Made in COLOMBIA.

# When testing, the variables are preserved.
if ( ! ( Test-Path Variable:\DB2UNIT_SRC_TEST_CODE_PATH ) ) {
 Remove-Variable DB2UNIT_SRC_MAIN_CODE_PATH -Scope Global
 Remove-Variable DB2UNIT_SRC_MAIN_SCRIPT_PATH -Scope Global
}

