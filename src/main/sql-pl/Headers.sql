--#SET TERMINATOR ;

/*
Copyright (c) 2014-2014 Andres Gomez Casanova (AngocA).

All rights reserved. This program and the accompanying materials
are made available under the terms of the Eclipse Public License v1.0
which accompanies this distribution, and is available at
http://www.eclipse.org/legal/epl-v10.html -->

Contributors:
Andres Gomez Casanova - initial API and implementation.
*/

SET CURRENT SCHEMA DB2UNIT_1A;

/**
 * Creates the objects of the db2unit code.
 *
 * Version: 2014-04-30 1-Alpha
 * Author: Andres Gomez Casanova (AngocA)
 * Made in COLOMBIA.
 */

-- Module for objects of the db2unit framework.
CREATE OR REPLACE MODULE DB2UNIT;

COMMENT ON MODULE DB2UNIT IS 'Objects for the db2unit utility';

CREATE OR REPLACE PUBLIC ALIAS DB2UNIT FOR MODULE DB2UNIT;

COMMENT ON PUBLIC ALIAS DB2UNIT FOR MODULE IS 'Public objects of db2unit';

-- Module version.
ALTER MODULE DB2UNIT PUBLISH
  VARIABLE VERSION VARCHAR(32) CONSTANT '2014-04-30 1-Alpha';

-- Utility schema.
ALTER MODULE DB2UNIT PUBLISH
  VARIABLE UTILITY_SCHEMA VARCHAR(16) CONSTANT 'DB2UNIT_1A';

-- Constant for the name of the report's table.
ALTER MODULE DB2UNIT PUBLISH
  VARIABLE REPORTS_TABLE VARCHAR(16) CONSTANT 'REPORT_TESTS';

-- Execute the test.
ALTER MODULE DB2UNIT PUBLISH
  PROCEDURE RUN_SUITE (
  IN SCHEMA_NAME ANCHOR SYSCAT.SCHEMATA.SCHEMANAME
  );

-- Cleans environment.
ALTER MODULE DB2UNIT PUBLISH
  PROCEDURE CLEAN (
  );

-- Cleans the result of the last assertion.
ALTER MODULE DB2UNIT PUBLISH
  PROCEDURE CLEAN_TEST_RESULT (
  );

-- Assert equals two strings.
ALTER MODULE DB2UNIT PUBLISH
  PROCEDURE ASSERT_EQUALS (
  IN EXPECTED_MSG ANCHOR DB2UNIT_1A.MAX_STRING.STRING,
  IN ACTUAL_MSG ANCHOR DB2UNIT_1A.MAX_STRING.STRING
  );

-- Assert equals two strings with a given message.
ALTER MODULE DB2UNIT PUBLISH
  PROCEDURE ASSERT_EQUALS (
  IN MESSAGE ANCHOR DB2UNIT_1A.MAX_VALUES.MESSAGE_ASSERT,
  IN EXPECTED_MSG ANCHOR DB2UNIT_1A.MAX_STRING.STRING,
  IN ACTUAL_MSG ANCHOR DB2UNIT_1A.MAX_STRING.STRING
  );

-- Assert the true value.
ALTER MODULE DB2UNIT PUBLISH
  PROCEDURE ASSERT_TRUE (
  IN VALUE BOOLEAN
  );

-- Assert the true value with a given message.
ALTER MODULE DB2UNIT PUBLISH
  PROCEDURE ASSERT_TRUE (
  IN MESSAGE ANCHOR DB2UNIT_1A.MAX_VALUES.MESSAGE_ASSERT,
  IN VALUE BOOLEAN
  );

-- Assert the false value.
ALTER MODULE DB2UNIT PUBLISH
  PROCEDURE ASSERT_FALSE (
  IN CONDITION BOOLEAN
  );

-- Assert the false value with a given message.
ALTER MODULE DB2UNIT PUBLISH
  PROCEDURE ASSERT_FALSE (
  IN MESSAGE ANCHOR DB2UNIT_1A.MAX_VALUES.MESSAGE_ASSERT,
  IN CONDITION BOOLEAN
  );

-- Assert that the string is null.
ALTER MODULE DB2UNIT PUBLISH
  PROCEDURE ASSERT_NULL (
  IN CONDITION ANCHOR DB2UNIT_1A.MAX_STRING.STRING
  );

