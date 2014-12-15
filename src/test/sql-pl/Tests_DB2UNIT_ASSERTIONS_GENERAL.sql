--#SET TERMINATOR @

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

SET CURRENT SCHEMA DB2UNIT_ASSERTIONS_GENERAL @

SET PATH = "SYSIBM","SYSFUN","SYSPROC","SYSIBMADM", DB2UNIT_2_BETA, DB2UNIT_ASSERTIONS_GENERAL @

/**
 * Tests for assertions.
 *
 * Version: 2014-05-01 1
 * Author: Andres Gomez Casanova (AngocA)
 * Made in COLOMBIA.
 */

-- Previously create the table in order to compile these tests.
BEGIN
 DECLARE STATEMENT VARCHAR(128);
 DECLARE CONTINUE HANDLER FOR SQLSTATE '42710' BEGIN END;
 SET STATEMENT = 'CREATE TABLE REPORT_TESTS LIKE DB2UNIT_2_BETA.REPORT_TESTS';
 EXECUTE IMMEDIATE STATEMENT;
END @

ALTER TABLE DB2UNIT_ASSERTIONS_GENERAL.REPORT_TESTS
  ALTER COLUMN SUITE_NAME
  SET WITH DEFAULT 'DB2UNIT_ASSERTIONS_GENERAL' @

-- GENERAL

-- Tests to fail a test.
CREATE OR REPLACE PROCEDURE TEST_GENERAL_01()
 BEGIN
  DECLARE ACTUAL_MSG ANCHOR DB2UNIT_2_BETA.REPORT_TESTS.MESSAGE;
  DECLARE EXPECTED_MSG ANCHOR DB2UNIT_2_BETA.REPORT_TESTS.MESSAGE;

  SET EXPECTED_MSG = 'Test failed';
  CALL DB2UNIT.FAIL();
  CALL DB2UNIT.BACK_TO_EXECUTING();

  SELECT MESSAGE INTO ACTUAL_MSG
    FROM DB2UNIT_ASSERTIONS_GENERAL.REPORT_TESTS
    WHERE DATE = (SELECT MAX(DATE) FROM DB2UNIT_ASSERTIONS_GENERAL.REPORT_TESTS);

  DELETE FROM DB2UNIT_ASSERTIONS_GENERAL.REPORT_TESTS
    WHERE MESSAGE = EXPECTED_MSG
    AND DATE = (SELECT MAX(DATE) FROM DB2UNIT_ASSERTIONS_GENERAL.REPORT_TESTS);
  DELETE FROM DB2UNIT_ASSERTIONS_GENERAL.REPORT_TESTS
    WHERE MESSAGE = 'FAIL'
    AND DATE = (SELECT MAX(DATE) FROM DB2UNIT_ASSERTIONS_GENERAL.REPORT_TESTS);

  CALL DB2UNIT.ASSERT_STRING_EQUALS(EXPECTED_MSG, ACTUAL_MSG);
 END@

-- Register the suite.
CALL DB2UNIT.REGISTER_SUITE(CURRENT SCHEMA) @

