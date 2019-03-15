// Title:    Orthgonalization function back end 
// Author:   Pavel Panko
// Created:  2018-OCT-16
// Modified: 2019-MAR-14

// [[Rcpp::depends(RcppArmadillo)]]
#include <RcppArmadillo.h>
#include <Rcpp.h>

arma::vec calc_residuals( const arma::mat& X, const arma::colvec& y, const int intercept,
			  const int GroupVec = 0)
{

  // define coefficients using arma solver 
  arma::vec coef = solve(X, y);

  // define residuals as difference between y and fitted
  arma::vec resid = y - X*coef;

  // if specified, add intercept to returned residuals
  return resid + coef[0]*intercept;
  
} // END "calc_residuals_single" function

arma::vec calc_residuals( const arma::mat& X, const arma::vec& y, const int intercept,
				const arma::ivec& GroupVec )
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
    ResidVec.elem(GroupObs) = calc_residuals(X.rows(GroupObs), y(GroupObs), intercept);
    
  } // END "grouping" loop
  
  return ResidVec;
  
} // END "calc_residuals_group" function 

// [[Rcpp::export]]
arma::vec get_residuals( const Rcpp::NumericMatrix& X, const Rcpp::NumericVector y,
				   const int intercept, SEXP GroupVec )
{
  // re-define X and y as arma:: objects 
  arma::mat X_ = Rcpp::as<arma::mat>(X);
  arma::vec y_ = Rcpp::as<arma::vec>(y);

  // dispatch overloaded function 
  switch(TYPEOF(GroupVec)) {

    // if GroupVec is logical
    case LGLSXP: {

      // compute residuals using single group 
      return calc_residuals(X_, y_, intercept);
      
    } // END case - logical GroupVec

    //  If GroupVec is integer
    case INTSXP: {

      // re-define GroupVec as an arma::ivec
      arma::ivec GroupVec_ = Rcpp::as<arma::ivec>(GroupVec);

      // Compute residuals by group
      return calc_residuals(X_, y_, intercept, GroupVec_);
      
    } // END case - integer GroupVec
      
  } // END switch for function dispatch

  // Not run
  return y_;
  
} // END "get_residuals" function 
