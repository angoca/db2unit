@echo off
:: Copyright (c) 2014-2014 Andres Gomez Casanova (AngocA).
::
:: All rights reserved. This program and the accompanying materials
:: are made available under the terms of the Eclipse Public License v1.0
:: which accompanies this distribution, and is available at
:: http://www.eclipse.org/legal/epl-v10.html -->
::
:: Contributors:
:: Andres Gomez Casanova - initial API and implementation.

:: Initialize the environment values to run the scripts.
::
:: Version: 2014-04-30 1-Alpha
:: Author: Andres Gomez Casanova (AngocA)
:: Made in COLOMBIA.

:: This variable indicates the location of the sources, if it has not
:: defined before.
if "%DB2UNIT_PATH%" EQU "" (
 set DB2UNIT_PATH=%~dp0
)

if "%SRC_MAIN_CODE_PATH%" EQU "" (
 set SRC_MAIN_CODE_PATH=%DB2UNIT_PATH%sql-pl
 set SRC_MAIN_SCRIPT_PATH=%DB2UNIT_PATH%
)

