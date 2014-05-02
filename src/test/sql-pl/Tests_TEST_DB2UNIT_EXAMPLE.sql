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

SET CURRENT SCHEMA TEST_DB2UNIT_EXAMPLE @

SET PATH = "SYSIBM","SYSFUN","SYSPROC","SYSIBMADM", DB2UNIT_1A, TEST_DB2UNIT_EXAMPLE @

/**
 * Set of test examples.
 *
 * Version: 2014-05-01 1-Alpha
 * Author: Andres Gomez Casanova (AngocA)
 * Made in COLOMBIA.
 */

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
  CALL DB2UNIT.ASSERT('A', 'A');
 END @

-- Test that asserts false with strings - Message.
CREATE OR REPLACE PROCEDURE TEST_5()
 BEGIN
  CALL DB2UNIT.ASSERT('A', 'AB');
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

