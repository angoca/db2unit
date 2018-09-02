---
title: Release process
summary: Description of the software release process
authors: Andres Gomez
date: 2018-09-02
---

Copyright (C)  2014  Andres Gomez Casanova (@AngocA) <angocaATyahooDOTcom>.
Permission is granted to copy, distribute and/or modify this document
under the terms of the GNU Free Documentation License, Version 1.3
or any later version published by the Free Software Foundation;
with no Invariant Sections, no Front-Cover Texts, and no Back-Cover Texts.
A copy of the license is included in the section entitled "GNU
Free Documentation License"


This is the procedure to do for each release.

There are three sections:

* BEFORE: To prepare the release.
* PERFORM: Tasks that conform the release.
* AFTER: Once the release has been done, some extra tasks to prepare the env.

BEFORE

* Run all tests to make sure there are not regressions.
* Change the version constant in the code (07-Version.sql:VERSION):
https://github.com/angoca/db2unit/blob/master/src/main/sql-pl/07-Version.sql
* Write the changes in the ChangeLog section of the wiki.
* Update the Prerequisites table from the Install section of the wiki.
* Change the version in the documentation (Version:) of all source files.
* Make sure the schema reflects the version number to release (all files.)
* Execute examples.
* Read the code again.
* Review the wiki (all pages).
* Perform last commit and push.

PERFORM

* Execute mvn release:prepare providing a valid TAG (1-Beta, 1) and a SNAPSHOT
  for the next release
* Once finished, execute mvn release:perform.
  (If problems, mvn release:rollback)
* Fill the code release in GitHub (https://github.com/angoca/db2unit/releases)
* Change the link in the sidebar of the wiki in GitHub.
* Change the link in the README.txt.
* Execute mvn.
* Publish the generated files in GitHub Releases.
* Fill the ChangeLog page in the wiki with all changes. To review the changes
  compare the tag (git diff previous-tag current-tag)
* Change the Install section of the Wiki indicating the dependencies:
  https://github.com/angoca/db2unit/wiki/Install

AFTER

* Change the schema name to the new version in all files.
* Check that there are not references to the previous release.
* To change the version constant in the code (07-Version.sql:VERSION):
https://github.com/angoca/db2unit/blob/master/src/main/sql-pl/07-Version.sql
* Commit these changes and publish.
