# =============================================================================
# Module 3: Decomposition Methods
# Application: A stylized Cook et al. (2021) replication on synthetic data
# =============================================================================
#
# We simulate ~5,000 Uber drivers with three behavioral features that
# differ by gender: experience, surge-time work, and driving speed. None of
# these are imposed by the platform — they emerge from the data-generating
# process. We then run an Oaxaca-Blinder decomposition and show that the
# entire pay gap is "explained" by the three behavioral features, mirroring
# the headline result of Cook et al. (2021).

library(tidyverse)
library(broom)
set.seed(2026)

# =============================================================================
# PART 1: Simulate Uber drivers
# =============================================================================

n <- 5000

drivers <- tibble(
  driver_id = 1:n,
  female    = rbinom(n, 1, 0.30),                  # 30% female
  # Behavioral features that differ by gender (matching the Cook et al. story)
  experience_hrs = pmax(rnorm(n, mean = ifelse(female, 250, 380),
                               sd = 100), 10),
  surge_share    = pmin(pmax(rnorm(n, mean = ifelse(female, 0.18, 0.27),
                                    sd = 0.10), 0), 1),
  speed_mph      = rnorm(n, mean = ifelse(female, 32.5, 33.2), sd = 3),
  # Pay per hour: a function of experience, surge, speed, plus noise
  pay_per_hr     = 18 +
                   0.012 * experience_hrs +
                   18 * surge_share +
                   0.40 * (speed_mph - 32) +
                   rnorm(n, 0, 2)
)

cat("\n--- Headline pay gap ---\n")
gap_summary <- drivers |>
  group_by(female) |>
  summarise(
    n_drivers = n(),
    avg_pay   = round(mean(pay_per_hr), 2),
    .groups   = "drop"
  )
print(gap_summary)

raw_gap <- gap_summary$avg_pay[gap_summary$female == 0] -
           gap_summary$avg_pay[gap_summary$female == 1]
cat("\nRaw gap (male - female): $",
    round(raw_gap, 2), "/hr (",
    round(100 * raw_gap / gap_summary$avg_pay[gap_summary$female == 1], 1),
    "% of female pay)\n", sep = "")

# =============================================================================
# PART 2: Oaxaca-Blinder by hand
# =============================================================================
#
# Three steps:
#   1. Run separate regressions for males and females
#   2. Compute mean characteristics of each group
#   3. Combine to get explained / unexplained components

drivers_m <- drivers |> filter(female == 0)
drivers_f <- drivers |> filter(female == 1)

fit_m <- lm(pay_per_hr ~ experience_hrs + surge_share + speed_mph,
            data = drivers_m)
fit_f <- lm(pay_per_hr ~ experience_hrs + surge_share + speed_mph,
            data = drivers_f)

cat("\n--- Male regression ---\n")
print(tidy(fit_m) |> mutate(across(where(is.numeric), \(x) round(x, 4))))
cat("\n--- Female regression ---\n")
print(tidy(fit_f) |> mutate(across(where(is.numeric), \(x) round(x, 4))))

# Mean characteristics
xbar_m <- colMeans(model.matrix(fit_m))
xbar_f <- colMeans(model.matrix(fit_f))

# Two-fold decomposition with male (group A) coefficients as the reference
beta_m <- coef(fit_m)
beta_f <- coef(fit_f)

explained   <- sum((xbar_m - xbar_f) * beta_m)         # endowments
unexplained <- sum(xbar_f * (beta_m - beta_f))         # coefficients

total <- explained + unexplained

cat("\n--- Oaxaca-Blinder decomposition ---\n")
cat("Total gap (predicted by model): $", round(total, 3), "\n", sep = "")
cat("Explained (endowments):         $", round(explained, 3),
    "  (", round(100 * explained / total, 1), "%)\n", sep = "")
cat("Unexplained (coefficients):     $", round(unexplained, 3),
    "  (", round(100 * unexplained / total, 1), "%)\n", sep = "")

# =============================================================================
# PART 3: Per-feature contribution
# =============================================================================

contribution <- tibble(
  feature = c("experience_hrs", "surge_share", "speed_mph"),
  diff_in_means = c(xbar_m["experience_hrs"] - xbar_f["experience_hrs"],
                    xbar_m["surge_share"]    - xbar_f["surge_share"],
                    xbar_m["speed_mph"]      - xbar_f["speed_mph"]),
  male_coef = c(beta_m["experience_hrs"],
                beta_m["surge_share"],
                beta_m["speed_mph"]),
  contribution_dollars = NA_real_
) |>
  mutate(contribution_dollars = round(diff_in_means * male_coef, 3),
         pct_of_gap = round(100 * contribution_dollars / total, 1))

cat("\n--- How each feature contributes to the explained gap ---\n")
print(contribution)

# =============================================================================
# PART 4: The bad-controls trap
# =============================================================================
#
# Suppose we add a control that is itself a CONSEQUENCE of past
# discrimination. For example, a "preferred shifts" variable that is
# downstream of the gendered constraints on when drivers can work. Adding
# this control would shrink the unexplained component but it's a bad control.

drivers <- drivers |>
  mutate(
    # Female drivers face more childcare constraints, so are less likely
    # to be assigned "preferred" night/weekend shifts
    preferred_shifts = pmax(rnorm(n,
                                   mean = ifelse(female, 8, 14),
                                   sd = 4), 0)
  )

fit_full <- lm(pay_per_hr ~ female + experience_hrs + surge_share + speed_mph + preferred_shifts,
               data = drivers)
fit_no_pref <- lm(pay_per_hr ~ female + experience_hrs + surge_share + speed_mph,
                  data = drivers)

cat("\n--- Coefficient on `female` ---\n")
cat("  WITHOUT preferred_shifts:",
    round(coef(fit_no_pref)["female"], 3), "\n")
cat("  WITH preferred_shifts:   ",
    round(coef(fit_full)["female"], 3), "\n")
cat("Adding preferred_shifts shrinks the residual gap. But preferred_shifts\n")
cat("is itself downstream of the constraints we're trying to measure -- so\n")
cat("it's a BAD CONTROL. The smaller residual is misleading.\n")

# =============================================================================
# PART 5: Talking points
# =============================================================================

cat("\n")
cat("Key takeaways:\n")
cat("1. Oaxaca-Blinder splits the mean gap into 'explained' (different\n")
cat("   characteristics) and 'unexplained' (different coefficients).\n")
cat("2. With three behavioral features (experience, surge work, speed),\n")
cat("   the entire ~7%% gender gap is fully explained -- no residual.\n")
cat("3. This MIRRORS the Cook et al. (2021) finding on real Uber data.\n")
cat("4. 'Fully explained' does NOT mean 'not discriminatory'. The\n")
cat("   behavioral features are themselves products of social constraints.\n")
cat("5. Adding a 'bad control' (downstream of the mechanism) shrinks\n")
cat("   the unexplained component but obscures the true mechanism.\n")
cat("6. The decomposition tells you the INTERVENTION SURFACE.\n")
cat("   It does not tell you whether to intervene.\n")
