--#SET TERMINATOR ;

/*
 This file is part of db2unit: A unit testing framework for DB2 LUW.
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

SET CURRENT SCHEMA DB2UNIT_1;

SET PATH = SYSTEM PATH, CURRENT USER;

/**
 * Creates the necessary objects to run the tests.
 *
 * Version: 2014-04-30 1
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
  EXECUTION_ID IS 'Execution ID'
  );

-- Table for suites
CREATE TABLE SUITES (
  SUITE_NAME VARCHAR(128) NOT NULL,
  METADATA XML
  );

ALTER TABLE SUITES ADD CONSTRAINT DB2UNIT_SUITES_PK PRIMARY KEY
  (SUITE_NAME);

COMMENT ON TABLE SUITES IS 'Executed suites';

COMMENT ON SUITES (
  SUITE_NAME IS 'Name of the suite',
  METADATA IS 'Description of the tests'
  );

-- Table for general reporting.
CREATE TABLE EXECUTION_REPORTS (
  DATE TIMESTAMP NOT NULL,
  EXECUTION_ID INT NOT NULL,
  STATUS VARCHAR(32) NOT NULL,
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
  EXECUTION_ID INT NOT NULL
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
  EXECUTION_ID IS 'Unique ID of the execution'
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

-- Table for reports (only for model in create like.)
CREATE TABLE REPORT_TESTS (
  DATE TIMESTAMP NOT NULL,
  SUITE_NAME VARCHAR(128) NOT NULL,
  EXECUTION_ID INT NOT NULL,
  TEST_NAME VARCHAR(128),
  FINAL_STATE CHAR(8),
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
  EXECUTION_ID IS 'Unique ID of the execution',
  TEST_NAME IS 'Name of test being executed',
  MESSAGE IS 'Descriptive message about the currently executed test'
  );

-- Table for max values (only for anchoring.)
CREATE TABLE MAX_VALUES (
  MESSAGE_ASSERT VARCHAR(256),
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
  (1, ' db2unit: A unit testing framework for DB2 LUW.'),
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

