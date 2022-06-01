--#SET TERMINATOR ;

/*
 This file is part of db2unit: A unit testing framework for Db2 LUW.
 Copyright (C)  2014  Andres Gomez Casanova (@AngocA)

 db2unit is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 db2unit is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.

 Andres Gomez Casanova <angocaATyahooDOTcom>
*/

SET CURRENT SCHEMA DB2UNIT_2_BETA;

SET PATH = SYSTEM PATH, CURRENT USER;

/**
 * Creates the necessary objects to run the tests.
 *
 * Version: 2014-04-30 V2_BETA
 * Author: Andres Gomez Casanova (AngocA)
 * Made in COLOMBIA.
 */

-- Table for execution IDs
CREATE TABLE EXECUTIONS (
  EXECUTION_ID INT NOT NULL,
  DATE TIMESTAMP NOT NULL WITH DEFAULT CURRENT TIMESTAMP
  );

ALTER TABLE EXECUTIONS ADD CONSTRAINT DB2UNIT_EXECUTIONS_PK PRIMARY KEY
  (EXECUTION_ID);

COMMENT ON TABLE EXECUTIONS IS 'List of used execution IDs';

COMMENT ON EXECUTIONS (
  EXECUTION_ID IS 'Execution ID',
  DATE IS 'Date when the execution was performed'
  );

-- Table for suites
CREATE TABLE SUITES (
  SUITE_NAME VARCHAR(128) NOT NULL,
  PROPERTIES XML
  );

ALTER TABLE SUITES ADD CONSTRAINT DB2UNIT_SUITES_PK PRIMARY KEY
  (SUITE_NAME);

COMMENT ON TABLE SUITES IS 'Executed suites';

COMMENT ON SUITES (
  SUITE_NAME IS 'Name of the suite',
  PROPERTIES IS 'Properties of the tests'
  );

-- Table for general reporting.
CREATE TABLE EXECUTION_REPORTS (
  DATE TIMESTAMP NOT NULL,
  EXECUTION_ID INT,
  STATUS VARCHAR(32),
  MESSAGE_REPORT VARCHAR(256) NOT NULL
  );

ALTER TABLE EXECUTION_REPORTS ADD CONSTRAINT DB2UNIT_EXEC_REPS_FK_EXECS
  FOREIGN KEY (EXECUTION_ID) REFERENCES EXECUTIONS (EXECUTION_ID)
  ON DELETE CASCADE;

COMMENT ON TABLE EXECUTION_REPORTS IS 'Global report of the test executions';

COMMENT ON EXECUTION_REPORTS (
  DATE IS 'Date when the message of the test was generated',
  EXECUTION_ID IS 'Unique ID of the execution',
  STATUS IS 'Status of the test''s execution',
  MESSAGE_REPORT IS 'Descriptive message of the execution'
  );

CREATE OR REPLACE PUBLIC ALIAS DB2UNIT_EXECUTION_REPORTS
  FOR TABLE EXECUTION_REPORTS;

COMMENT ON PUBLIC ALIAS DB2UNIT_EXECUTION_REPORTS
  IS 'Reports of the executed suites';

-- Table for locking suites.
CREATE TABLE SUITE_LOCKS (
  NAME VARCHAR(128) NOT NULL
  );

ALTER TABLE SUITE_LOCKS ADD CONSTRAINT DB2UNIT_LOCKS_PK PRIMARY KEY
  (NAME);

ALTER TABLE SUITE_LOCKS ADD CONSTRAINT DB2UNIT_LOCKS_FK_SUITES
  FOREIGN KEY (NAME) REFERENCES SUITES (SUITE_NAME)
  ON DELETE CASCADE;

COMMENT ON TABLE SUITE_LOCKS IS 'Table for test suite locks';

COMMENT ON SUITE_LOCKS (
  NAME IS 'Name of the test suite (schema)'
  );

-- Table suites executions
CREATE TABLE SUITES_EXECUTIONS (
  SUITE_NAME VARCHAR(128) NOT NULL,
  EXECUTION_ID INT NOT NULL,
  TOTAL_TESTS INT,
  PASSED_TESTS INT,
  FAILED_TESTS INT,
  ERROR_TESTS INT,
  UNEXEC_TESTS INT,
  DURATION INT
  );

ALTER TABLE SUITES_EXECUTIONS ADD CONSTRAINT DB2UNIT_SUITES_EXECS_PK PRIMARY KEY
  (SUITE_NAME, EXECUTION_ID);

ALTER TABLE SUITES_EXECUTIONS ADD CONSTRAINT DB2UNIT_SUITES_EXECS_FK_SUITES
  FOREIGN KEY (SUITE_NAME) REFERENCES SUITES (SUITE_NAME)
  ON DELETE CASCADE;

