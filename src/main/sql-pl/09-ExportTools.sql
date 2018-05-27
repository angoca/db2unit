--#SET TERMINATOR @
ALTER MODULE DB2UNIT DROP
  PROCEDURE EXTRACT_SUITE @
ALTER MODULE DB2UNIT DROP
  PROCEDURE GENERATE_TESTS_PROCEDURE @
ALTER MODULE DB2UNIT DROP
  PROCEDURE GENERATE_TESTS_FUNCTION @
ALTER MODULE DB2UNIT DROP
  PROCEDURE WRITE_TEXT @
ALTER MODULE DB2UNIT DROP
  PROCEDURE WRITE_TEXT2 @
ALTER MODULE DB2UNIT DROP
  VARIABLE UTL_FILE_HANDLER @
ALTER MODULE DB2UNIT PUBLISH
  PROCEDURE EXTRACT_SUITE (
  IN SCHEMA_NAME ANCHOR SYSCAT.SCHEMATA.SCHEMANAME
  ) @

/*
 This file is part of db2unit: A unit testing framework for Db2 LUW.
 Copyright (C)  2018  Andres Gomez Casanova (@AngocA)

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
-- TODO publish or add?
ALTER MODULE DB2UNIT PUBLISH
  VARIABLE UTL_FILE_HANDLER UTL_FILE.FILE_TYPE @

  /**
 * Set of procedures to generate a Tests suite for existent suites or for new
 * tests.
 * It does not create any extra object necessary for the tests, like a table,
 * function, etc.
 *
 * Version: 2018-05-23 V2_BETA
 * Author: Andres Gomez Casanova (AngocA)
 */

ALTER MODULE DB2UNIT ADD
  PROCEDURE WRITE_TEXT (
  IN DIR_ALIAS VARCHAR(128),
  IN FILENAME VARCHAR(255),
--  IN UTL_FILE_HANDLER UTL_FILE.FILE_TYPE,
  IN TEXT ANCHOR SYSCAT.PROCEDURES.TEXT
  )
  LANGUAGE SQL
  SPECIFIC P_WRITE_TEXT
  DYNAMIC RESULT SETS 0
  MODIFIES SQL DATA
  NOT DETERMINISTIC
  NO EXTERNAL ACTION
  PARAMETER CCSID UNICODE
 P_WRITE_TEXT: BEGIN
  DECLARE LENGTH INT;
  DECLARE INIT INT;
  DECLARE IS_OPEN BOOLEAN;
  DECLARE PRE VARCHAR(10000);
  DECLARE POST VARCHAR(10000);
  DECLARE BUF_SIZE INT DEFAULT -1;

--  SET IS_OPEN = UTL_FILE.IS_OPEN(UTL_FILE_HANDLER);
--  IF ( IS_OPEN != TRUE ) THEN
SET UTL_FILE_HANDLER = UTL_FILE.FOPEN(DIR_ALIAS, FILENAME, 'a');
--  END IF;

  SET POST = TEXT;
  SET INIT = 1;
  SET LENGTH = LENGTH(TEXT);
  WHILE (INIT < LENGTH AND BUF_SIZE != 0) DO
   SET BUF_SIZE = POSSTR(POST, u&'\000d');
   IF (BUF_SIZE = 0) THEN
    SET PRE = POST;
   ELSE
    SET PRE = SUBSTR(TEXT, INIT, BUF_SIZE - 1);
   END IF;
   SET POST = SUBSTR(POST, BUF_SIZE + 1);
   CALL UTL_FILE.PUT_LINE(UTL_FILE_HANDLER, PRE);
   CALL UTL_FILE.FFLUSH(UTL_FILE_HANDLER);
   SET INIT = INIT + BUF_SIZE;
  END WHILE;
  CALL UTL_FILE.PUT_LINE(UTL_FILE_HANDLER, ' @');
  CALL UTL_FILE.NEW_LINE(UTL_FILE_HANDLER);
  CALL UTL_FILE.FFLUSH(UTL_FILE_HANDLER);
