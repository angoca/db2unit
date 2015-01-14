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

SET CURRENT SCHEMA DB2UNIT_EXAMPLE_FAIL @

SET PATH = "SYSIBM","SYSFUN","SYSPROC","SYSIBMADM", DB2UNIT_2_BETA, DB2UNIT_EXAMPLE_FAIL @

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
  SIGNAL SQLSTATE 'TESTA' SET MESSAGE_TEXT = 'Fail in setup';
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

