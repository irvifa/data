

# Set seed to make a reproducible experiment.
set.seed(42)

# Initialize sample size from exponential distribution 1000
# Define:
# - the distribution parameters (lambda)
# - sample size (sample_size)
# - number of simulations (number_of_simulations)
lambda <- 0.2
sample_size <- 40
number_of_simulations <- 1000

# Calculate:
# - the theoretical mean (mu)
# - standard deviation (sd)
mu <- 1 / lambda
sd <- 1 / lambda

sample.distr <- matrix(data = rexp(sample_size * number_of_simulations, lambda),
                       nrow = number_of_simulations)
sample.means <- apply(sample.distr, 1, mean)
mu
mean(sample.means)

# Compare absolute difference between the theoretical mean and the sample mean is
abs(mu - mean(sample.means))

# Compute the sample mean variance and compare to the theoretical variance
sample.mean.var <- var(sample.means)
sample.mean.var

# Compute the theoretical variance of the exponential distribution
theoretical.var <- 1 / ((lambda * sqrt(sample_size))) ^ 2
theoretical.var
sample.mean.var

# Compare the sample mean variance to that of the theoretical variance
abs(theoretical.var - sample.mean.var)


# Plot the sample means
library(ggplot2)

ggplot(data.frame(y = sample.means), aes (x = y)) +
  geom_histogram(
    aes(y = ..density..),
    binwidth = 0.2,
    fill = "blue",
    color = "black"
  ) +
  geom_vline(
    xintercept = mean(sample.means),
    color = "red",
    size = 1.5
  ) +
  stat_function(
    fun = dnorm,
    n = sample_size,
    args = list(mean = 1 / lambda,
                sd = 1 / (lambda * sqrt(sample_size))),
    size = 2
  ) +
  labs(title = "Density histogram of sample means",
       x = "Simulation Mean",
       y = NULL)