ALTER TABLE SUITES_EXECUTIONS ADD CONSTRAINT DB2UNIT_SUITES_EXECS_FK_EXECS
  FOREIGN KEY (EXECUTION_ID) REFERENCES EXECUTIONS (EXECUTION_ID)
  ON DELETE CASCADE;

COMMENT ON TABLE SUITES_EXECUTIONS IS 'List of executions for any suite';

COMMENT ON SUITES_EXECUTIONS (
  SUITE_NAME IS 'Name of the related suite',
  EXECUTION_ID IS 'Unique ID of the execution',
  TOTAL_TESTS IS 'Quantity of executed tests',
  PASSED_TESTS IS 'Quantity of tests that passed',
  FAILED_TESTS IS 'Quantity of tests that failed',
  ERROR_TESTS IS 'Quantity of tests that hit errors',
  UNEXEC_TESTS IS 'Quantity of unexecuted tests',
  DURATION IS 'Quantity of seconds the test suite lasts'
  );

-- Table for sorts.
CREATE TABLE SORTS (
  SUITE_NAME VARCHAR(128) NOT NULL,
  EXECUTION_ID INT NOT NULL,
  POSITION INT NOT NULL,
  TEST_NAME VARCHAR(128) NOT NULL
  );

ALTER TABLE SORTS ADD CONSTRAINT DB2UNIT_SORTS_PK PRIMARY KEY (SUITE_NAME,
  EXECUTION_ID, POSITION);

ALTER TABLE SORTS ADD CONSTRAINT DB2UNIT_SORTS_FK_SUITES_EXECS
  FOREIGN KEY (SUITE_NAME, EXECUTION_ID)
  REFERENCES SUITES_EXECUTIONS (SUITE_NAME, EXECUTION_ID)
  ON DELETE CASCADE;

COMMENT ON TABLE SORTS IS 'List of sorts for different executions';

COMMENT ON SORTS (
  SUITE_NAME IS 'Name of the related suite',
  EXECUTION_ID IS 'Unique ID of the execution',
  POSITION IS 'Position of the proc in the execution',
  TEST_NAME IS 'Name of the test (stored procedure)'
  );

-- Table for the results of the execution of each test.
CREATE TABLE RESULT_TESTS (
  SUITE_NAME VARCHAR(128) NOT NULL,
  EXECUTION_ID INT NOT NULL,
  TEST_NAME VARCHAR(128) NOT NULL,
  FINAL_STATE CHAR(10) NOT NULL,
  DATE TIMESTAMP,
  DURATION INT
  );

ALTER TABLE RESULT_TESTS ADD CONSTRAINT DB2UNIT_RES_TSTS_PK PRIMARY KEY
  (SUITE_NAME, EXECUTION_ID, TEST_NAME);

ALTER TABLE RESULT_TESTS ADD CONSTRAINT DB2UNIT_RES_TSTS_FK_SUITES_EXECS
  FOREIGN KEY (SUITE_NAME, EXECUTION_ID)
  REFERENCES SUITES_EXECUTIONS (SUITE_NAME, EXECUTION_ID)
  ON DELETE CASCADE;

COMMENT ON TABLE RESULT_TESTS IS 'Results of the execution of each test';

COMMENT ON RESULT_TESTS (
  SUITE_NAME IS 'Name of the related suite',
  EXECUTION_ID IS 'Unique ID of the execution',
  TEST_NAME IS 'Name of the test (stored procedure)',
  FINAL_STATE IS 'Final state of the test',
  DATE IS 'Date when the test was executed',
  DURATION IS 'Quantity of time the execution took (fraction of seconds)'
  );

-- Table for reports (only for model in create like.)
CREATE TABLE REPORT_TESTS (
  DATE TIMESTAMP NOT NULL,
  SUITE_NAME VARCHAR(128) NOT NULL,
  EXECUTION_ID INT NOT NULL,
  TEST_NAME VARCHAR(128),
  FINAL_STATE CHAR(10),
  TIME INT,
  MESSAGE VARCHAR(512) NOT NULL
  );

ALTER TABLE REPORT_TESTS ADD CONSTRAINT DB2UNIT_REP_TEST_FK_EXECS
  FOREIGN KEY (SUITE_NAME, EXECUTION_ID)
  REFERENCES SUITES_EXECUTIONS (SUITE_NAME, EXECUTION_ID)
  ON DELETE CASCADE;

COMMENT ON TABLE REPORT_TESTS IS 'Model table for reports';

COMMENT ON REPORT_TESTS (
  DATE IS 'Date when the message was generated',
  SUITE_NAME IS 'Name of the test suite',
  EXECUTION_ID IS 'Unique ID of the execution',
  TEST_NAME IS 'Name of test being executed',
  FINAL_STATE IS 'Final state of the test',
  TIME IS 'Quantity of time the execution took',
  MESSAGE IS 'Descriptive message about the currently executed test'
  );

