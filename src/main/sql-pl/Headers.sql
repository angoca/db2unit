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

SET CURRENT SCHEMA DB2UNIT_1A ;

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

-- Execute the test.
ALTER MODULE DB2UNIT PUBLISH
  PROCEDURE EXECUTE_TESTS (
  IN SCHEMA_NAME ANCHOR SYSCAT.TABLES.TABSCHEMA
  );

-- Assert two strings
ALTER MODULE DB2UNIT PUBLISH
  PROCEDURE ASSERT (
  IN EXPECTED_MSG VARCHAR(512),
  IN ACTUAL_MSG VARCHAR(512)
  );

