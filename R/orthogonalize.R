### Title:    Orthgonalization function front end 
### Author:   Pavel Panko
### Created:  2018-OCT-16
### Modified: 2018-DEC-07

orthogonalize <- function(formula, data, intercept = FALSE, group = NULL) {
    mf <- match.call()
    m <- match(c("formula", "data", "group", "intercept"), names(mf), 0L)
    ##
    if(class(intercept) != "logical") {
        stop("intercept argument must be TRUE or FALSE")
    }
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
    if(length(group))
        out <- get_group_residuals(X, y, group, as.integer(intercept))
    else
        out <- get_residuals(X, y, as.integer(intercept))
    return(as.vector(out))
}
