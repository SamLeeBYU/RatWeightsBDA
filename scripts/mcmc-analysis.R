#Diagnostics
geweke <- coda::geweke.diag(samples)
heidelberg <- coda::heidel.diag(samples)
raftery <- coda::raftery.diag(samples)
gelman <- coda::gelman.diag(chains)

geweke; heidelberg; raftery; gelman;

ggplot(mapping=aes(x = samples[,1])) +
  geom_density(fill = "red", alpha = 0.6) +
  labs(x = expression(tau), y = "Density") +
  theme

ggplot(mapping=aes(x = samples[,2])) +
  geom_density(fill = "skyblue", alpha = 0.6) +
  labs(x = expression(alpha[c]), y = "Density") +
  theme

ggplot(mapping=aes(x = samples[,3])) +
  geom_density(fill = "orange", alpha = 0.6) +
  labs( x = expression(beta[c]), y="") +
  theme

colMeans(samples)
samples %>% apply(2, function(x){
  hdi(x, credMass=0.95)
})

n_draws <- nrow(samples)

means <- colMeans(samples)
hdis <- apply(samples, 2, function(x) hdi(x, credMass = 0.95))
sds <- apply(samples, 2, sd)
ses <- sds / sqrt(n_draws)

means
hdis
ses

samples.cor <- cor(samples)

cor_long <- reshape2::melt(samples.cor)

ggplot(cor_long, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile(color = "white", show.legend = F) +
  geom_text(aes(label = sprintf("%.2f", value)), color = "black", size = 10) +
  scale_fill_gradient2(low = blue, mid = "white", high = orange, 
                       midpoint = 0, limits = c(-1, 1), name = "Correlation") +
  scale_x_discrete(labels = c("tau" = expression(tau), 
                              "mu1" = expression(alpha[c]), 
                              "mu2" = expression(beta[c]))) +
  scale_y_discrete(labels = c("tau" = expression(tau), 
                              "mu1" = expression(alpha[c]), 
                              "mu2" = expression(beta[c]))) +
  labs(title = "Posterior Correlation Heatmap", x = "", y = "")+
  theme