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
 * Documentation: FreeBSD Documentation license.

These are some useful links:

 * The source code and project is hosted in GitHub at:
    https://github.com/angoca/db2unit
 * The Wiki is at:
    https://github.com/angoca/db2unit/wiki
 * The released versions are published at:
    https://github.com/angoca/db2unit/releases
 * The issue tracked for bugs and comments is at:
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

    tar -zxvf db2unit.tar.gz
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

### 1. Write the code ###

This could be the structure of your routine's code (Procedure or function).

    CREATE ... HELLO_WORLD ()
     MODIFIES SQL

Check the _Usage_ section for more information about the levels, how to access
the messages and configure the utility.
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

The * in the install-related files means that several files for each one of
them can be found:

 * `.bat` -- Windows Batch file for CMD.exe
 * `.ps1` -- Windows PowerShell
 * `.sql` -- For DB2 CLPPlus.
 * No extension -- For Linux/UNIX/Mac OS X.

