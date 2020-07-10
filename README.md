[![Build Status](https://travis-ci.org/ppanko/orthogonalize.svg?branch=master)](https://travis-ci.org/ppanko/orthogonalize)
[![codecov](https://codecov.io/gh/ppanko/orthogonalize/branch/master/graph/badge.svg)](https://codecov.io/gh/ppanko/orthogonalize)
# orthogonalize

The aim of the `orthogonalize` package is to streamline the process of residualizing covariates by letting C++ do some of the heavy lifting. 

Install `orthogonalize` in your R session by running the following code:

```R
devtools::install_github("ppanko/orthogonalize")
```

To check the help documentation in R:

```R
?orthogonalize

## OR

help(orthogonalize)
```

&nbsp;

---

# Usage

For ease of access, `orthogonalize` provides a formula interface and a
few sane defaults. Basic functionality can look like this: 

```R
library(orthogonalize)

data(iris)

petalWidthPrime <- orthogonalize(
  Petal.Width ~ ., iris 
)
```

&nbsp;

Slightly more complex requirements may call for within-group residuals 
or residuals offset by the intercept: 

```R
## By group 
pwPrimeGroup <- orthogonalize(
  formula = Petal.Width ~ ., 
  data    = iris,
  group   = "Species"
)

## Add intercept
pwPrimeIntercept <- orthogonalize(
  formula   = Petal.Width ~ ., 
  data      = iris,
  intercept = TRUE
)
```

&nbsp;

Following the main idea of letting C++ do the work, users can also 
supply multiple formulas in a list, as opposed to writing loops in R: 

```R
## Multiple formulas
widthPrimeMat <- orthogonalize(
  formula   = list(
                Petal.Width ~ ., 
		Sepal.Width ~ . 
	      ),
  data      = iris
)
```

&nbsp;

For a more modular apporach, the intercept and group arguments in the
multi-formula case can either take on single values (the default) as in 
the example above or be tweaked to suit user requirements:

```R
## Add intercept to first residual vector, 
## but not the second.
widthPrimeInt <- orthogonalize(
  formula   = list(
                Petal.Width ~ ., 
		Sepal.Width ~ . 
	      ),
  data      = iris,
  intercept = c(TRUE, FALSE)
)

## Single-group residuals for first residual
## vector and within-group residuals for the
## second. 
widthPrimeGrp <- orthogonalize(
  formula   = list(
                Petal.Width ~ ., 
		Sepal.Width ~ . 
	      ),
  data      = iris,
  group     = c("", "Species")
)

## Tweaking both intercept and group 
## parameters for each residual 
## vector.
widthPrimeMat <- orthogonalize(
  formula   = list(
                Petal.Width ~ ., 
		Sepal.Width ~ . 
	      ),
  data      = iris,
  intercept = c(TRUE, FALSE),
  group     = c("Species", "")
)
```

---

If you encounter any bugs while using this software or have a
suggestion, please file an issue or pull request on this page. 
For more general questions or assistance, please email me at 
pavel.panko@ttu.edu. 
