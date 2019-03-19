### Title:    orthogonalize: main
### Author:   Pavel Panko
### Created:  2019-MAR-17
### Modified: 2019-MAR-17

.orthogonalize <- function(X, ...) {
  UseMethod(".orthogonalize", X)
}

.orthogonalize.matrix <- function(X, y, intercept, groupVec) {
  get_residuals_single(X, y, as.integer(intercept), groupVec)
}

.orthogonalize.list <- function(X, y, intercept, groupVec) {
  get_residuals_multi(X, y, as.integer(intercept), groupVec)
}
orthogonalize <- function(formula, data, intercept = FALSE, group = "", simplify = FALSE) {
  ##
  if (!is.data.frame(data)) {
    throwError("badData")
  }     
  if (!is.formula(formula) && !is.list(formula)) {
    throwError("badFormula")
  }
  if(!is.logical(intercept)) {
    throwError("badIntercept")
  }
  if(!is.character(group)) {
    throwError("badGroup")
  }
  ##
  .checkTerms(formula, data, intercept, group)
  ##
  termList <- .makeModel(
    formula   = formula,
    data      = data,
    intercept = intercept,
    group     = group
  )
  ##
  out      <- .orthogonalize(
    X         = termList$X,
    y         = termList$y,
    intercept = termList$intercept,
    groupVec  = termList$groupVec
  )
  ##
  if(simplify == TRUE) {
    as.vector(out)
  } else {
    colnames(out) <- termList$names
    out
  }
}

