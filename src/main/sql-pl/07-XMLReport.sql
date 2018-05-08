--#SET TERMINATOR @

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

SET CURRENT SCHEMA DB2UNIT_2_BETA @

/**
 * XML report to integrate with tools like Hudson. The XML format is the same
 * as jUnit.
 *
 * Version: 2014-12-29 V2_BETA
 * Author: Andres Gomez Casanova (AngocA)
 * Made in COLOMBIA.
 */

/**
 * Refills the temporal table with the results of all tests. This table is
 * used for the XML report.
 */
ALTER MODULE DB2UNIT ADD
  PROCEDURE REFILL_REPORT_TESTS_TABLE (
  )
  LANGUAGE SQL
  SPECIFIC P_REFILL_REPORT_TESTS_TABLE
  DYNAMIC RESULT SETS 0
  MODIFIES SQL DATA
  NOT DETERMINISTIC
  NO EXTERNAL ACTION
  PARAMETER CCSID UNICODE
 P_REFILL_REPORT_TESTS_TABLE: BEGIN
  DECLARE LOGGER_ID SMALLINT;
  DECLARE STATEMENT VARCHAR(256);
  DECLARE SUITENAME VARCHAR(128);
  DECLARE AT_END2 BOOLEAN; -- End of the cursor.
  DECLARE SUITES_CURSOR CURSOR FOR
    SELECT SUITE_NAME
    FROM SUITES S JOIN SYSCAT.TABLES T
    ON (S.SUITE_NAME = T.TABSCHEMA)
    WHERE T.TABNAME = 'REPORT_TESTS';
  DECLARE CONTINUE HANDLER FOR NOT FOUND
    SET AT_END2 = TRUE;

  CALL LOGGER.GET_LOGGER('DB2UNIT_2_BETA.DB2UNIT.REFILL_REPORT_TESTS_TABLE',
    LOGGER_ID);

    -- Deletes current temporal table
  DELETE FROM TEMP_REPORT_TEST_XML;
  CALL LOGGER.INFO(LOGGER_ID, 'Refilling');

  -- Scans the names of the registered suites.
  OPEN SUITES_CURSOR;
  SET AT_END2 = FALSE;
  FETCH SUITES_CURSOR INTO SUITENAME;
  WHILE (AT_END2 = FALSE) DO
   CALL LOGGER.DEBUG(LOGGER_ID, 'Suite ' || SUITENAME);
   -- For each name, copies the results into the temporal table.
   BEGIN
    DECLARE AT_END BOOLEAN; -- End of the cursor.
    DECLARE DAT ANCHOR REPORT_TESTS.DATE;
    DECLARE SUITENAM ANCHOR REPORT_TESTS.SUITE_NAME;
    DECLARE EXEC_ID ANCHOR REPORT_TESTS.EXECUTION_ID;
    DECLARE TESTNAME ANCHOR REPORT_TESTS.TEST_NAME;
    DECLARE FINALSTATE ANCHOR REPORT_TESTS.FINAL_STATE;
    DECLARE TIM ANCHOR REPORT_TESTS.TIME;
    DECLARE MESS ANCHOR REPORT_TESTS.MESSAGE;
    DECLARE REPORT_CURSOR CURSOR
      FOR REPORT_TS;
    DECLARE CONTINUE HANDLER FOR NOT FOUND
      SET AT_END = TRUE;
    SET STATEMENT = 'SELECT DATE, SUITE_NAME, EXECUTION_ID, TEST_NAME,
      FINAL_STATE, TIME, MESSAGE FROM ' || SUITENAME || '.REPORT_TESTS';
    PREPARE REPORT_TS FROM STATEMENT;
    OPEN REPORT_CURSOR;
    SET AT_END = FALSE;
    FETCH REPORT_CURSOR INTO DAT, SUITENAM, EXEC_ID, TESTNAME,
      FINALSTATE, TIM, MESS;
    WHILE (AT_END = FALSE) DO
     INSERT INTO TEMP_REPORT_TEST_XML (DATE, SUITE_NAME, EXECUTION_ID,
       TEST_NAME, FINAL_STATE, TIME, MESSAGE) VALUES (DAT, SUITENAM, EXEC_ID,
       TESTNAME, FINALSTATE, TIM, MESS);
     FETCH REPORT_CURSOR INTO DAT, SUITENAM, EXEC_ID, TESTNAME,
       FINALSTATE, TIM, MESS;
    END WHILE;
   END;
   FETCH SUITES_CURSOR INTO SUITENAME;
  CALL LOGGER.DEBUG(LOGGER_ID, 'next suite');
  END WHILE;

 END P_REFILL_REPORT_TESTS_TABLE @

 /**
  * Creates a XML report of the execution of the tests in the temporal table
  * XML_REPORT.
  *
  * IN SCHEMA_NAME
  *   Name of the schema to retrieve the XML.
  */
