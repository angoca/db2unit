# Environment

To develop db2unit you need:

 * Db2 server installed. Any edition, and a supported version.
 * Access to GitHub to pull and push the changes.
 * Maven to perform the different stages of the software lifecycle.
   * Compile code and tests.
   * Run tests.
   * Create the package.
   * Publish site.
 * Java SDK for Maven.

# Development

The code is divided in two parts, the main code that produces the released
version and the tests that checks the code works correctly.

## Main

The code here produces the delivrable code.

## Test

The code under this directory has everything to test the main code.

# Examples

There is an examples directories that contains scripts with many possible
situations for tests.

* Tests_DB2UNIT_EXAMPLE.sql

This is a complete file, with setup and tear down and a set of different
possibilities for tests.

db2 "CALL DB2UNIT.RUN_SUITE('DB2UNIT_EXAMPLE')"

* Tests_DB2UNIT_EXAMPLE_FAIL.sql

Fails before each test because of the setup.

db2 "CALL DB2UNIT.RUN_SUITE('DB2UNIT_EXAMPLE_FAIL')"

* Tests_DB2UNIT_EXAMPLE_FAIL_ALL.sql

Fails the suite at the beginning.

db2 "CALL DB2UNIT.RUN_SUITE('DB2UNIT_EXAMPLE_FAIL_ALL')"

# How to develop

## Maven

With Maven, in the root directory

  mvn clean
  mvn validate
  mvn create
  mvn compile
  mvn test-compile
  mvn test
  mvn
  mvn site
  mvn site-deploy

You can catalog a remote node as db2unit, and then create the database in another instance.

 db2 catalog tcpip node docker remote ServerName server PortNumer

## Scripts

### Main

init
Establishes the environment to run the installer.
It is overrided by init-dev when running the installer for tests.

install
Executes the installation scripts
To execute, an connection has to be already established to the database.
-A does NOT create the administrative objects, like bufferpool and tablespaces (01-ObjectsAdmin.sql)
If the global variable DEVELOPMENT is set, then the execution is verbose with Db2 commands.
The execution is with the dot command (source):

  . ./install

reinstall
Executes the uninstall followed by the install scripts.

tap_report
Executes the TAP report of the last execution of a Tests Suite.

uninit
Unsets the variables set by the init command.

uninstall
Uninstalls db2unit from the currently connected database.

### Tests

#### scripts

These are a set of script to develop db2unit, without recreating the database.

allTests
Processes all tests suite when developing.
Options are:
-np : Do not install the tests, just execute them without pauses. They should have been already installed.Shows the enlapsed time.
-ix : Install and execute the tests. Shows the enlapsed time.
-i : Just install the tests. Do not execute them.
Wihtout options: Install and execute the tests with pauses between them.

init-dev
Establishes the environment to run the installer when developing.
It overrides init when running the installer for tests.

test
Executes a single given test. The parameter is the name of the tests suite.
The parameters could be:
i : to install the test.
x : to execute the test.
An example is:
. ./test mySuite i x
This install and executes the mySuite tests suite.

#### Maven

These are a set of scripts used for Maven.

compile
Sets the init-dev environment and then perform the installation.
It connects to a database called db2unit; it should be created before execution, and
for this, the create script could be used.
It uses the DEVELOPMENT flag to do a verbose execution of the install.

create
First, it attaches to a node called db2unit.
If it does not exist, then the local node will be used.
A SQL1097N will appear.
If remote instance is used, then AUTHENTICATION should be in CLIENT mode.
And the current user should exist in the remote node with the appropiate grants.
It kills all applications (careful where you uses this script.)
It drops a previous db2unit database, and recreates it.
If there is a db2unit entry in the database directory, it should be removed by
uncatalogging or dropping the corresponding database.
Finally, it install the prerequirement log4db2. The installer (log4db2.tar.gz) should be at /tmp directory.

test
Runs all tests already compiled in the database (allTests script).
Finally, it creates a report of the executed tests.

test-compile
Compiles all tests in the database (allTests script).

validate
Validates if the current environment is correctly configured to execute db2unit.
It attaches to a node called db2unit.
If it does not exist, then the local node will be used.
A SQL1097N will appear.
If remote instance is used, then AUTHENTICATION should be in CLIENT mode.
And the current user should exist in the remote node with the appropiate grants.

