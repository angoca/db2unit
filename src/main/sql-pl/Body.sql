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
 * Creates the objects of the db2unit code.
 *
 * Version: 2014-04-30 1-Alpha
 * Author: Andres Gomez Casanova (AngocA)
 * Made in COLOMBIA.
 */

ALTER MODULE DB2UNIT ADD
  PROCEDURE EXECUTE_TESTS (
  IN SCHEMA_NAME ANCHOR SYSCAT.TABLES.TABSCHEMA
  )
  LANGUAGE SQL
  SPECIFIC P_EXECUTE_TESTS
  DYNAMIC RESULT SETS 0
  MODIFIES SQL DATA
  NOT DETERMINISTIC
  NO EXTERNAL ACTION
  PARAMETER CCSID UNICODE
 P_EXECUTE_TESTS: BEGIN
 END P_EXECUTE_TESTS @

