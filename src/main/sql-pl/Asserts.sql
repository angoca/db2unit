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
 * Version: 2014-05-02 1-Alpha
 * Author: Andres Gomez Casanova (AngocA)
 * Made in COLOMBIA.
 */

/**
 * Asserts if the given two strings are the same, in lenght and in content.
 *
 * IN EXPECTED_STRING
 *   Expected string.
 * IN ACTUAL_STRING
 *   Actual string.
 */
ALTER MODULE DB2UNIT ADD
  PROCEDURE ASSERT (
  IN EXPECTED_STRING VARCHAR(512),
  IN ACTUAL_STRING VARCHAR(512)
  )
  LANGUAGE SQL
  SPECIFIC P_ASSERT_STRINGS
  DYNAMIC RESULT SETS 0
  MODIFIES SQL DATA
  NOT DETERMINISTIC
  NO EXTERNAL ACTION
  PARAMETER CCSID UNICODE
 P_ASSERT_STRINGS: BEGIN
  DECLARE SHOW BOOLEAN DEFAULT FALSE;

  IF ((EXPECTED_STRING IS NULL AND ACTUAL_STRING IS NOT NULL)
    OR (EXPECTED_STRING IS NOT NULL AND ACTUAL_STRING IS NULL)) THEN
   CALL WRITE_IN_REPORT ('Nullability difference');
   SET SHOW = TRUE;
  ELSEIF (LENGTH(EXPECTED_STRING) <> LENGTH(ACTUAL_STRING)) THEN
   CALL WRITE_IN_REPORT ('Strings have different length');
   SET SHOW = TRUE;
  ELSEIF (EXPECTED_STRING <> ACTUAL_STRING) THEN
   CALL WRITE_IN_REPORT ('The content of both strings is different');
   SET SHOW = TRUE;
  END IF;

  IF (SHOW = TRUE) THEN
   CALL WRITE_IN_REPORT ('Expected: "' || COALESCE(EXPECTED_STRING, 'NULL')
     || '"');
   CALL WRITE_IN_REPORT ('Actual  : "' || COALESCE(ACTUAL_STRING, 'NULL')
     || '"');
  END IF;
 END P_ASSERT_STRINGS @

