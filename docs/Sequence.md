---
title: Sequence diagram
summary: Description about how the sequence diagram were made
authors: Andres Gomez
date: 2018-09-02
---

This is the "source" of the sequence diagram.
To generate the sequence diagram, put this text in this site:
https://www.websequencediagrams.com/#

```
# db2unit execution

note left of db2unit: status: Initialization

db2unit->catalog: getSchema
activate db2unit
catalog->db2unit: nameSchema

note left of db2unit: status: Prepare report

db2unit->db2unit: createReportTable

note left of db2unit: status: Generate list

db2unit->catalog: getProcedures
catalog->db2unit: listProcedures

note left of db2unit: status: Sort list

db2unit->db2unit: sortProcNames

note over db2unit,suite: Executes suite

note left of db2unit: status: Executing

db2unit->+suite: oneTimeSetup
suite->-db2unit: return

loop execTest

note over db2unit,suite: Execution of all tests

db2unit->+suite: setup
suite->-db2unit: return

db2unit->+suite: test_X
suite->+testedRoutine: execution
testedRoutine->-suite: returnValue
suite->+db2unit: assertValue
db2unit->-suite: return

note right of suite: Exception controlled

suite->-db2unit: return

db2unit->+suite: tearDown
suite->-db2unit: return

end

db2unit->+suite: oneTimeTearDown
suite->-db2unit: return

note left of db2unit: status: Calculating time

note left of db2unit: status: Generating report

db2unit->db2unit :writeReport

note left of db2unit: status: Clean environment
```