ALTER MODULE DB2UNIT ADD
  PROCEDURE XML_REPORT_ONE (
  IN SCHEMANAME ANCHOR SYSCAT.SCHEMATA.SCHEMANAME
  )
  LANGUAGE SQL
  SPECIFIC P_XML_REPORT_ONE
  DYNAMIC RESULT SETS 0
  MODIFIES SQL DATA
  NOT DETERMINISTIC
  NO EXTERNAL ACTION
  PARAMETER CCSID UNICODE
 P_XML_REPORT_ONE: BEGIN

  DECLARE DOC XML;
  DECLARE SENTENCE VARCHAR(256);
  DECLARE STMT STATEMENT;

  SET SENTENCE = 'SET CURRENT SCHEMA ' || UTILITY_SCHEMA;
  PREPARE STMT FROM SENTENCE;
  EXECUTE STMT;

  BEGIN
   DECLARE EXEC_CURSOR CURSOR FOR
     WITH

     -- Error messages and type of error.
     ERRORS (SUITE_NAME, EXECUTION_ID, TEST_NAME, ERROR_MESSAGE, ERROR_TYPE) AS
     (SELECT
       SUITE_NAME, EXECUTION_ID, TEST_NAME,
       SUBSTR(MESSAGE, 44),
       SUBSTR(MESSAGE, 15, 28)
      FROM TEMP_REPORT_TEST_XML
      WHERE FINAL_STATE IS NULL
      AND TEST_NAME IN (
       SELECT
        TEST_NAME
       FROM TEMP_REPORT_TEST_XML
       WHERE FINAL_STATE = 'Error'
      )
      AND MESSAGE IS NOT NULL AND MESSAGE <> ''
     ),

     -- Date and name of the failed tests.
     FAIL_INFO (SUITE_NAME, EXECUTION_ID, TEST_NAME, DATE) AS
     (SELECT
       SUITE_NAME, EXECUTION_ID, TEST_NAME, DATE
      FROM TEMP_REPORT_TEST_XML
      WHERE FINAL_STATE = 'Failed'
     ),

     -- Ordered messages from failed tests.
     FAIL_ROWS (SUITE_NAME, EXECUTION_ID, TEST_NAME, MESSAGE, RANK) AS
     (SELECT
       R.SUITE_NAME, R.EXECUTION_ID, R.TEST_NAME, MESSAGE,
       ROW_NUMBER() OVER(PARTITION BY R.TEST_NAME)
      FROM TEMP_REPORT_TEST_XML R JOIN FAIL_INFO I
      ON (R.SUITE_NAME = I.SUITE_NAME AND R.EXECUTION_ID = I.EXECUTION_ID
       AND R.TEST_NAME = I.TEST_NAME)
      WHERE FINAL_STATE IS NULL
      AND MESSAGE IS NOT NULL AND MESSAGE <> ''
     ),

     -- Type of failed tests.
     FAIL_TYPE (SUITE_NAME, EXECUTION_ID, TEST_NAME, FAIL_TYPE) AS
     (SELECT
       SUITE_NAME, EXECUTION_ID, TEST_NAME, MESSAGE
      FROM FAIL_ROWS
      WHERE RANK = 1
     ),

     -- Messages of failed tests.
     FAIL_MESSAGE (SUITE_NAME, EXECUTION_ID, TEST_NAME, FAIL_MESSAGE) AS
     (SELECT
       SUITE_NAME, EXECUTION_ID, TEST_NAME,
       LISTAGG(MESSAGE, '\n')
      FROM FAIL_ROWS
      WHERE RANK <> 1
      GROUP BY SUITE_NAME, EXECUTION_ID, TEST_NAME
     ),

     -- Complete description of test cases.
     TESTCASE (SUITE_NAME, EXECUTION_ID, TEST_NAME, XML) AS
     (SELECT
       SUITE_NAME, EXECUTION_ID, TEST_NAME,
       XMLELEMENT(NAME "testcase",
        XMLATTRIBUTES(
         TEST_NAME AS "name",
         '0' AS "assertions", -- TODO
         SUITE_NAME || '.' || TEST_NAME AS "classname",
         DURATION/1000 AS "time" -- Milliseconds
        ),
        CASE
         WHEN FINAL_STATE = 'Unstarted'
          THEN XMLELEMENT(NAME "skipped")
         WHEN FINAL_STATE = 'Error'
          THEN XMLELEMENT(
           NAME "error",
           XMLATTRIBUTES(
            (
             SELECT
              MIN(ERROR_MESSAGE)
             FROM ERRORS E JOIN RESULT_TESTS R
             ON (E.SUITE_NAME = R.SUITE_NAME AND E.EXECUTION_ID = R.EXECUTION_ID
             AND E.TEST_NAME = R.TEST_NAME)
            ) AS "message",
            'SQLError' AS "type"
-- TODO Fix the following lines
--            (
--             SELECT
--              MIN(ERROR_TYPE)
--             FROM ERRORS E JOIN RESULT_TESTS R
--             ON (E.SUITE_NAME = R.SUITE_NAME AND E.EXECUTION_ID = R.EXECUTION_ID
--             AND E.TEST_NAME = R.TEST_NAME)
--            ) AS "type"
           )
          )
         WHEN FINAL_STATE = 'Failed'
          THEN XMLELEMENT(
           NAME "failure",
           XMLATTRIBUTES(
            (
             SELECT
              MIN(FAIL_MESSAGE)
             FROM FAIL_MESSAGE F JOIN RESULT_TESTS R
             ON (F.SUITE_NAME = R.SUITE_NAME AND F.EXECUTION_ID = R.EXECUTION_ID
             AND F.TEST_NAME = R.TEST_NAME)
            ) AS "message",
            'AssertionError' AS "type"
--            TODO Fix the following lines
--            (
--             SELECT
--              MIN(FAIL_TYPE)
--             FROM FAIL_TYPE F JOIN RESULT_TESTS R
--             ON (F.SUITE_NAME = R.SUITE_NAME AND F.EXECUTION_ID = R.EXECUTION_ID
--             AND F.TEST_NAME = R.TEST_NAME)
--            ) AS "type"
           )
          )
        END,
        (
         SELECT
          XMLELEMENT(NAME "system-out",
           XMLAGG(
             XMLTEXT(MESSAGE || '\n')
           )
          )
         FROM TEMP_REPORT_TEST_XML R2
         WHERE R2.SUITE_NAME = R.SUITE_NAME
         AND R2.EXECUTION_ID = R.EXECUTION_ID
         AND R2.TEST_NAME = R.TEST_NAME
        )
       ) XML
      -- The schema changes for each test suite. -- TODO ???
      FROM RESULT_TESTS R
     ),

     -- Execution properties.
     PROPERTIES (SUITE_NAME, PROPERTIES) AS
     (SELECT
       SUITE_NAME,
       PROPERTIES -- TODO the XML schema for properties has not been defined.
      FROM SUITES
     ),

     -- Most recent execution date of each test suite.
     RECENT_DATE_EXEC (SUITE_NAME, DATE) AS
     (SELECT
       SUITE_NAME, MAX(DATE)
      FROM SUITES_EXECUTIONS SE JOIN EXECUTIONS E
      ON (E.EXECUTION_ID = SE.EXECUTION_ID)
      GROUP BY SE.SUITE_NAME
     ),

     -- Complete information of the most recent exeuction of each test suite.
     RECENT_EXEC (SUITE_NAME, EXECUTION_ID, DATE, TOTAL_TESTS, PASSED_TESTS,
       FAILED_TESTS, ERROR_TESTS, UNEXEC_TESTS, DURATION) AS
     (SELECT
       SE.SUITE_NAME, SE.EXECUTION_ID, R.DATE, TOTAL_TESTS, PASSED_TESTS,
       FAILED_TESTS, ERROR_TESTS, UNEXEC_TESTS, DURATION
      FROM SUITES_EXECUTIONS SE JOIN EXECUTIONS E
      ON (E.EXECUTION_ID = SE.EXECUTION_ID) JOIN RECENT_DATE_EXEC R
      ON (R.SUITE_NAME = SE.SUITE_NAME AND R.DATE = E.DATE)
     )

     SELECT
