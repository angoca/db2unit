--#SET TERMINATOR ;

/*
 This file is part of db2unit: A unit testing framework for D02 LUW.
 Copyright (C)  2014  Andres Gomez Casanova (@AngocA)

 db2unit is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 db2unit is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.

 Andres Gomez Casanova <angocaATyahooDOTcom>
*/

SET CURRENT SCHEMA DB2UNIT_2_BETA;

SET PATH = SYSTEM PATH, CURRENT USER;

/**
 * Writes the version. This script is the last in order to validate the
 * installation for other components.
 *
 * Version: 2018-05-06 V2_BETA
 * Author: Andres Gomez Casanova (AngocA)
 * Made in COLOMBIA.
 */

-- Module version.
ALTER MODULE DB2UNIT PUBLISH
  VARIABLE VERSION VARCHAR(32) CONSTANT '2018-05-06 2';

-- Clean environment.
SET PATH = SYSTEM PATH, CURRENT USER;

SET CURRENT SCHEMA USER;

