# Environment

To develop _db2unit_ you need:

 * Db2 server installed. Any edition, and a currently supported version.
 * Access to GitHub to pull and push the changes.
   * You do not need to push directly into the master repository, but you can create a pull request.
 * (Not mandatory) Maven to perform the different stages of the software lifecycle.
   * Compile code and tests.
   * Run tests.
   * Create the package.
   * Publish site.
 * (Not mandatory) Java SDK for Maven.

# Development

The code is divided in two parts:

* Main: The necessary code to produce the released package.
* Tests: The necessary code to test the main code.

# Directories

## Main (`src/main` directory)

The code here produces the delivrable code.

### Assembly (`src/main/assembly` directory)

This file contains the mechanism to create the release package.

### sql-pl

Code of _db2unit_. This is the main part of this project.

### scripts

Scripts to install and uninstall _db2unit_ in multiple platforms.
Windows with CMD and PowerShell.
Linux and AIX with Bash and Korn.

## Test (`src/test` directory)

The code under this directory has everything to test the main code.

### Maven (`src/test/maven` directory)

Scripts for the differents phases of the lifecycle.
The scripts are fully supported for Linux / AIX in Bash.
There are scripts with some functionality for Windows in CMD.

### scripts

Scripts to develop in _db2unit_, without using Maven (However, Maven invokes them).
These scripts are used to retest each time something is modified in the files.

### sql-pl

Set of tests to test _db2unit_ itself.
Each file tests the assertions for a specific data type independently.
If you are changing something for a specific data type, you can run its corresponding assertions file.
Instead, if you modify something general, the execution file could be run to test the general behavior.

### Travis-CI (`src/test/travis` directory)

Files to be used by Travis-CI.
These are the Db2 response files and a script for Linux Ubuntu update in parallel.

## Examples (`src/examples` directory)

There is an examples directory that contains scripts with many possible
situations for tests.
When a new feature needs to be explained, this is the place to put that.

## Website (`src/site` directory)

This directory contains everything for the website published in https://db2unit.github.io.

## Documentation (`docs` directory)

This directory contains everything you need to know to use or to develop in _db2unit_.

# Examples

There are a couple of examples in _db2unit_, that you could install and execute that helps
you understand how this project works.

* `Tests_DB2UNIT_EXAMPLE.sql`

This is a complete file, with setup and tear down and a set of different
possibilities for tests.

    db2 "CALL DB2UNIT.RUN_SUITE('DB2UNIT_EXAMPLE')"

* `Tests_DB2UNIT_EXAMPLE_FAIL.sql`

Fails before each test because of the setup.

    db2 "CALL DB2UNIT.RUN_SUITE('DB2UNIT_EXAMPLE_FAIL')"

* `Tests_DB2UNIT_EXAMPLE_FAIL_ALL.sql`

Fails the suite at the beginning.

    db2 "CALL DB2UNIT.RUN_SUITE('DB2UNIT_EXAMPLE_FAIL_ALL')"

# How to develop

## Maven

With Maven, in the root directory

    # Cleans the environment.
    mvn clean
    # Verifies if the environment is correctly configured to install db2unit.
    mvn validate
    # Creates the database to install db2unit and its prerequisites.
    # (Linux) It needs log4db2.tar.gz in /tmp to be installed dynamically.
    # (Windows) It needs log4db2 extracted in the Downloads folder.
    mvn create
    # Installs db2unit in the database.
    mvn compile
    # Installs the tests to test db2unit (test itself).
    mvn test-compile
    # Executes the set of Tests Suites to test db2unit. This takes several minutes.
    mvn test

    # Creates the package (zip and tar.gz) to be released.
    mvn
    # Creates the db2unit site.
    mvn site
    # Deploys the db2unit site in GitHub pages.
    mvn site-deploy

If you cannot have a Db2 server in your own machine, and you need to use a remote one, you can catalog a remote node called _db2unit_, and then create the database in another instance.
For this, you need to execute this:

    db2 catalog tcpip node db2unit remote ServerName server PortNumer

Where ServerName is the Name or IP address your remote server and, PortNumber is the port where Db2 is listening.

## Scripts

You can use the set of scripts to recreate/reinstall _db2unit_ and tests all or parts of the code.
The same script with different extensions works for different platforms:

* No extension in Bash for Linux and Mac OS.
Many scripts in Bash requires the `.` command before the name of the script in order to reuse the connection.
* `.bat` in CMD for Windows.
* `.ps1` in PowerShell for Windows.
* `.ksh` in Korn mainly for AIX.
It also needs the `.` command to run many of the commands.

### Main

* `init`:
Establishes the environment to run the installer.
It is overrided by `init-dev` when running the installer for tests.

* `install`:
Executes the installation scripts.
To execute, a connection has to be already established to the database.
It receives the following parameters:
  * `-A` does NOT create the administrative objects, like bufferpool and tablespaces (`01-ObjectsAdmin.sql`).

If the global variable `DEVELOPMENT` is set, then the execution is verbose when running Db2 commands.
The execution is with the dot command (source):

    . ./install

* `reinstall`:
Executes the uninstall followed by the install scripts.

* `tap_report`:
Executes the TAP report of the last execution of a Tests Suite.

* `uninit`:
Unsets the variables set by the init command.

* `uninstall`:
Uninstalls _db2unit_ from the currently connected database.

### Tests

#### scripts

These are a set of scripts to develop _db2unit_, without recreating the database.

* `allTests`:
Processes all tests suite when developing.
Options are:
  * `-np` : Do not install the tests, just execute them without pauses.
They should have been already installed.
Shows the enlapsed time.
  * `-ix` : Install and execute the tests.
Shows the enlapsed time.
  * `-i` : Just install the tests.
Do not execute them.
Wihtout options: Install and execute the tests with pauses between them.

* `init-dev`:
Establishes the environment to run the installer when developing.
It overrides init when running the installer for tests.

* `test`:
Executes a single given test.
The parameter is the name of the tests suite.
The parameters could be:
  * `i` : to install the test.
  * `x` : to execute the test.

An example is:

    . ./test mySuite i x

This installs and executes the `mySuite` tests suite.

In Windows, you do not need the `.` command.

#### Maven

These are a set of scripts used for Maven.

* `compile`:
Sets the `init-dev` environment and then perform the installation.
It connects to a database called `db2unit`.
It should be created before execution, and for this, the create script could be used.
It uses the `DEVELOPMENT` flag to do a verbose execution of the install.

* `create`:
First, it attaches to a node called `db2unit`.
If it does not exist, then the local node will be used and a `SQL1097N` will appear.
If remote instance is used, then `AUTHENTICATION` should be in `CLIENT` mode.
And the current user should exist in the remote node with the appropiate grants.
It kills all applications (be careful where you uses this script.)
It drops a previous `db2unit` database, and recreates it.
If there is a `db2unit` entry in the database directory, it should be removed by uncatalogging or dropping the corresponding database.
Finally, it install the prerequirement _log4db2_.
The installer (`log4db2.tar.gz`) should be at `/tmp` directory.

* `test`:
Runs all tests already compiled in the database (`allTests` script).
Finally, it creates a report of the executed tests.

* `test-compile`:
Compiles all tests in the database (`allTests` script).

* `validate`:
Validates if the current environment is correctly configured to execute _db2unit_.
It attaches to a node called `db2unit`.
If it does not exist, then the local node will be used and a `SQL1097N` will appear.
If remote instance is used, then `AUTHENTICATION` should be in `CLIENT` mode.
And the current user should exist in the remote node with the appropiate grants.


