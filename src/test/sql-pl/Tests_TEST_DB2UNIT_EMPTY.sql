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

SET CURRENT SCHEMA TEST_DB2UNIT_EMPTY @

SET PATH = "SYSIBM","SYSFUN","SYSPROC","SYSIBMADM", DB2UNIT_1A, TEST_DB2UNIT_EMPTY @

/**
 * Tests for a empty schema.
 *
 * Version: 2014-05-01 1-Alpha
 * Author: Andres Gomez Casanova (AngocA)
 * Made in COLOMBIA.
 */

DROP SCHEMA TEST_DB2UNIT_EMPTY RESTRICT @

CREATE SCHEMA TEST_DB2UNIT_EMPTY @

COMMIT @

