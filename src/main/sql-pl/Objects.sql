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
 * Creates the necessary objects to run the tests.
 *
 * Version: 2014-04-30 1-Alpha
 * Author: Andres Gomez Casanova (AngocA)
 * Made in COLOMBIA.
 */

-- Table for general reporting
CREATE TABLE EXECUTION_REPORTS (
  DATE TIMESTAMP NOT NULL,
  EXECUTION_ID INT NOT NULL,
  STATUS VARCHAR(32) NOT NULL,
  MESSAGE VARCHAR(128) NOT NULL
  );

COMMENT ON TABLE EXECUTION_REPORTS IS 'Global report of the test executions';

COMMENT ON EXECUTION_REPORTS (
  DATE IS 'Date when the message of the test was generated',
  EXECUTION_ID IS 'Unique ID of the execution',
  STATUS IS 'Status of the test''s execution',
  MESSAGE IS 'Descriptive message of the execution'
  );