CALL UTL_FILE.FCLOSE(UTL_FILE_HANDLER);
  END P_WRITE_TEXT @

ALTER MODULE DB2UNIT ADD
  PROCEDURE WRITE_TEXT2 (
  IN DIR_ALIAS VARCHAR(128),
  IN FILENAME VARCHAR(255),
  IN TEXT ANCHOR SYSCAT.PROCEDURES.TEXT
  )
  LANGUAGE SQL
  SPECIFIC P_WRITE_TEXT2
  DYNAMIC RESULT SETS 0
  MODIFIES SQL DATA
  NOT DETERMINISTIC
  NO EXTERNAL ACTION
  PARAMETER CCSID UNICODE
 P_WRITE_TEXT2: BEGIN
  DECLARE LENGTH INT;
  DECLARE INIT INT;
  DECLARE PRE VARCHAR(10000);
  DECLARE BUF_SIZE INT DEFAULT 1000; -- This should be less than maxlinesize.
--  INOUT UTL_FILE_HANDLER UTL_FILE.FILE_TYPE,

  SET INIT = 1;
  SET LENGTH = LENGTH(TEXT);
  SET UTL_FILE_HANDLER = UTL_FILE.FOPEN(DIR_ALIAS, FILENAME, 'a');
  WHILE (INIT < LENGTH) DO
   SET PRE = SUBSTR(TEXT, INIT, BUF_SIZE);

   CALL UTL_FILE.PUT(UTL_FILE_HANDLER, PRE);
   CALL UTL_FILE.FFLUSH(UTL_FILE_HANDLER);
   CALL UTL_FILE.FCLOSE(UTL_FILE_HANDLER);
   SET UTL_FILE_HANDLER = UTL_FILE.FOPEN(DIR_ALIAS, FILENAME, 'a');

   SET INIT = INIT + BUF_SIZE;
  END WHILE;

  CALL UTL_FILE.NEW_LINE(UTL_FILE_HANDLER);
  CALL UTL_FILE.PUT(UTL_FILE_HANDLER, ' @');
CALL DBMS_OUTPUT.PUT_LINE('aqui vamos'); 
  CALL UTL_FILE.NEW_LINE(UTL_FILE_HANDLER);
  CALL UTL_FILE.FFLUSH(UTL_FILE_HANDLER);
  CALL UTL_FILE.FCLOSE(UTL_FILE_HANDLER);
  END P_WRITE_TEXT2 @

/**
 * Generates a file with the existent test procedures for a given schema. The
 * generated file has a name with the same name of the schema with the .sql
 * extension.
 * The generated order of the test does not ensure that it works appropiately.
 * The character terminator is an @. If the generate code contains this
 * chracter, the execution could fail.
 *
 * IN SCHEMA_NAME
 *   Name of the tests suite schema to export.
 */
ALTER MODULE DB2UNIT ADD
  PROCEDURE EXTRACT_SUITE (
  IN SCHEMA_NAME ANCHOR SYSCAT.SCHEMATA.SCHEMANAME
  )
  LANGUAGE SQL
  SPECIFIC P_EXTRACT_SUITE
  DYNAMIC RESULT SETS 0
  MODIFIES SQL DATA
  NOT DETERMINISTIC
  NO EXTERNAL ACTION
  PARAMETER CCSID UNICODE
 P_EXTRACT_SUITE: BEGIN
  DECLARE DIR_ALIAS VARCHAR(128) CONSTANT 'SUITE_FILE';
  DECLARE DIRECTORY VARCHAR(1024);
  DECLARE FILENAME VARCHAR(255);
