--#SET TERMINATOR @

/*
Copyright (c) 2014-2014 Andres Gomez Casanova (AngocA).

All rights reserved. This program and the accompanying materials
are made available under the terms of the Eclipse Public License v1.0
which accompanies this distribution, and is available at
http://www.eclipse.org/legal/epl-v10.html -->

Contributors:
Andres Gomez Casanova - initial API and implementation.
*/

SET CURRENT SCHEMA TEST_DB2UNIT @

SET PATH = "SYSIBM","SYSFUN","SYSPROC","SYSIBMADM", DB2UNIT_1A, TEST_DB2UNIT @

/**
 * Tests for Execute Tests.
 *
 * Version: 2014-04-30 1-Alpha
 * Author: Andres Gomez Casanova (AngocA)
 * Made in COLOMBIA.
 */

CREATE SCHEMA TEST_DB2UNIT @

CREATE OR REPLACE PROCEDURE TEST_1 ()
 BEGIN
  DECLARE ACTUAL_MSG ANCHOR DB2UNIT_1A.EXECUTION_REPORTS.MESSAGE;
  DECLARE EXPECTED_MSG ANCHOR DB2UNIT_1A.EXECUTION_REPORTS.MESSAGE;
  DECLARE SCHEMA_NAME VARCHAR(16);

  SET SCHEMA_NAME = 'NoSchema';
  SET EXPECTED_MSG = 'The given schema does  not exists: ' || SCHEMA_NAME;
  CALL DB2UNIT.EXECUTE_TESTS(SCHEMA_NAME);
  SELECT MESSAGE INTO ACTUAL_MSG
    FROM DB2UNIT_1A.EXECUTION_REPORTS;

  CALL DB2UNIT.ASSERT(EXPECTED_MSG, ACTUAL_MSG);
 END@

