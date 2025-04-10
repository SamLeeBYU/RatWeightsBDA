import numpy as np
from scipy.stats import invgamma, multivariate_normal
import pandas as pd
import matplotlib.pyplot as plt

# Sample for theta
def sample_theta(Y, X, tau, Sig, mu_c):
    N = Y.shape[1]
    theta = np.zeros((2, N))
    Sig_inv = np.linalg.inv(Sig)
    Di = np.linalg.inv(1/tau * (X.T@X) + Sig_inv)
    for i in range(N):
        theta[:, i] = np.random.multivariate_normal(Di @ (1/tau * X.T @ Y[:,i] + Sig_inv@mu_c), Di)
    return theta

# Sample for mu
def sample_mu(Y, Sig, theta, C, eta):
    Sig_inv = np.linalg.inv(Sig)
    C_inv = np.linalg.inv(C)
    theta_bar = np.mean(theta, axis=1)
    V = np.linalg.inv(30 * Sig_inv + C_inv)
    return np.random.multivariate_normal(V @ (30 * Sig_inv@theta_bar + C_inv @ eta), V)

# Sample for tau
def sample_tau(Y, X, theta, nu_0, lamb_0):
    residuals = Y - X @ theta  # shape: (5, 30)
    total = np.sum(residuals ** 2)

    return invgamma.rvs((nu_0 + 150)/2, scale=1/2 * (nu_0*lamb_0 + total))

# Gibbs sampler
def mcmc(Y, X, lamb_0, nu_0, eta, Sig, C, iterations = 1000):
    theta = np.ones((2,30))
    mu = np.ones(2)
    tau = 1
    samples = []
    for _ in range(iterations):
        theta = sample_theta(Y, X, tau, Sig, mu)
        mu = sample_mu(Y, Sig, theta, C, eta)
        tau = sample_tau(Y, X, theta, nu_0, lamb_0)
        samples.append((theta, mu, tau))
    return samples


if __name__ == '__main__':
    # Define parameters
    lamb_0 = 0.1
    nu_0 = 0.1
    eta = np.array([0,0])
    Sig = 10 * np.eye(2)
    C = 5 * np.eye(2)

    # Read in the data
    data = pd.read_csv("./data/ratdata.csv")
    Y = np.array(data.loc[:, 'rat1':'rat30'].values, dtype=float)
    X = np.hstack((np.ones(5).reshape(-1, 1), data.age.values.reshape(-1,1)))

    # Run the Gibbs sampler
    print("Running Gibbs sampler...")
    samples = mcmc(Y, X, lamb_0, nu_0, eta, Sig, C, iterations=5000)
    burnin = 1000

    mu_samples = np.array([s[1] for s in samples[burnin:]])
    tau_samples = np.array([s[2] for s in samples[burnin:]])

    # Report results
    print()
    print("Posterior mean for mu:", np.mean(mu_samples, axis=0))
    print("95% CI for mu:", np.percentile(mu_samples, [2.5, 97.5], axis=0))
    print()
    print("Posterior mean for tau:", np.mean(tau_samples))
    print("95% CI for tau:", np.percentile(tau_samples, [2.5, 97.5]))

    # Plot
    plt.plot(mu_samples[:, 0])
    plt.title("Trace plot for mu[0]")
    plt.show()
