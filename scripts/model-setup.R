create.data.matrices <- function(dat){
  
  return(list(
    data = list(
      y = dat$weight,
      x = dat$age
    ),
    consts = list(
      N = nrow(dat),
      mu_eta = rep(0, 2),
      C = matrix(c(5, 0,
                   0, 5), nrow=2),
      Sigma = matrix(c(10, 0,
                       0, 10), nrow=2),
      I.N = 30,
      I = rep(1:30, 5),
      nu.0 = 0.1,
      lambda.0 = 0.1
    ),
    inits = list(
      tau = 1,
      re_params = c(0, 0),
      theta = matrix(c(0, 1), nrow=2, ncol=30)
    )
  ))
  
}