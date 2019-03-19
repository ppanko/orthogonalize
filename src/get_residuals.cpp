// [[Rcpp::depends(RcppArmadillo)]]
#include <RcppArmadillo.h>
#include <Rcpp.h>

//
arma::vec calc_residuals_single( const arma::mat& X, const arma::vec& y, const int intercept )
{

  // define coefficients using arma solver 
  arma::vec coef = solve(X, y);

  // define residuals as difference between y and fitted
  arma::vec resid = y - X*coef;

  // if specified, add intercept to returned residuals
  return resid + coef[0]*intercept;
  
} // END "calc_residuals_single" function

//
arma::vec calc_residuals_multi( const arma::mat& X, const arma::vec& y, const int intercept,
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
    ResidVec.elem(GroupObs) = calc_residuals_single(X.rows(GroupObs), y(GroupObs), intercept);
    
  } // END "grouping" loop
  
  return ResidVec;
  
} // END "calc_residuals_group" function 



// [[Rcpp::export]]
arma::mat get_residuals_multi( const Rcpp::List xList, const Rcpp::List yList,
			       const Rcpp::IntegerVector intercept, const Rcpp::List GroupList)
{
  // 
  Rcpp::NumericVector tmp_y = yList[1];
  arma::mat yOut(tmp_y.size(), yList.size());

  //
  for(int j = 0; j < yList.size(); j++) {
    
    // re-define X and y as arma:: objects 
    arma::mat X_ = Rcpp::as<arma::mat>(xList[j]);
    arma::vec y_ = Rcpp::as<arma::vec>(yList[j]);
    arma::ivec GV_ = Rcpp::as<arma::ivec>(GroupList[j]);

    //
    if(GV_.size() == 0) {

      // compute residuals using single group 
      yOut.col(j) = calc_residuals_single(X_, y_, intercept(j));

      //
    } else  {

      // Compute residuals by group
      yOut.col(j) = calc_residuals_multi(X_, y_, intercept(j), GV_);
      
    } // END case - integer GroupVec
      
  } // END switch for function dispatch
  
  //
  return yOut;
  
} //


// [[Rcpp::export]]
arma::vec get_residuals_single( const Rcpp::NumericMatrix& X, const Rcpp::NumericVector y,
				const int intercept, Rcpp::IntegerVector GroupVec )
{
  // re-define X and y as arma:: objects 
  arma::mat X_ = Rcpp::as<arma::mat>(X);
  arma::vec y_ = Rcpp::as<arma::vec>(y);
  arma::ivec GV_ = Rcpp::as<arma::ivec>(GroupVec);

  // dispatch overloaded function 
  if(GV_.size() == 0) {
    
    // compute residuals using single group 
    return calc_residuals_single(X_, y_, intercept);

    //
  } else { // END case - logical GroupVec
    
    // Compute residuals by group
    return calc_residuals_multi(X_, y_, intercept, GV_);
    
  } // END case - integer GroupVec
  
} // END "get_residuals" function 
