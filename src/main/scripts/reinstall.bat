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

:: Reinstall the utility. Calls the uninstall script and then the install one.
::
:: Version: 2014-04-30 1-Alpha
:: Author: Andres Gomez Casanova (AngocA)
:: Made in COLOMBIA.

if EXIST init.bat (
 call init.bat
)

call %SRC_MAIN_SCRIPT_PATH%\uninstall.bat
call %SRC_MAIN_SCRIPT_PATH%\install.bat

