#include <RcppArmadillo.h>
#include <Rcpp.h>

// [[Rcpp::depends(RcppArmadillo)]]

// [[Rcpp::export]]
arma::vec get_residuals( const arma::mat& X, const arma::colvec& y )
{

  // define coefficients using arma solver 
  arma::vec coef = solve(X, y);

  // define residuals as difference between y and fitted
  arma::vec resid = y - X*coef;

  return resid + coef[0]; 
  
} // END "get_residuals" function

// [[Rcpp::export]]
arma::vec get_group_residuals( const arma::mat& X, const arma::vec& y, const arma::ivec& GroupVec )
{

  // define container object for residuals 
  arma::vec ResidVec(y.size());

  // define unique grouping variables 
  arma::ivec UnqGroup = unique(GroupVec);

  // LOOP over unique grouping variables 
  for(int j = 0; j < UnqGroup.size(); j++) {

    // define index for the specific grouping variable  
    arma::uvec GroupObs = find(GroupVec == UnqGroup[j]);

    // calculate group-specific residuals 
    ResidVec.elem(GroupObs) = get_residuals(X.rows(GroupObs), y(GroupObs));
    
  } // END "grouping" loop
  
  return ResidVec;
  
} // END "get_group_residuals" function 
