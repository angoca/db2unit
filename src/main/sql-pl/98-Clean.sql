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

SET CURRENT SCHEMA DB2UNIT_2_BETA;

/**
 * Removes db2unit from the database.
 *
 * Version: 2014-04-30 V2_BETA
 * Author: Andres Gomez Casanova (AngocA)
 * Made in COLOMBIA.
 */

COMMIT;

DROP PUBLIC ALIAS DB2UNIT FOR MODULE;

DROP MODULE DB2UNIT;

DROP TABLE TEMP_REPORT_TESTS;

DROP TABLE TAP_REPORT;

DROP TABLE LICENSE;

DROP TABLE MAX_SIGNAL;

DROP TABLE MAX_STRING;

DROP TABLE MAX_VALUES;

DROP TABLE REPORT_TESTS;

DROP TABLE RESULT_TESTS;

DROP TABLE SORTS;

DROP TABLE SUITES_EXECUTIONS;

DROP TABLE SUITE_LOCKS;

DROP PUBLIC ALIAS DB2UNIT_EXECUTION_REPORTS;

DROP TABLE EXECUTION_REPORTS;

DROP TABLE SUITES;

DROP TABLE EXECUTIONS;

EXPORT TO PACKAGES_TO_DROP.sql OF DEL MODIFIED BY NOCHARDEL
  SELECT 'DROP PACKAGE ' || PKGSCHEMA || '.' || TRIM(PKGNAME) || ';'
  FROM SYSCAT.PACKAGES
  WHERE PKGSCHEMA = 'DB2UNIT_2_BETA';

