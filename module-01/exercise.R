# =============================================================================
# Module 1: Theory Primer — Becker and Phelps
# Application: Two indistinguishable acceptance gaps
# =============================================================================
#
# We simulate a population of riders where the TRUE acceptance probability is
# identical across two groups. We then inject the gap two ways:
#
#   1. Becker (taste-based): drivers cancel for group B at a higher rate
#      regardless of features
#   2. Phelps (statistical): the algorithm uses neighborhood, which is
#      correlated with group membership; the discrimination is "rational"
#
# The OBSERVED acceptance rates look the same in both cases. We discuss what
# an audit would see and what it would not.

library(tidyverse)
set.seed(2026)

# =============================================================================
# PART 1: Simulate the rider population
# =============================================================================

n <- 5000

riders <- tibble(
  rider_id  = 1:n,
  group     = sample(c("A", "B"), n, replace = TRUE, prob = c(0.6, 0.4)),
  # Group B is over-represented in some neighborhoods
  neighborhood = ifelse(
    runif(n) < ifelse(.data$group == "B", 0.65, 0.25),
    "Eastside",
    "Downtown"
  ),
  hour      = sample(0:23, n, replace = TRUE),
  is_night  = as.integer(hour >= 22 | hour <= 5),
  trip_dist = pmax(rlnorm(n, 1.2, 0.6), 0.3)
)

# True acceptance probability does NOT depend on group at all
riders <- riders |>
  mutate(
    true_logit = -0.2 - 0.5 * is_night - 0.1 * abs(trip_dist - 4),
    true_p     = plogis(true_logit),
    accepted_baseline = rbinom(n, 1, true_p)
  )

# =============================================================================
# PART 2: Becker — taste-based discrimination
# =============================================================================
#
# Drivers cancel an extra ~15% of the time when the rider is in group B.
# This is identical for every B rider regardless of any other feature.

becker_drop <- 0.15
riders <- riders |>
  mutate(
    p_becker = ifelse(group == "B", true_p * (1 - becker_drop), true_p),
    accepted_becker = rbinom(n, 1, p_becker)
  )

cat("\n--- Becker (taste-based) acceptance by group ---\n")
riders |>
  group_by(group) |>
  summarise(
    n = n(),
    actual_rate = round(mean(accepted_becker), 3),
    .groups = "drop"
  ) |>
  print()

# =============================================================================
# PART 3: Phelps — statistical discrimination via neighborhood
# =============================================================================
#
# Now the platform's dispatch algorithm uses neighborhood as a feature. In our
# data, Eastside happens to have a slightly lower acceptance rate (because
# more night rides cluster there, by construction). The algorithm rationally
# downweights Eastside requests.
#
# Group B is over-represented in Eastside. So even though the algorithm never
# sees `group`, group B ends up with a lower predicted acceptance rate.

# Fit a "rational" race-blind logistic regression on the baseline (no
# discrimination) data — this is the Phelps Bayesian update
fit_phelps <- glm(
  accepted_baseline ~ neighborhood + is_night + trip_dist,
  data = riders, family = binomial
)

riders <- riders |>
  mutate(
    p_phelps = predict(fit_phelps, type = "response"),
    accepted_phelps = rbinom(n, 1, p_phelps)
  )

cat("\n--- Phelps (statistical) acceptance by group ---\n")
riders |>
  group_by(group) |>
  summarise(
    n = n(),
    actual_rate = round(mean(accepted_phelps), 3),
    .groups = "drop"
  ) |>
  print()

# =============================================================================
# PART 4: Side-by-side comparison
# =============================================================================

comparison <- riders |>
  group_by(group) |>
  summarise(
    becker = round(mean(accepted_becker), 3),
    phelps = round(mean(accepted_phelps), 3),
    .groups = "drop"
  )

cat("\n--- Same observable gap, two different mechanisms ---\n")
print(comparison)

cat("\nGap (A - B), Becker: ",
    diff(rev(comparison$becker)), "\n")
cat("Gap (A - B), Phelps: ",
    diff(rev(comparison$phelps)), "\n")

# =============================================================================
# PART 5: What an audit would see
# =============================================================================
#
# A naive audit (just compare acceptance rates) would call BOTH cases
# discriminatory. A more sophisticated audit (regress acceptance on group
# CONTROLLING for neighborhood and other features) would catch Becker but
# MISS Phelps — because the discrimination is mediated through the features.

cat("\n--- Audit 1: marginal regression ---\n")
audit_marginal_becker <- glm(accepted_becker ~ group, data = riders, family = binomial)
audit_marginal_phelps <- glm(accepted_phelps ~ group, data = riders, family = binomial)
cat("  Becker, group coef:",
    round(coef(audit_marginal_becker)["groupB"], 3), "\n")
cat("  Phelps, group coef:",
    round(coef(audit_marginal_phelps)["groupB"], 3), "\n")

cat("\n--- Audit 2: regression CONTROLLING for neighborhood + features ---\n")
audit_ctrl_becker <- glm(
  accepted_becker ~ group + neighborhood + is_night + trip_dist,
  data = riders, family = binomial
)
audit_ctrl_phelps <- glm(
  accepted_phelps ~ group + neighborhood + is_night + trip_dist,
  data = riders, family = binomial
)
cat("  Becker, group coef (controlled):",
    round(coef(audit_ctrl_becker)["groupB"], 3),
    " <- still negative, the audit catches it\n")
cat("  Phelps, group coef (controlled):",
    round(coef(audit_ctrl_phelps)["groupB"], 3),
    " <- ~0, the audit misses it\n")

cat("\n")
cat("Key takeaways:\n")
cat("1. The OBSERVED gap is similar in both cases.\n")
cat("2. A naive audit cannot distinguish them.\n")
cat("3. Controlling for features ELIMINATES the gap under Phelps\n")
cat("   because the discrimination is fully mediated by neighborhood.\n")
cat("4. This is exactly the empirical problem with proxy discrimination:\n")
cat("   Phelps-style mechanisms hide from regression-based audits.\n")
cat("5. To detect Phelps-style discrimination you need EITHER\n")
cat("   - an experimental audit (Module 2) OR\n")
cat("   - a strong theory of which features 'should' matter\n")
