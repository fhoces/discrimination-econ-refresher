# =============================================================================
# Module 5: Modern Methods & The Practitioner Question
# Application: Doubly-robust estimation + a practitioner memo
# =============================================================================
#
# We take the simulated surge-pricing data from Module 4 and run a
# doubly-robust estimator (AIPW) for the effect of high-minority neighborhood
# status on fare per mile, with ML nuisance functions. We compare to naive
# OLS. Then we walk through what a practitioner memo would look like.

library(tidyverse)
library(broom)
set.seed(2026)

# =============================================================================
# PART 1: Recreate the Module 4 city
# =============================================================================

n_nbhd <- 200  # bigger this time so the ML methods have something to chew on

city <- tibble(
  neighborhood  = paste0("N", sprintf("%03d", 1:n_nbhd)),
  pct_minority  = runif(n_nbhd, 0.05, 0.90),
  median_income = pmax(rnorm(n_nbhd, 65000 - 30000 * pct_minority, 10000), 20000),
  pop_density   = pmax(rnorm(n_nbhd, 5000 - 2000 * pct_minority, 1500), 200),
  driver_supply = pmax(8 - 6 * pct_minority + rnorm(n_nbhd, 0, 0.5), 0.5),
  demand        = rnorm(n_nbhd, 10, 1.5)
) |>
  mutate(
    surge_multiplier = pmax(1, demand / driver_supply),
    fare_per_mile    = 1.50 * surge_multiplier,
    high_minority    = as.integer(pct_minority >= median(pct_minority))
  )

# =============================================================================
# PART 2: The naive estimator (OLS)
# =============================================================================
#
# Crude regression of fare on the binary high-minority indicator,
# controlling for legitimate observables.

ols_fit <- lm(fare_per_mile ~ high_minority + median_income + pop_density + demand,
              data = city)

cat("\n--- Naive OLS estimate ---\n")
print(tidy(ols_fit) |> mutate(across(where(is.numeric), \(x) round(x, 4))))
naive_effect <- coef(ols_fit)["high_minority"]
cat("\nNaive ATE estimate (high_minority - low_minority): $",
    round(naive_effect, 3), "\n", sep = "")

# =============================================================================
# PART 3: Doubly-robust estimator (AIPW with simple ML)
# =============================================================================
#
# AIPW formula:
#   ATE = mean( T * Y / m(X) - (1 - T) * Y / (1 - m(X))
#               + (mu1(X) - mu0(X))
#               - (T - m(X)) * (mu1(X) / m(X) + mu0(X) / (1 - m(X))) )
#
# where m(X) = P(T = 1 | X) (propensity model) and mu_t(X) = E[Y | T = t, X]
# (response models). We'll use random forests for both via ranger.

if (requireNamespace("ranger", quietly = TRUE)) {
  library(ranger)

  # Propensity model: P(high_minority | X)
  m_fit <- ranger(
    high_minority ~ median_income + pop_density + demand,
    data = city,
    probability = TRUE,
    num.trees = 200
  )
  m_hat <- predict(m_fit, city)$predictions[, "1"]
  m_hat <- pmin(pmax(m_hat, 0.05), 0.95)  # avoid extreme weights

  # Response models: E[fare | T = t, X]
  mu1_fit <- ranger(
    fare_per_mile ~ median_income + pop_density + demand,
    data = filter(city, high_minority == 1),
    num.trees = 200
  )
  mu0_fit <- ranger(
    fare_per_mile ~ median_income + pop_density + demand,
    data = filter(city, high_minority == 0),
    num.trees = 200
  )

  mu1_hat <- predict(mu1_fit, city)$predictions
  mu0_hat <- predict(mu0_fit, city)$predictions

  # AIPW
  T <- city$high_minority
  Y <- city$fare_per_mile

  aipw <- mean(
    T * Y / m_hat - (1 - T) * Y / (1 - m_hat)
    + (mu1_hat - mu0_hat)
    - (T - m_hat) * (mu1_hat / m_hat + mu0_hat / (1 - m_hat))
  )

  cat("\n--- AIPW (doubly-robust ML) estimate ---\n")
  cat("ATE estimate: $", round(aipw, 3), "\n", sep = "")
  cat("Compared to naive OLS: $", round(naive_effect, 3), "\n", sep = "")
} else {
  cat("\nSkipping AIPW estimation: install 'ranger' to run this section.\n")
  cat("install.packages('ranger')\n")
}

# =============================================================================
# PART 4: A practitioner memo (template)
# =============================================================================

cat("\n
=================================================================
PRACTITIONER MEMO TEMPLATE
=================================================================
TO:    [Director of Policy / VP Pricing / Legal]
FROM:  [Policy Economist team]
RE:    Disparate impact audit of surge pricing
DATE:  [today]

QUESTION
---------
The Chicago Transportation Department asked whether the surge-pricing
algorithm produces systematically higher fares per mile in census tracts
with higher non-white population shares.

DATA
-----
- N = [count] tracts in [period]
- Outcome: fare per mile
- Treatment: indicator for tract above median %% minority
- Controls: median income, population density, demand level

METHOD
-------
We estimate the average treatment effect of the high-minority indicator
on fare per mile two ways:

  1. Linear regression with controls (OLS)
  2. Doubly-robust ML estimator (AIPW with random-forest nuisance fns)

The DR estimator is robust to misspecification of either the propensity
or response model and is preferred for the official report.

RESULTS
--------
- Naive OLS:  $X.XX higher per mile in high-minority tracts (SE Y.YY)
- AIPW (DR):  $X.XX higher per mile (SE Y.YY)

The two estimates agree to within standard error. The disparate impact
ratio is 1.0X (high vs low minority tracts).

INTERPRETATION
--------------
The algorithm does not use race or ethnicity. The disparate impact
arises through driver supply: high-minority tracts have lower driver
supply, which triggers more frequent and larger surge multipliers.

This is a textbook case of statistical discrimination via a proxy. The
algorithm is doing what it was designed to do; the disparate impact is
emergent from the supply distribution.

POLICY OPTIONS
--------------
1. Cap surge multipliers at 1.5x. Eliminates ~50%% of the disparate
   impact at the cost of ~5%% revenue.
2. Subsidize driver supply in low-supply tracts. Eliminates the
   underlying mechanism but requires capital and operational change.
3. Disclosure-only: report the disparate impact externally with the
   above explanation, no algorithmic change.

RECOMMENDATION
--------------
Pilot option 1 in 3 cities for 30 days. Measure revenue impact and
disparate impact reduction. Decide on rollout based on the pilot.

CAVEATS
-------
- The audit is observational; we cannot rule out unobserved confounding
- The ML estimates require ~N samples to be reliable
- The policy options are ranked by feasibility, not by social welfare
=================================================================
")

cat("\n")
cat("Key takeaways:\n")
cat("1. Doubly-robust ML methods give similar point estimates to OLS in\n")
cat("   well-specified settings, but are more robust to misspecification\n")
cat("   when you have many controls.\n")
cat("2. The harder skill in the practitioner role is the MEMO, not the\n")
cat("   estimation. The estimation is mechanical; the framing is judgment.\n")
cat("3. Always include: question, data, method, result, interpretation,\n")
cat("   policy options, recommendation, caveats. Skip any of these and\n")
cat("   the memo will be sent back.\n")