-- Table for maximal values (only for anchoring.)
CREATE TABLE MAX_VALUES (
  MESSAGE_ASSERT VARCHAR(256),
  SENTENCE VARCHAR(1024)
  );

COMMENT ON TABLE MAX_VALUES IS 'Sizes for anchoring';

COMMENT ON MAX_VALUES (
  MESSAGE_ASSERT IS 'Max length for a message in an assertion (increasable)',
  SENTENCE IS 'Max length for a dynamic sentence (increasable)'
  );

-- Maximal length for a string message (only for anchoring.)
CREATE TABLE MAX_STRING (
  STRING VARCHAR(32672)
  );

COMMENT ON TABLE MAX_STRING IS 'Sizes for anchoring';

COMMENT ON MAX_STRING (
  STRING IS 'Max length for a string value'
  );

-- Maximal length for a signal message (only for anchoring.)
CREATE TABLE MAX_SIGNAL (
  SIGNAL VARCHAR(32672)
  );

COMMENT ON TABLE MAX_SIGNAL IS 'Sizes for anchoring';

COMMENT ON MAX_SIGNAL (
  SIGNAL IS 'Max length for a signal message'
  );

-- Table for the license.
CREATE TABLE LICENSE (
  NUMBER SMALLINT,
  LINE VARCHAR(80)
  );

COMMENT ON TABLE LICENSE IS 'License of db2unit';

COMMENT ON LICENSE (
  NUMBER IS 'Number of the line',
  LINE IS 'Content of the license'
  );

INSERT INTO LICENSE (NUMBER, LINE) VALUES
  (1, ' db2unit: A unit testing framework for Dn2 LUW.'),
  (2, ' Copyright (C)  2014  Andres Gomez Casanova (@AngocA)'),
  (3, ' '),
  (4, ' db2unit is free software: you can redistribute it and/or modify'),
  (5, ' it under the terms of the GNU General Public License as published by'),
  (6, ' the Free Software Foundation, either version 3 of the License, or'),
  (7, ' (at your option) any later version.'),
  (8, ' '),
  (9, ' db2unit is distributed in the hope that it will be useful,'),
  (10, ' but WITHOUT ANY WARRANTY; without even the implied warranty of'),
  (11, ' MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the'),
  (12, ' GNU General Public License for more details.'),
  (13, ' '),
  (14, ' You should have received a copy of the GNU General Public License'),
  (15, ' along with this program.  If not, see <http://www.gnu.org/licenses/>.'),
  (16, ' '),
  (17, ' Andres Gomez Casanova <angocaATyahooDOTcom>');

-- Table for the TAP report.
CREATE GLOBAL TEMPORARY TABLE TAP_REPORT (
  NUMBER SMALLINT,
  MESSAGE VARCHAR(256)
  ) ON COMMIT PRESERVE ROWS;

COMMENT ON TABLE TAP_REPORT IS 'Temporal table for TAP report';

COMMENT ON TAP_REPORT (
  NUMBER IS 'Line number to generate a sorted putput',
  MESSAGE IS 'Content of the TAP report'
  );

-- Table for messages in assertions called outside a test suite.
CREATE GLOBAL TEMPORARY TABLE TEMP_REPORT_TESTS (
  MESSAGE VARCHAR(512)
  ) ON COMMIT PRESERVE ROWS;

COMMENT ON TABLE TEMP_REPORT_TESTS IS 'Temporal table for assertion''s output outside of a test suite';

COMMENT ON TEMP_REPORT_TESTS (
  MESSAGE IS 'Descriptive message about the executed test'
  );

-- Tables to group all test reports for XML result.
CREATE GLOBAL TEMPORARY TABLE TEMP_REPORT_TEST_XML
  LIKE REPORT_TESTS
  ON COMMIT PRESERVE ROWS;

COMMENT ON TABLE TEMP_REPORT_TEST_XML IS 'Temporal table for XML report';

COMMENT ON TEMP_REPORT_TEST_XML (
  DATE IS 'Date when the message was generated',
  SUITE_NAME IS 'Name of the test suite',
  EXECUTION_ID IS 'Unique ID of the execution',
  TEST_NAME IS 'Name of test being executed',
  FINAL_STATE IS 'Final state of the test',
  TIME IS 'Quantity of time the execution took',
  MESSAGE IS 'Descriptive message about the currently executed test'
  );

-- Temporal table for XML report.
CREATE GLOBAL TEMPORARY TABLE XML_REPORT (
  DOCUMENT VARCHAR(32672)
  ) ON COMMIT PRESERVE ROWS;

COMMENT ON TABLE XML_REPORT IS 'Temporal XML report';

COMMENT ON XML_REPORT (
  DOCUMENT IS 'Content of the XML report'
  );

-- Insert a mock execution for assertion calls outside test suite.
INSERT INTO EXECUTIONS (EXECUTION_ID, DATE) VALUES
  (-1, '1981-03-03');

