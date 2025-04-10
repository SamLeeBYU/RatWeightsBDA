library(MASS)
library(HDInterval)

source("scripts/setup.R")
source("scripts/model-setup.R")

sampler <- function(y, X, burnin = 1000, iters = 1000, thin = 10, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  
  total_iters <- burnin + iters * thin
  
  tau <- numeric(length = total_iters)
  tau[1] <- 1
  theta <- nimArray(c(100, 6), dim = c(2, 30, total_iters))
  mu.c <- matrix(0, nrow = 2, ncol = total_iters)
  
  N <- length(y)
  
  eta <- rep(0, 2)
  C <- matrix(c(5, 0, 0, 5), nrow = 2)
  C.inverse <- solve(C)
  Sigma <- matrix(c(10, 0, 0, 10), nrow = 2)
  Sigma.inverse <- solve(Sigma)
  
  nu.0 <- 0.1
  lambda.0 <- 0.1
  
  V <- solve(30 * Sigma.inverse + C.inverse)
  
  X.i <- cbind(1, X[1:N %% 30 == 1])
  #X.stack <- do.call("rbind", replicate(30, X.i, simplify = FALSE))
  
  rat.vals <- 1:N %% 30 == 0
  Y.stack = y[rat.vals]
  for (i in 1:30) {
    rat.vals <- 1:N %% 30 == i
    Y.stack <- cbind(y[rat.vals], Y.stack)
  }
  
  pb <- txtProgressBar(min = 2, max = total_iters, style = 3)
  for (t in 2:total_iters) {
    setTxtProgressBar(pb, t)
    # Sample theta
    s <- 0
    for (i in 1:30) {
      rat.vals <- 1:N %% 30 == i
      if (i == 30) {
        rat.vals <- 1:N %% 30 == 0
      }
      
      D.i.inverse <- crossprod(X.i) / tau[t - 1] + Sigma.inverse
      D.i <- solve(D.i.inverse)
      Y.i <- y[rat.vals]
      theta[, i, t] <- mvrnorm(n = 1, mu = D.i %*% (crossprod(X.i, Y.i) / tau[t - 1] + Sigma.inverse %*% mu.c[, t - 1]), Sigma = D.i)
      
      s <- s + crossprod(Y.i - X.i %*% theta[, i, t])  
    }
    
    # Sample Mu
    theta.bar <- rowMeans(theta[, , t])
    mu.c[, t] <- mvrnorm(n = 1, mu = V %*% (30 * Sigma.inverse %*% theta.bar), Sigma = V)
    
    # Sample Tau
    tau[t] <- rinvgamma(n = 1, shape = (nu.0 + 150) / 2, scale = 0.5 * (nu.0 * lambda.0 + s))
  }
  close(pb)
  
  # Thin and drop burnin
  keep <- seq(from = burnin + 1, to = total_iters, by = thin)
  
  out <- list(
    tau = tau[keep],
    mu1 = mu.c[1, keep],
    mu2 = mu.c[2, keep]
  )
  
  return(coda::as.mcmc(data.frame(out)))
}

chain1 <- sampler(model.input$data$y, model.input$data$x, burnin = 1000, iters = 1000, thin = 25, seed = 1)
chain2 <- sampler(model.input$data$y, model.input$data$x, burnin = 1000, iters = 1000, thin = 25, seed = 2)
chain3 <- sampler(model.input$data$y, model.input$data$x, burnin = 1000, iters = 1000, thin = 25, seed = 3)
chain4 <- sampler(model.input$data$y, model.input$data$x, burnin = 1000, iters = 1000, thin = 25, seed = 4)

chains <- coda::mcmc.list(chain1, chain2, chain3, chain4)

coda::traceplot(chains[, "tau"], main = expression(tau))
coda::traceplot(chains[, "mu1"], main = expression(alpha[c]))
coda::traceplot(chains[, "mu2"], main = expression(beta[c]))

samples <- as.matrix(chains)