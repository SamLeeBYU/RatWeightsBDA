library(nimble)

source("scripts/setup.R")
source("scripts/model-setup.R")

run <- F

model.code <- nimbleCode({
  
  tau ~ dinvgamma(nu.0/2, nu.0*lambda.0/2)
  re_params[1:2] ~ dmnorm(mu_eta[1:2], cov = C[1:2, 1:2])
  
  for(i in 1:I.N){
    theta[1:2,i] ~ dmnorm(re_params[1:2], cov = Sigma[1:2, 1:2])
  }
  
  for(n in  1:N){
    y[n] ~ dnorm(theta[1, I[n]] + theta[2, I[n]]*x[n], sd=sqrt(tau))
  }
  
})

model.input <- create.data.matrices(rats)

if(run){
  model <- nimbleModel(
    code = model.code,
    constants = model.input$consts,
    data = model.input$data,
    inits = model.input$inits
  )
  
  compiled.model <- compileNimble(model)
  
  conf <- configureMCMC(model)
  mcmc <- buildMCMC(conf, monitors = c("theta", "tau", "re_params"))
  compiled.mcmc <- compileNimble(mcmc, project = model)
  
  model.out <- runMCMC(compiled.mcmc, niter = 500000, nburnin = 10000, thin = 500, nchains = 8, 
                       samplesAsCodaMCMC=TRUE,
                       summary = T)
  coda::traceplot(model.out$samples) 
}
