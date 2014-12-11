--#SET TERMINATOR @

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

SET CURRENT SCHEMA DB2UNIT_EXAMPLE @

SET PATH = "SYSIBM","SYSFUN","SYSPROC","SYSIBMADM", DB2UNIT_2_BETA, DB2UNIT_EXAMPLE @

/**
 * Set of test examples.
 *
 * Version: 2014-05-01 2_BETA
 * Author: Andres Gomez Casanova (AngocA)
 * Made in COLOMBIA.
 */

-- Before all tests.
CREATE OR REPLACE PROCEDURE ONE_TIME_SETUP()
 BEGIN
  -- Nothing.
 END @

-- Before each test.
CREATE OR REPLACE PROCEDURE SETUP()
 BEGIN
  -- Nothing.
 END @

-- After each test.
CREATE OR REPLACE PROCEDURE TEAR_DOWN()
 BEGIN
  -- Nothing.
 END @

-- After all tests.
CREATE OR REPLACE PROCEDURE ONE_TIME_TEAR_DOWN()
 BEGIN
  -- Nothing.
 END @

-- Test that passes correctly - Nothing.
CREATE OR REPLACE PROCEDURE TEST_1()
 BEGIN
  -- Nothing.
 END @

-- Test that rises a signal without text - Message.
CREATE OR REPLACE PROCEDURE TEST_2()
 BEGIN
  SIGNAL SQLSTATE '12345';
 END @

-- Test that rises a signal with text - Message.
CREATE OR REPLACE PROCEDURE TEST_3()
 BEGIN
  SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'Test signal';
 END @

-- Test that asserts true with strings - Nothing.
CREATE OR REPLACE PROCEDURE TEST_4()
 BEGIN
  CALL DB2UNIT.ASSERT_STRING_EQUALS('A', 'A');
 END @

-- Test that asserts false with strings - Message.
CREATE OR REPLACE PROCEDURE TEST_5()
 BEGIN
  CALL DB2UNIT.ASSERT_STRING_EQUALS('A', 'AB');
 END @

-- Test a rollback.
CREATE OR REPLACE PROCEDURE TEST_6()
 BEGIN
  ROLLBACK;
 END @

-- Test a commit.
CREATE OR REPLACE PROCEDURE TEST_7()
 BEGIN
  COMMIT;
 END @

-- Test that asserts false with strings - Message.
CREATE OR REPLACE PROCEDURE TEST_8()
 BEGIN
  CALL DB2UNIT.ASSERT_STRING_EQUALS('Different strings', 'A', 'B');
 END @

