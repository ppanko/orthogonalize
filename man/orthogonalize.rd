\name{orthogonalize}
\alias{orthogonalize}
\title{
  Residualize covariates. 
}
\description{
 Provides functionality to create residual scores for a single outcome or a set
 of outcomes via ordinary least squares (OLS) regression more quickly
 and conveniently than \code{lm}. The `response` vector produced by this
 function is "orthogonal" to the variables the predictor set. 
}
\usage{
orthogonalize(formula, data, intercept = FALSE,
              group = "", simplify = FALSE)
}
\arguments{
  \item{formula}{
    a \code{"formula"} object specifying the model  `response`
    variable to be residualized and a set of `terms` to
    residualize the `response` on, using linear regression.
    Can also be a \code{"list"} specifying several formulas.
  }
  \item{data}{
    a \code{"data.frame"} object containing the data set.  
  }
  \item{intercept}{
    a \code{"logical"} vector indicating whether or not to 
    add the intercept term estimated by the regression model to the
    extracted residuals in the return object. When specifying the
    \code{"formula"} argument as a list, the \code{"intercept"}
    vector can include the same number of elements as the list. 
    Defaults to FALSE.
     
  }
  \item{group}{
    an optional \code{"character"} vector that specifies a grouping
    variable in the data that can be used for within-group
    residualization. When specifying the \code{"formula"} argument
    as a list, the \code{"group"} vector can include the same
    number of elements as the list. Defaults to "", which suggests no grouping
    variable will be used.  
  }
  \item{simplify}{
    a \code{"logical"} value indicating whether or not to
    simplify the \code{"matrix"} result to a \code{"numeric"}
    vector. 
  }
 
}
\details{
  This function is based on symbolic model
  representation via a formula object, just like \code{lm}. The
  formula accepts a single `response` separated by a \code{"~"} from a set of `terms`, which are
  themselves separated by a \code{+}. The formula is evaluated and the
  relevant data are provided to an OLS estimator where the `response`
  is regressed on the `terms`. The residuals of the `response` are 
  retained and returned by the function. 
  If \code{group} is provided, the OLS estimator computes the `response`
  as a set of within-group residuals. 

  When \code{"formula"} is specified as a \code{"list"}, the user
  can either supply a single value to the arguments \code{"intercept"}
  and \code{"group"} or a vector of the same length as the \code{"list"}
  for a more modular approach to computing residuals. 
}

\value{
  a numeric matrix of the same number of rows as the provided
  \code{data} and the same number of columns as the provided.
  If \code{"simplify"} is set to TRUE, a numeric vector will
  be returned. 
}
\author{
  Pavel Panko
}
\examples{
## Load the data:
data(iris)

## Orthogonalize "Petal.Width" and add the intercept:
Petal.Width.Prime <- orthogonalize(
	formula   = Petal.Width ~ Petal.Length + Sepal.Length, 
	data      = iris, 
	intercept = TRUE
)

## Orthgonalize "Petal.Width" within "Species:
Petal.Width.Prime <- orthogonalize(
	formula = Petal.Width ~ ., 
	data    = iris, 
	group   = "Species" 
)

## Orthgonalize the "Width" variables, one within-group, one not:
Width.Prime <- orthogonalize(
	formula = list(
                    Petal.Width ~ .,
                    Sepal.Width ~ .
                  ),
	data    = iris, 
	group   = c("Species", "") 
)

## Orthgonalize the "Width" variables, adding the intercept to one
## but not the other:
Width.Prime <- orthogonalize(
	formula    = list(
                       Petal.Width ~ .,
                       Sepal.Width ~ .
                     ),
	data       = iris, 
	intercept  = c(TRUE, FALSE) 
)

}
