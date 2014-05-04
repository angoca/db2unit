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
 * Creates the objects that require high priviles.
 *
 * Version: 2014-04-30 1-Alpha
 * Author: Andres Gomez Casanova (AngocA)
 * Made in COLOMBIA.
 */

-- Buffer pool for max values.
CREATE BUFFERPOOL MAX_VALUES_BP
  PAGESIZE 32K;

-- Tablespace for logger utility.
CREATE TABLESPACE MAX_VALUES_TS
  PAGESIZE 32 K
  BUFFERPOOL MAX_VALUES_BP;

COMMENT ON TABLESPACE MAX_VALUES_TS IS
  'TS just to store an empty table for max values. Could be changed.';

-- Schema for logger tables.
CREATE SCHEMA DB2UNIT_1A;

COMMENT ON SCHEMA DB2UNIT_1A IS 'Schema for db2unit objects';

