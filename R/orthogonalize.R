### Title:    Orthgonalization function front end 
### Author:   Pavel Panko
### Created:  2018-OCT-16
### Modified: 2018-OCT-16

###
### 1. Heading  
###

orthogonalize <- function(formula, data, group = NULL) {
    mf <- match.call()
    m <- match(c("formula", "data", "group"), names(mf), 0L)
    ##
    mf <- mf[c(1L, m)]
    mf[[1L]] <- quote(stats::model.frame)
    mf <- eval(mf, parent.frame())
    mt <- attr(mf, "terms")
    ##
    y <- model.response(mf, "numeric")
    X <- model.matrix(mt, mf)
    group <- as.integer(group)
    ##
    if(!is.null(group))
        get_group_residuals(X, y, group)
    else
         get_residuals(X, y)
}
