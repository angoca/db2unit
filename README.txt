db2unit
=======

db2unit is a testing framework for IBM DB2 in SQL-PL language. It is xUnit
framework, that takes the same design as the well-known jUnit. db2unit could be
considered as a jUnit porting for DB2 SQL-PL.

 * jUnit
    http://junit.org
 * xUnit
    https://en.wikipedia.org/wiki/XUnit

The licenses of this project are:

 * Source code: GNU General Public License v3.0
 * Documentation: GNU Free Documentation License.

These are some useful links:

 * The source code and project is hosted in GitHub at:
    https://github.com/angoca/db2unit
 * The Wiki is at:
    https://github.com/angoca/db2unit/wiki
 * The released versions are published at:
    https://github.com/angoca/db2unit/releases
 * The issue tracker for bugs and comments is at:
    https://github.com/angoca/db2unit/issues

Author:

Andres Gomez Casanova (@AngocA)


------------------
## Installation ##

One variable needs to the specified in order to run the install and example
scripts.

    DB2UNIT_PATH

This variable is initialized via the `init` script.

Before installing the scripts in a database, a connection to it has to be
established. If not, an error will be raised.

**Linux/UNIX/MAC OS**:

Just follow these steps:

    tar -zxf db2unit.tar.gz
    cd db2unit
    . ./install

Make sure to put the dot before the command. This will source the values and
use the current connection.

**Windows Terminal (CMD - db2clp)**:

First, unzip the file db2unit.zip, and then:

    cd db2unit
    install.bat

**Windows PowerShell**:

First, unzip the file db2unit.zip, and then:

    cd db2unit
    .\install.ps1

====

After the install, all statements should have been successful.

A more detailed guide to install the utility can be found in the _Install_
section of the wiki:
https://github.com/angoca/db2unit/wiki/Install

You can also install the utility from the sources and run the examples and
tests:
https://github.com/angoca/db2unit/wiki/Install%20from%20sources


-----------
## Usage ##

### 1. Write the test suite ###

Let's suppose you work on a schema called 'MY_SCHM'. From now on, the schema
name will refer to the name of the test suite. It means, your test suite is
also called 'MY_SCHM'.

Your test suite could have the following fixtures that helps to prepare the
environment:

    -- Test fixtures
    CREATE OR REPLACE PROCEDURE ONE_TIME_SETUP()
     BEGIN
      -- Your code
     END @

    CREATE OR REPLACE PROCEDURE SETUP()
     BEGIN
      -- Your code
     END @

    CREATE OR REPLACE PROCEDURE TEAR_DOWN()
     BEGIN
      -- Your code
     END @

    CREATE OR REPLACE PROCEDURE ONE_TIME_TEAR_DOWN()
     BEGIN
      -- Your code
     END @

You create your tests in the same schema as your fixtures. All of these stored
procedures will be your test suite. The name of our tests should starts by TEST_
and they should not have any argument, like this:

    CREATE OR REPLACE PROCEDURE TEST_my_first_test()
     BEGIN
      -- Your code using the test functions.
      ASSERT_STRING_EQUALS(EXPECTED, ACTUAL);
     END @

In the previous test, you compared two strings. You can use other types of
assertions. Please visit the API section:
 https://github.com/angoca/db2unit/wiki/API

The fixtures and the tests should be created under the same schema, in order to
be part of the same suite.

### 2. Execute your test suite ###

Once you have created your procedures in the database, you can run the test
suite like this:

    CALL DB2UNIT.RUN_SUITE('MY_SCHM')

Once the execution is finished, you will see a report of the execution.

Check the _Usage_ section for more information about the framework.
 https://github.com/angoca/db2unit/wiki/Usage


---------------------------
## FILES AND DIRECTORIES ##

These are the files included in the released version:

 * `COPYING.txt` -- License for the code (GPL license v3.0 - OpenSource).
 * `init*` -- Environment configuration.
 * `install*` -- Installation files.
 * `README.txt` -- This file.
 * `reinstall*` -- Reinstallation files.
 * `uninstall*` -- Uninstallation files.
 * `doc` directory -- Documentation directory.
 * `examples` directory -- Examples ready to run.
 * `sql-pl` directory -- Directory for all objects: DDL, DML, routines
     definition.
   * `Asserts.sql` -- Set of assert procedures to perform tests.
   * `AssertNoMessage.sql` -- Set of assert procedures to perform tests,
    without passing messages to the test.
   * `Body.sql` -- Core of the unit framework.
   * `Clean.sql` -- Removes all db2unit objects. Used when uninstalling.
   * `CleanAdmin.sql` -- Removes admin objects. Used when uninstalling.
   * `Headers.sql` -- Definition of all public routines.
   * `Objects.sql` -- Tables for the reports and for data type anchoring.
   * `ObjectsAdmin.sql` -- Administrative objects like tablespaces,
    bufferpools and schemas to install the framework.
   * `Prereqs.sql` -- Tests the prerequisites to install the framework.

The * in the install-related files means that several files for each one of
them can be found:

 * `.bat` -- Windows Batch file for CMD.exe
 * `.ps1` -- Windows PowerShell
 * `.sql` -- For DB2 CLPPlus.
 * No extension -- For Linux/UNIX/Mac OS X.