-- TODO the following column goes or not?
     -- SUITE_NAME,
      XMLELEMENT(
       NAME "testsuite",
       XMLATTRIBUTES(
        SUITE_NAME AS "name",
        TOTAL_TESTS AS "tests",
        UNEXEC_TESTS AS "disabled",
        ERROR_TESTS  AS "errors",
        FAILED_TESTS AS "failures",
        'localhost' AS "hostname", -- TODO get hostname
        '0' AS "id", -- TODO consecutive ID
        DURATION AS "time",
        DATE AS "timestamp"),
       XMLELEMENT(
        NAME "properties"
        ,
        (
         SELECT
          XMLQUERY('$PROPERTIES')
         FROM PROPERTIES P
         WHERE P.SUITE_NAME = R.SUITE_NAME
        )
        OPTION NULL ON NULL
       ),
       (
        SELECT
         XMLAGG(XMLQUERY('$XML'))
        FROM TESTCASE T 
        WHERE T.SUITE_NAME = R.SUITE_NAME
       )
      )
     FROM RECENT_EXEC R
     WHERE SUITE_NAME = SCHEMANAME
     GROUP BY SUITE_NAME, TOTAL_TESTS, UNEXEC_TESTS, ERROR_TESTS, FAILED_TESTS,
      DURATION, DATE;
   DELETE FROM XML_REPORT;
   OPEN EXEC_CURSOR;
   FETCH EXEC_CURSOR INTO DOC;
   INSERT INTO XML_REPORT (DOCUMENT)
     VALUES (XMLSERIALIZE(DOC AS VARCHAR(32672)));
  END;

 END P_XML_REPORT_ONE @

