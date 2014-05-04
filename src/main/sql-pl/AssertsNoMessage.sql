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

SET CURRENT SCHEMA DB2UNIT_1A @

/**
 * Asserts implementation.
 *
 * Version: 2014-05-04 1-Alpha
 * Author: Andres Gomez Casanova (AngocA)
 * Made in COLOMBIA.
 */

/**
 * Asserts if the given two strings are the same, in nullability, in length and
 * in content.
 *
 * IN EXPECTED_STRING
 *   Expected string.
 * IN ACTUAL_STRING
 *   Actual string.
 */
ALTER MODULE DB2UNIT ADD
  PROCEDURE ASSERT_EQUALS (
  IN EXPECTED_STRING ANCHOR DB2UNIT_1A.MAX_STRING.STRING,
  IN ACTUAL_STRING ANCHOR DB2UNIT_1A.MAX_STRING.STRING
  )
  LANGUAGE SQL
  SPECIFIC P_ASSERT_EQUALS
  DYNAMIC RESULT SETS 0
  MODIFIES SQL DATA
  NOT DETERMINISTIC
  NO EXTERNAL ACTION
  PARAMETER CCSID UNICODE
 P_ASSERT_EQUALS: BEGIN
  CALL ASSERT_EQUALS(NULL, EXPECTED_STRING, ACTUAL_STRING);
 END P_ASSERT_EQUALS @

/**
 * Asserts if the given value is true.
 *
 * IN VALUE
 *   Value to check against TRUE.
 */
ALTER MODULE DB2UNIT ADD
  PROCEDURE ASSERT_TRUE (
  IN VALUE BOOLEAN
  )
  LANGUAGE SQL
  SPECIFIC P_ASSERT_TRUE
  DYNAMIC RESULT SETS 0
  MODIFIES SQL DATA
  NOT DETERMINISTIC
  NO EXTERNAL ACTION
  PARAMETER CCSID UNICODE
 P_ASSERT_TRUE: BEGIN
  CALL ASSERT_TRUE(NULL, VALUE);
 END P_ASSERT_TRUE @

/**
 * Asserts if the given value is false.
 *
 * IN VALUE
 *   Value to check against FALSE.
 */
ALTER MODULE DB2UNIT ADD
  PROCEDURE ASSERT_FALSE (
  IN CONDITION BOOLEAN
  )
  LANGUAGE SQL
  SPECIFIC P_ASSERT_FALSE
  DYNAMIC RESULT SETS 0
  MODIFIES SQL DATA
  NOT DETERMINISTIC
  NO EXTERNAL ACTION
  PARAMETER CCSID UNICODE
 P_ASSERT_FALSE: BEGIN
  CALL ASSERT_FALSE(NULL, CONDITION);
 END P_ASSERT_FALSE @

