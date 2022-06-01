--#SET TERMINATOR @
ALTER MODULE DB2UNIT drop
  specific PROCEDURE P_GENERATE_TESTS_FUNCTION @
ALTER MODULE DB2UNIT drop
  specific PROCEDURE P_GENERATE_TESTS_PROCEDURE @
ALTER MODULE DB2UNIT drop
  specific function F_GET_ASSERTS_TAIL_PROC_TEST @
ALTER MODULE DB2UNIT drop
  specific function F_GET_PROC_SIGNATURE @
ALTER MODULE DB2UNIT drop
  specific function F_GET_HEADER_PROC_TEST @
alter MODULE DB2UNIT drop
  specific PROCEDURE P_WRITE_TEXT @
ALTER MODULE DB2UNIT drop
  specific PROCEDURE P_EXTRACT_SUITE @
ALTER MODULE DB2UNIT drop
  specific function F_GET_HEADER_PROC_FILE_TEST @
-- Extracts a test suite from the database.
ALTER MODULE DB2UNIT PUBLISH
  PROCEDURE GENERATE_TESTS_PROCEDURE (
  IN SCHEMA_NAME ANCHOR SYSCAT.SCHEMATA.SCHEMANAME,
  IN MODULE_NAME ANCHOR SYSCAT.MODULES.MODULENAME,
  IN PROC_NAME ANCHOR SYSCAT.PROCEDURES.PROCNAME
  ) @