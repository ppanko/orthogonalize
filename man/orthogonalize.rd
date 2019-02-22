\name{orthogonalize}
\alias{orthogonalize}
\title{
 Residualize covariates. 
}
\description{
 Provides functionality to create residual "orthogonal" scores via linear 
 regression more quickly and conveniently than \code{lm}. 
}
\usage{
orthogonalize(formula, data, intercept = FALSE, group = NULL)
}
\arguments{
  \item{formula}{
    a \code{"character"} vector or an object of class \code{"formula"} specifying the `response`
	variable to be residualized and a set of `terms` to residualize the
	`response` on, using linear regression. 
  }
  \item{data}{
	a \code{"data.frame"} object containing the data set.  
  }
  \item{intercept}{
	a \code{"logical"} value indicating whether or not to 
	add the intercept term estimated by the regression model to the
	extracted residuals in the return object. Defaults to FALSE.
  }
  \item{group}{
	an optional \code{"numeric"} or \code{"factor"} vector that
	specifies subsets of the data for within-group residualization. Can
	also be a "character" value specifying the column name of the
	grouping variable if it is attached to the \code{"data.frame"}
	provided to the \code{data} argument. Defaults to NULL.  
  }
}
\details{
	This function is based on symbolic model
  representation via a formula, just like \code{lm}. The
  formula accepts a single `response` separated by a \code{"~"} from a set of `terms`, which are
  themselves separated by a \code{+}. The formula is evaluated and the
  relevant data are provided to a OLS estimator where the `response`
  is regressed on the `terms`. The residuals of the `response` are 
  retained and returned by the function; the returned residuals of the
  `response` variable can be said to be "orthogonalized" in respect to the `terms`. 
  If \code{group} is provided, the within-group `response` residuals
  are returned. 
}
\value{
  a numeric vector of the same length as the provided \code{data}. 
}
\author{
  Pavel Panko
}
\examples{
## Load the data:
data(iris)

## Orthogonalize "Petal.Width":
Petal.Width.Prime <- orthogonalize(
	formula   = "Petal.Width ~ Petal.Length + Sepal.Length", 
	data      = iris, 
	intercept = TRUE
)

## Orthgonalize "Petal.Width" within "Species:
Petal.Width.Prime <- orthogonalize(
	formula = "Petal.Width ~ .", 
	data    = iris, 
	group   = "Species" 
)
}
