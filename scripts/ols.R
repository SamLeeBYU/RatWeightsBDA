source("scripts/setup.R")

rat.names <- unique(rats$rat)

alphas <- betas <- numeric(30)

for(r in 1:length(rat.names)){
  rat = rat.names[r]
  rat.dat <- rats[rats$rat == rat, ]
  
  X <- cbind(1, rat.dat$age)
  y <- rat.dat$weight
  beta.hat <- qr.solve(t(X)%*%X, t(X)%*%y)
  
  alphas[r] <- beta.hat[1,]
  betas[r] <- beta.hat[2,]
}

params <- data.frame(
  value = c(alphas, betas),
  parameter = rep(c("alpha", "beta"), times = c(length(alphas), length(betas)))
)

alpha.plt <- ggplot(subset(params, parameter == "alpha"), aes(x = value)) +
  geom_density(fill = "skyblue", alpha = 0.6) +
  labs(x = expression(alpha[i]), y = "Density") +
  theme

beta.plt <- ggplot(subset(params, parameter == "beta"), aes(x = value)) +
  geom_density(fill = "orange", alpha = 0.6) +
  labs( x = expression(beta[i]), y="") +
  theme

alpha.plt + beta.plt