--  DECLARE UTL_FILE_HANDLER UTL_FILE.FILE_TYPE;
  DECLARE IS_OPEN BOOLEAN;
  DECLARE AT_END BOOLEAN; -- End of the cursor.
  DECLARE TEST_NAME ANCHOR SYSCAT.PROCEDURES.PROCNAME;
  DECLARE TEST_CONTENT ANCHOR SYSCAT.PROCEDURES.TEXT;
  DECLARE TESTS CURSOR FOR
    SELECT PROCNAME, TEXT
    FROM SYSCAT.PROCEDURES
	WHERE PROCSCHEMA = SCHEMA_NAME
	AND PROCNAME LIKE 'TEST_%';
  DECLARE CONTINUE HANDLER FOR NOT FOUND
    SET AT_END = TRUE;

  SET DIRECTORY = '/tmp/tempo';
  SET FILENAME = 'suite_' || SCHEMA_NAME || '.sql';
  SET IS_OPEN = UTL_FILE.IS_OPEN(UTL_FILE_HANDLER);
  IF ( IS_OPEN != TRUE ) THEN
   CALL UTL_DIR.CREATE_OR_REPLACE_DIRECTORY(DIR_ALIAS, DIRECTORY);
   -- Creates or opens the file in writting mode (deletes content).
   -- TODO poner tama;o de maxlinesize de 32672
   SET UTL_FILE_HANDLER = UTL_FILE.FOPEN(DIR_ALIAS, FILENAME, 'w');
  END IF;

  CALL UTL_FILE.PUT_LINE(UTL_FILE_HANDLER, '--#SET TERMINATOR @');
  CALL UTL_FILE.NEW_LINE(UTL_FILE_HANDLER);
  CALL UTL_FILE.PUT_LINE(UTL_FILE_HANDLER,
    'SET CURRENT SCHEMA DB2UNIT_EXECUTION_2 @');
  -- TODO current schema
  CALL UTL_FILE.NEW_LINE(UTL_FILE_HANDLER);
  CALL UTL_FILE.PUT_LINE(UTL_FILE_HANDLER,
    'SET PATH = "SYSIBM","SYSFUN","SYSPROC","SYSIBMADM", DB2UNIT_2_BETA, '
	|| SCHEMA_NAME || ' @');
  CALL UTL_FILE.NEW_LINE(UTL_FILE_HANDLER);
  CALL UTL_FILE.FCLOSE(UTL_FILE_HANDLER);

  SELECT TEXT INTO TEST_CONTENT
    FROM SYSCAT.PROCEDURES
	WHERE PROCSCHEMA = SCHEMA_NAME
	AND PROCNAME = 'ONE_TIME_SETUP';
  CALL WRITE_TEXT2(DIR_ALIAS, FILENAME, TEST_CONTENT);
  SET TEST_CONTENT = NULL;

  SELECT TEXT INTO TEST_CONTENT
    FROM SYSCAT.PROCEDURES
	WHERE PROCSCHEMA = SCHEMA_NAME
	AND PROCNAME = 'SETUP';
  CALL WRITE_TEXT2(DIR_ALIAS, FILENAME, TEST_CONTENT);
  SET TEST_CONTENT = NULL;

  SELECT TEXT INTO TEST_CONTENT
    FROM SYSCAT.PROCEDURES
	WHERE PROCSCHEMA = SCHEMA_NAME
	AND PROCNAME = 'TEAR_DOWN';
  CALL WRITE_TEXT2(DIR_ALIAS, FILENAME, TEST_CONTENT);
  SET TEST_CONTENT = NULL;

  SELECT TEXT INTO TEST_CONTENT
    FROM SYSCAT.PROCEDURES
	WHERE PROCSCHEMA = SCHEMA_NAME
	AND PROCNAME = 'ONE_TIME_TEAR_DOWN';
  CALL WRITE_TEXT2(DIR_ALIAS, FILENAME, TEST_CONTENT);
  SET TEST_CONTENT = NULL;

  SET AT_END = FALSE;
  OPEN TESTS;
  FETCH TESTS INTO TEST_NAME, TEST_CONTENT;
  WHILE (AT_END = FALSE) DO
   SET TEST_NAME = '-- ' || TEST_NAME;

   SET UTL_FILE_HANDLER = UTL_FILE.FOPEN(DIR_ALIAS, FILENAME, 'a');
   CALL UTL_FILE.PUT_LINE(UTL_FILE_HANDLER, TEST_NAME);
   CALL UTL_FILE.NEW_LINE(UTL_FILE_HANDLER);
   CALL UTL_FILE.FCLOSE(UTL_FILE_HANDLER);

   CALL WRITE_TEXT2(DIR_ALIAS, FILENAME, TEST_CONTENT);
   FETCH TESTS INTO TEST_NAME, TEST_CONTENT;
  END WHILE;

  SET UTL_FILE_HANDLER = UTL_FILE.FOPEN(DIR_ALIAS, FILENAME, 'a');
  CALL UTL_FILE.PUT_LINE(UTL_FILE_HANDLER,
    '-- Register the suite.');
  CALL UTL_FILE.PUT_LINE(UTL_FILE_HANDLER,
    'CALL DB2UNIT.REGISTER_SUITE(CURRENT SCHEMA) @');
  CALL UTL_FILE.NEW_LINE(UTL_FILE_HANDLER);
  CALL UTL_FILE.FFLUSH(UTL_FILE_HANDLER);
  CALL UTL_FILE.FCLOSE(UTL_FILE_HANDLER);
 END P_EXTRACT_SUITE @

