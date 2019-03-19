### Title:    orthogonalize: check & make the terms 
### Author:   Pavel Panko
### Created:  2019-MAR-17
### Modified: 2019-MAR-17

.checkGroup <- function(formula, ...) {
  UseMethod(".checkGroup", formula)
}

.checkGroup.character <- function(group, data) {
  if(group %in% names(data)| group != "") {
    if (!is.factor(data[[group]]) && !is.logical(data[[group]]) && !is.character(data[[group]])) {
      throwError("badGroupType")
    } else if (length(unique(data[[group]])) == nrow(data)) {
      throwError("badGroupUnq")
    }
  }
}

.checkGroup.list <- function(group, data) {
  lapply(group, .checkGroup.character, data)
}

.checkFormula <- function(formula, ...) {
  UseMethod(".checkFormula", formula)
}

.checkFormula.formula <- function(formula, data) {
  ##
  tildeCheck <- grepl("~", formula)
  if (sum(tildeCheck) > 1) {
    throwError("badFormulaSuTilde")
  }
  ##
  formulaTerms <- stats::terms(formula, data = data)
  response     <- attr(formulaTerms, "variables")[[2]]   
  ##
  if (is.call(response)) {
    throwError("badFormulaMvOut")
  }
  ##
  predictors <- attr(formulaTerms, "term.labels")
  varNames   <- as.character(c(response, predictors))
  ##
  if (!all(varNames %in% names(data))) {
    throwError("badFormulaNotInDf")
  }
}

.checkFormula.list <- function(formula, data) {
  lapply(formula, .checkFormula.formula, data)
}

.checkTerms <- function(formula, ...) {
  UseMethod(".checkTerms", formula)
}

.checkTerms.formula <- function(formula, data, intercept, group) {
  ##
  if (length(intercept) != 1) {
    throwError("badIntercept")
  }
  ##
  if (length(group) != 1) {
    throwError("badGroup")
  }
  ##
  .checkGroup(group, data)
  .checkFormula(formula, data)
  NULL
}

.checkTerms.list <- function(formula, data, intercept, group) {
  ##
  if (length(intercept) != length(formula) && length(intercept) != 1) {
    throwError("badIntercept")
  }
  ##
  if (length(group) != length(formula) && length(group) != 1) {
    throwError("badGroup")
  }
  ##
  if (!all(sapply(formula, is.formula))) {
    throwError("badFormulaList")
  }
  ##
  .checkGroup(as.list(group), data)
  .checkFormula(formula, data)
  NULL
}

.makeModel <- function(formula, ...) {
  UseMethod(".makeModel", formula)
}

.makeModel.formula <- function(formula, data, intercept, group) {
  termList <- list()
  ##
  termList[["intercept"]] <- as.integer(intercept)
  termList[["groupVec"]] <- to.integer(data[[group]]) 
  ##
  currentData <- data[setdiff(names(data), group)]
  ##
  mf <- stats::model.frame(formula, currentData)
  mt <- attr(mf, "terms")
  ##
  termList[["names"]] <- names(mf)[1]
  termList[["y"]] <- model.response(mf, "numeric")
  termList[["X"]] <- model.matrix(mt, mf)
  termList
}

.makeModel.list <- function(formula, data, intercept, group) {
  termList <- initializeTerms(formula, data, intercept, group)
  ##
  for(i in seq_along(formula)) {
    ##
    currentData <- data[setdiff(names(data), termList$groupNames[i])]
    ##
    mf <- stats::model.frame(formula[[i]], currentData)
    mt <- attr(mf, "terms")
    ##
    termList[["names"]][[i]] <- names(mf)[1]
    termList[["y"]][[i]] <- model.response(mf, "numeric")
    termList[["X"]][[i]] <- model.matrix(mt, mf)
  }
  termList
}

initializeTerms <- function(formula, data, intercept, group) {
  operations <- length(formula)
  termList   <- list()
  ##
  termList[["y"]] <-
    termList[["X"]] <-
    termList[["names"]] <- vector("list", length = operations)
  ##
  if (length(intercept) == 1) {
    termList[["intercept"]] <- rep(as.integer(intercept), operations)
  } else {
    termList[["intercept"]] <- as.integer(intercept)
  }
  ##
  if (length(group) == 1) {
    groupList <- list(to.integer(data[[group]]))
    termList[["groupVec"]] <- rep(groupList, operations)
    termList[["groupNames"]] <- rep(group, operations)
  } else {
    termList[["groupVec"]] <- lapply(group, function(g) to.integer(data[[g]]))
    termList[["groupNames"]] <- group    
  }
  termList
}
