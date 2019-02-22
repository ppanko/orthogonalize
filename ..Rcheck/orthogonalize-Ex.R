pkgname <- "orthogonalize"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
library('orthogonalize')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("orthogonalize")
### * orthogonalize

flush(stderr()); flush(stdout())

### Name: orthogonalize
### Title: Residualize covariates.
### Aliases: orthogonalize

### ** Examples

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



### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
