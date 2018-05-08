--#SET TERMINATOR ;

/*
 This file is part of db2unit: A unit testing framework for Db2 LUW.
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

/**
 * Creates the objects that require high privileges.
 *
 * Version: 2014-04-30 V2_BETA
 * Author: Andres Gomez Casanova (AngocA)
 * Made in COLOMBIA.
 */

-- Buffer pool for maximal values.
CREATE BUFFERPOOL MAX_VALUES_BP
  PAGESIZE 32K;

-- Tablespace for logger utility.
CREATE TABLESPACE MAX_VALUES_TS
  PAGESIZE 32 K
  BUFFERPOOL MAX_VALUES_BP;

COMMENT ON TABLESPACE MAX_VALUES_TS IS
  'TS just to store an empty table for max values. Could be changed.';

-- Schema for logger tables.
CREATE SCHEMA DB2UNIT_2_BETA;

COMMENT ON SCHEMA DB2UNIT_2_BETA IS 'Schema for db2unit objects';

-- Tablespace for temporal tables: TAP report.
CREATE USER TEMPORARY TABLESPACE TS_DB2UNIT_USR_TMP
  PAGESIZE 32 K
  PREFETCHSIZE AUTOMATIC
  BUFFERPOOL MAX_VALUES_BP ;

COMMENT ON TABLESPACE TS_DB2UNIT_USR_TMP IS
  'Temporal tables: TAP and XML report' ;

