### Title:    orthogonalize: utilities
### Author:   Pavel Panko
### Created:  2019-MAR-17
### Modified: 2019-MAR-17

throwError <- function(type) {
  printMessage <- switch(
    EXPR = type,
    badData =
      'Provide the data as a "data.frame" class',
    badIntercept =
      '"intercept" must be a logical vector with length equal to 1 or the number of response variables',
    badGroup =
      '"group" must be a character vector specifying the name (or set of names) of a grouping variable in the data',
    badGroupType =
      '"group" must be either a "factor", "logical", or "character" column in the data',
    badGroupUnq =
      '"group" must not contain all unique values',
    badFormula =
      "Provide a formula or a list of formulas",
    badFormulaSuTilde =
      "Too many tilde symbols found in the formula",
    badFormulaMvOut =
      'Multivariate formulas are not supported',
    badFormulaNotInDf =
      "Not all variables provided in the formula are in the data",
    badFormulaList =
      "All elements of the formula list must be formulas"
  )
  stop(printMessage, call. = FALSE)
}

is.formula <- function(x) {
  inherits(x, "formula")
}

to.integer <- function(x) {
  as.integer(as.factor(x))
}
