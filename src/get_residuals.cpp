// [[Rcpp::depends(RcppArmadillo)]]
#include <RcppArmadillo.h>
#include <Rcpp.h>

// [[Rcpp::export]]
arma::colvec get_residuals( const arma::mat& X, const arma::colvec& y ) {
  arma::colvec coef = solve(X, y);
  arma::colvec resid = y - X*coef;
  return resid + coef[0]; // 
}

// [[Rcpp::export]]
arma::vec get_group_residuals( const arma::mat& X, const arma::vec& y, const arma::ivec& GroupVec ) {

  arma::vec ResidVec(y.size());
  arma::ivec UnqGroup = unique(GroupVec);

  for(int j = 0; j < UnqGroup.size(); j++) {// Loop through input 
    arma::uvec GroupObs = find(GroupVec == UnqGroup[j]); 
    ResidVec.elem(GroupObs) = get_residuals(X.rows(GroupObs), y(GroupObs));
  }
  return ResidVec;
}