/**
 * Generates a file with a set of possible tests for the given procedure. The
 * generated file has a name with the same name of the schema with the .sql
 * extension.
 *
 * IN SCHEMA_NAME
 *   Name of the schema where the procedure resides.
 * IN MODULE_NAME
 *   Name of the module where the procedure resides. This could be null if the
 *   procedure is not inside a module.
 * IN PROC_NAME
 *   Name of the procedure to generate the basic tests.
 */
ALTER MODULE DB2UNIT ADD
  PROCEDURE GENERATE_TESTS_PROCEDURE (
  IN SCHEMA_NAME ANCHOR SYSCAT.SCHEMATA.SCHEMANAME,
  IN MODULE_NAME ANCHOR SYSCAT.MODULES.MODULENAME DEFAULT NULL,
  IN PROC_NAME ANCHOR SYSCAT.PROCEDURES.PROCNAME
  )
  LANGUAGE SQL
  SPECIFIC P_GENERATE_TESTS_PROCEDURE
  DYNAMIC RESULT SETS 0
  MODIFIES SQL DATA
  NOT DETERMINISTIC
  NO EXTERNAL ACTION
  PARAMETER CCSID UNICODE
 P_GENERATE_TESTS_PROCEDURE: BEGIN
 -- TODO
 END P_GENERATE_TESTS_PROCEDURE @

 /**
 * Generates a file with a set of possible tests for the given function. The
 * generated file has a name with the same name of the schema with the .sql
 * extension.
 *
 * IN SCHEMA_NAME
 *   Name of the schema where the function resides.
 * IN MODULE_NAME
 *   Name of the module where the funcion resides. This could be null if the
 *   function is not inside a module.
 * IN FUNC_NAME
 *   Name of the function to generate the basic tests.
 */
ALTER MODULE DB2UNIT ADD
  PROCEDURE GENERATE_TESTS_FUNCTION (
  IN SCHEMA_NAME ANCHOR SYSCAT.SCHEMATA.SCHEMANAME,
  IN MODULE_NAME ANCHOR SYSCAT.MODULES.MODULENAME DEFAULT NULL,
  IN FUNC_NAME ANCHOR SYSCAT.FUNCTIONS.FUNCNAME
  )
  LANGUAGE SQL
  SPECIFIC P_GENERATE_TESTS_FUNCTION
  DYNAMIC RESULT SETS 0
  MODIFIES SQL DATA
  NOT DETERMINISTIC
  NO EXTERNAL ACTION
  PARAMETER CCSID UNICODE
 P_GENERATE_TESTS_FUNCTION: BEGIN
 -- TODO
 END P_GENERATE_TESTS_FUNCTION @
