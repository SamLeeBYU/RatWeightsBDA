# RatWeightsBDA

This repository contains a Bayesian hierarchical analysis of longitudinal rat weight data, as part of a STAT 651 graduate project. The data and model are inspired by the classical example from Gelfand et al. (1990), *Illustration of Bayesian Inference in Normal Data Models Using Gibbs Sampling*, JASA.

## 📊 Project Overview

We analyze the weights of 30 rats measured across 5 consecutive weeks. Each rat's weight is modeled as a linear function of age, with **rat-specific intercepts and slopes** that are drawn from a common bivariate normal distribution. A **Gibbs sampler** is implemented to estimate the posterior distribution of:

- Individual parameters: $\alpha_i$, $\beta_i$
- Population-level parameters: $\alpha_c$, $\beta_c$
- Residual precision: $\tau$

## 📁 Repository Structure

├── data/ 
  │ ├── ratdata.xlsx # Original dataset 
  │ └── parameters.txt # Prior specification: η, C, Σ, ν₀, λ₀ 
├── scripts/ 
  │ ├── gibbs_sampler-R.R # Core implementation of the Gibbs sampler (runs model-setup.R); Compare also, nimble-model.R
  | ├── mcmc-analysis.R # Geweke, Gelman-Rubin, Heidelberger-Welch, Raftery-Lewis and Posterior density, trace, correlation plots 
  | ├── setup.R # Sets up data for analysis
  | ├── eda.R, ols.R # EDA scripts
├── figures/ 
  │ ├── posterior-distributions and traceplots 
  | ├── EDA plots from eda.R and ols.R
  │ └── samples-cor.png # Parameter correlation heatmap
── README.md

## 📐 Statistical Model

The model is given by:

\[
Y_{ij} \sim \mathcal{N}(\alpha_i + \beta_i x_{ij}, \tau), \quad
\begin{pmatrix}
\alpha_i \\
\beta_i
\end{pmatrix}
\sim \mathcal{N}_2\left(
\begin{pmatrix}
\alpha_c \\
\beta_c
\end{pmatrix}, \Sigma \right),
\]

with a hyperprior:

\[
(\alpha_c, \beta_c) \sim \mathcal{N}_2(\eta, C), \quad
\tau \sim \text{Inverse-Gamma}(\nu_0 / 2, \nu_0 \lambda_0 / 2)
\]

## 🚀 Implementation

We coded a custom Gibbs sampler using R to draw from the full conditional distributions derived analytically. Convergence was assessed using:

- **Geweke diagnostic**
- **Heidelberger-Welch test**
- **Raftery-Lewis diagnostic**
- **Gelman-Rubin PSRF**

## 📈 Results

- Posterior densities and trace plots show good mixing across all chains.
- Multivariate Gelman-Rubin PSRF = 1.00 suggests full convergence.
- Correlation and covariance matrices of $(\alpha_c, \beta_c, \tau)$ are visualized and reported.

## 🧠 Authors

- Sam Lee, Brigg Trendler

## 📄 Reference

Gelfand, A. E., Hills, S. E., Racine-Poon, A., & Smith, A. F. M. (1990). Illustration of Bayesian inference in normal data models using Gibbs sampling. *Journal of the American Statistical Association*, 85(412), 972–985.

