--#SET TERMINATOR ;

/*
 This file is part of db2unit: A unit testing framework for DB2 LUW.
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

SET CURRENT SCHEMA DB2UNIT_1;

/**
 * Creates the objects that require high privileges.
 *
 * Version: 2014-04-30 1
 * Author: Andres Gomez Casanova (AngocA)
 * Made in COLOMBIA.
 */

-- Buffer pool for max values.
CREATE BUFFERPOOL MAX_VALUES_BP
  PAGESIZE 32K;

-- Tablespace for logger utility.
CREATE TABLESPACE MAX_VALUES_TS
  PAGESIZE 32 K
  BUFFERPOOL MAX_VALUES_BP;

COMMENT ON TABLESPACE MAX_VALUES_TS IS
  'TS just to store an empty table for max values. Could be changed.';

-- Schema for logger tables.
CREATE SCHEMA DB2UNIT_1;

COMMENT ON SCHEMA DB2UNIT_1 IS 'Schema for db2unit objects';

