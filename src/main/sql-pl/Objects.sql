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
 * Creates the necessary objects to run the tests.
 *
 * Version: 2014-04-30 1-Alpha
 * Author: Andres Gomez Casanova (AngocA)
 * Made in COLOMBIA.
 */

-- Table for general reporting.
CREATE TABLE EXECUTION_REPORTS (
  DATE TIMESTAMP NOT NULL,
  EXECUTION_ID INT NOT NULL,
  STATUS VARCHAR(32) NOT NULL,
  MESSAGE_REPORT VARCHAR(128) NOT NULL
  );

COMMENT ON TABLE EXECUTION_REPORTS IS 'Global report of the test executions';

COMMENT ON EXECUTION_REPORTS (
  DATE IS 'Date when the message of the test was generated',
  EXECUTION_ID IS 'Unique ID of the execution',
  STATUS IS 'Status of the test''s execution',
  MESSAGE_REPORT IS 'Descriptive message of the execution'
  );

-- Table for reports.
CREATE TABLE REPORT_TESTS (
  DATE TIMESTAMP NOT NULL,
  EXECUTION_ID INT NOT NULL,
  TEST_NAME VARCHAR(128) NOT NULL,
  MESSAGE VARCHAR(512) NOT NULL
  );

COMMENT ON TABLE REPORT_TESTS IS 'Model table for reports';

COMMENT ON REPORT_TESTS (
  DATE IS 'Date when the message was generated',
  EXECUTION_ID IS 'Unique ID of the execution',
  TEST_NAME IS 'Name of test being executed',
  MESSAGE IS 'Descriptive message about the currently executed test'
  );

-- Table for max values (only for anchoring.)
CREATE TABLE MAX_VALUES (
  MESSAGE_ASSERT VARCHAR(64),
  SENTENCE VARCHAR(1024)
  );

COMMENT ON TABLE MAX_VALUES IS 'Sizes for anchoring';

COMMENT ON MAX_VALUES (
  MESSAGE_ASSERT IS 'Max length for a message in an assertion (increasable)',
  SENTENCE IS 'Max length for a dynamic sentence (increasable)'
  );

-- Max length for a string message (only for anchoring.)
CREATE TABLE MAX_STRING (
  STRING VARCHAR(32672)
  );

COMMENT ON TABLE MAX_STRING IS 'Sizes for anchoring';

COMMENT ON MAX_STRING (
  STRING IS 'Max length for a string value'
  );

-- Max lenght for a signal message (only for anchoring.)
CREATE TABLE MAX_SIGNAL (
  SIGNAL VARCHAR(32672)
  );

COMMENT ON TABLE MAX_SIGNAL IS 'Sizes for anchoring';

COMMENT ON MAX_SIGNAL (
  SIGNAL IS 'Max length for a signal message'
  );

