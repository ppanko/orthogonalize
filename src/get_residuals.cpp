// Title:    Orthgonalization function back end 
// Author:   Pavel Panko
// Created:  2018-OCT-16
// Modified: 2018-DEC-07

#include <RcppArmadillo.h>
#include <Rcpp.h>

// [[Rcpp::depends(RcppArmadillo)]]

// [[Rcpp::export]]
arma::vec get_residuals( const arma::mat& X, const arma::colvec& y, const int intercept )
{

  // define coefficients using arma solver 
  arma::vec coef = solve(X, y);

  // define residuals as difference between y and fitted
  arma::vec resid = y - X*coef;

  // if specified, add intercept to returned residuals
  return resid + coef[0]*intercept;
  
} // END "get_residuals" function

// [[Rcpp::export]]
arma::vec get_group_residuals( const arma::mat& X, const arma::vec& y, const arma::ivec& GroupVec, const int intercept )
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
    ResidVec.elem(GroupObs) = get_residuals(X.rows(GroupObs), y(GroupObs), intercept);
    
  } // END "grouping" loop
  
  return ResidVec;
  
} // END "get_group_residuals" function 
