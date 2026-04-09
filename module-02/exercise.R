# =============================================================================
# Module 2: Audit & Correspondence Studies
# Application: A stylized Ge et al. (2016) replication
# =============================================================================
#
# We simulate a matched-pair audit of a TNC (transportation network company)
# in the spirit of Ge, Knittel, MacKenzie & Zoepf (2016). Two rider profiles
# (A and B) submit identical ride requests; drivers cancel B requests at a
# higher rate. We estimate the audit effect, its standard error, and run a
# power calculation to figure out how many requests we'd need.

library(tidyverse)
set.seed(2026)

# =============================================================================
# PART 1: Simulate the audit
# =============================================================================
#
# The "true" effect of being a B-profile is +5 percentage points on the
# cancellation rate. Baseline cancellation rate is 5% for A.

n_rides_per_group <- 500
baseline_cancel_A <- 0.05
discrimination    <- 0.05   # B-profile faces a 10% cancellation rate

audit <- bind_rows(
  tibble(
    profile  = "A",
    cancelled = rbinom(n_rides_per_group, 1, baseline_cancel_A)
  ),
  tibble(
    profile  = "B",
    cancelled = rbinom(n_rides_per_group, 1, baseline_cancel_A + discrimination)
  )
)

cat("\n--- Audit results ---\n")
audit |>
  group_by(profile) |>
  summarise(
    n            = n(),
    cancellation = round(mean(cancelled), 3),
    .groups = "drop"
  ) |>
  print()

# =============================================================================
# PART 2: Estimate the audit effect with standard errors
# =============================================================================
#
# Two equivalent ways:
#
#   (a) two-proportion z-test
#   (b) linear regression of cancelled on profile

# (a) z-test
counts <- audit |>
  group_by(profile) |>
  summarise(x = sum(cancelled), n = n(), .groups = "drop")
prop_test <- prop.test(x = counts$x, n = counts$n, correct = FALSE)

cat("\n--- Two-proportion z-test ---\n")
cat("Estimated gap (B - A):",
    round(diff(rev(prop_test$estimate)), 4), "\n")
cat("95% CI for the gap:   [",
    round(-prop_test$conf.int[2], 4), ",",
    round(-prop_test$conf.int[1], 4), "]\n")
cat("p-value:               ", format.pval(prop_test$p.value, digits = 3), "\n")

# (b) linear regression — gives the same point estimate and a heteroskedasticity-
#     robust SE if you use sandwich::vcovHC, but here we use vanilla lm
fit_lpm <- lm(cancelled ~ profile, data = audit)

cat("\n--- Linear probability model ---\n")
print(summary(fit_lpm)$coefficients)

# =============================================================================
# PART 3: How many requests do we need? (Power calculation)
# =============================================================================
#
# We want 80% power to detect a 5pp gap at the 0.05 significance level.

power_test <- power.prop.test(
  p1 = baseline_cancel_A,
  p2 = baseline_cancel_A + discrimination,
  sig.level = 0.05,
  power = 0.8
)
cat("\n--- Power calculation ---\n")
cat("To detect a 5pp gap (5% vs 10%) with 80% power, you need:\n")
cat("  ~", ceiling(power_test$n), "rides per group\n")
cat("  ~", 2 * ceiling(power_test$n), "rides total\n")

# What if the discrimination is smaller?
smaller_gap <- power.prop.test(
  p1 = baseline_cancel_A,
  p2 = baseline_cancel_A + 0.02,
  sig.level = 0.05,
  power = 0.8
)
cat("\nFor a 2pp gap (5% vs 7%): ~",
    ceiling(smaller_gap$n), "per group, ",
    2 * ceiling(smaller_gap$n), "total.\n")

# =============================================================================
# PART 4: A monte-carlo power experiment
# =============================================================================
#
# Simulate the audit many times and ask: in what fraction of runs does the
# z-test reject the null at 0.05?

simulate_audit <- function(n_per_group, p_A, p_B) {
  x <- rbinom(2, c(n_per_group, n_per_group), c(p_A, p_B))
  test <- prop.test(x, c(n_per_group, n_per_group), correct = FALSE)
  test$p.value < 0.05
}

n_sim <- 2000
sample_sizes <- c(50, 100, 200, 500, 1000)
power_curve <- map_dfr(sample_sizes, function(n_g) {
  rejections <- replicate(n_sim, simulate_audit(n_g, 0.05, 0.10))
  tibble(n_per_group = n_g, power = mean(rejections))
})
print(power_curve)

ggplot(power_curve, aes(n_per_group, power)) +
  geom_line(linewidth = 1.2, color = "firebrick") +
  geom_point(size = 2.5, color = "firebrick") +
  geom_hline(yintercept = 0.8, linetype = "dashed", color = "grey50") +
  scale_x_log10() +
  labs(
    title = "Audit-study power vs sample size",
    subtitle = "Detecting a 5pp cancellation gap (5% vs 10%) at α = 0.05",
    x = "Rides per profile (log scale)",
    y = "Power (probability of rejecting H0)"
  ) +
  theme_minimal()


# =============================================================================
# PART 5: What we did and didn't identify
# =============================================================================

cat("\n")
cat("Key takeaways:\n")
cat("1. The audit cleanly identifies the CAUSAL effect of being a B-profile.\n")
cat("2. It cannot tell us WHY drivers are cancelling — taste vs statistical.\n")
cat("3. With 5% baseline and 5pp gap, ~470 rides per group gives 80% power.\n")
cat("4. With a 2pp gap (a more realistic case for many platforms), you need\n")
cat("   thousands of rides per group — that's why most field audit studies\n")
cat("   are very expensive.\n")
cat("5. This power-cost tradeoff is why algorithmic / scraped audits\n")
cat("   (Module 4) became the dominant approach for large-scale work.\n")
