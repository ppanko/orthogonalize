### Title:    orthogonalize: unit tests via `testthat` 
### Author:   Pavel Panko
### Created:  2019-FEB-22
### Modified: 2019-MAR-17

source_url("https://raw.github.com/ppanko/test_suite/master/orthogonalize.R")

initializeEnvironment()
checkUnivariateCatchableErrors()
checkMultivariateCatchableErrors()
checkUnivariateClasses()
checkMultivariateClasses()
checkUnivariateFrontEnd()
checkUnivariateBackEnd()
checkMultivariateFrontEnd()
checkMultivariateBackEnd()
checkUnload()
