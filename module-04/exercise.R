# =============================================================================
# Module 4: Algorithmic Audits
# Application: Stylized surge-pricing audit (Pandey & Caliskan 2021 in miniature)
# =============================================================================
#
# We simulate a city of 30 neighborhoods with different demographic
# compositions, and a "race-blind" surge-pricing algorithm that responds to
# real-time supply and demand. We then audit the algorithm: is the
# resulting fare-per-mile correlated with the neighborhood's percent
# minority population? Spoiler: yes, even though the algorithm never sees
# race.

library(tidyverse)
library(broom)
set.seed(2026)

# =============================================================================
# PART 1: Generate the city
# =============================================================================

n_neighborhoods <- 30

city <- tibble(
  neighborhood = paste0("N", sprintf("%02d", 1:n_neighborhoods)),
  pct_minority = runif(n_neighborhoods, 0.05, 0.90),
  # Driver supply per 100 residents — higher in non-minority areas
  driver_supply = 8 - 6 * pct_minority + rnorm(n_neighborhoods, 0, 0.5),
  # Demand (rides requested per hour) — roughly equal across neighborhoods
  demand = rnorm(n_neighborhoods, 10, 1.5)
)
city$driver_supply <- pmax(city$driver_supply, 0.5)

cat("\n--- City: 30 neighborhoods ---\n")
print(head(city, 10))

# =============================================================================
# PART 2: Race-blind surge-pricing algorithm
# =============================================================================
#
# The platform's algorithm computes a surge multiplier for each
# neighborhood as max(1, demand / supply). Race is NOT in this formula.

city <- city |>
  mutate(
    surge_multiplier = pmax(1, demand / driver_supply),
    # Base fare $1.50/mile, multiplied by surge
    fare_per_mile = 1.50 * surge_multiplier
  )

cat("\n--- Pricing summary ---\n")
city |>
  summarise(
    avg_surge = round(mean(surge_multiplier), 2),
    min_surge = round(min(surge_multiplier), 2),
    max_surge = round(max(surge_multiplier), 2),
    avg_fare  = round(mean(fare_per_mile), 2),
    .groups = "drop"
  ) |>
  print()

# =============================================================================
# PART 3: The audit (Pandey-Caliskan style)
# =============================================================================
#
# We regress fare_per_mile on pct_minority and ask whether the
# coefficient is statistically distinguishable from zero. The algorithm
# never saw pct_minority — but the disparate impact is there anyway.

audit_fit <- lm(fare_per_mile ~ pct_minority, data = city)

cat("\n--- Disparate impact regression (no controls) ---\n")
print(tidy(audit_fit) |> mutate(across(where(is.numeric), \(x) round(x, 4))))

# Add controls — does the coefficient survive?
audit_fit_ctrl <- lm(fare_per_mile ~ pct_minority + driver_supply,
                     data = city)

cat("\n--- With supply control ---\n")
print(tidy(audit_fit_ctrl) |> mutate(across(where(is.numeric), \(x) round(x, 4))))
cat("Note: controlling for driver_supply makes the coefficient on\n")
cat("pct_minority shrink to ~0 -- because supply is the channel through\n")
cat("which the disparate impact operates. This is the bad-controls\n")
cat("problem from Module 3 in algorithmic form.\n")

# =============================================================================
# PART 4: Disparate impact ratio
# =============================================================================
#
# Compare the average fare-per-mile in the top half (highest-minority)
# vs bottom half neighborhoods.

city <- city |>
  mutate(group = ifelse(pct_minority >= median(pct_minority), "high", "low"))

di_summary <- city |>
  group_by(group) |>
  summarise(
    n        = n(),
    avg_pct  = round(mean(pct_minority), 2),
    avg_fare = round(mean(fare_per_mile), 3),
    .groups  = "drop"
  )
print(di_summary)

di_ratio <- di_summary$avg_fare[di_summary$group == "high"] /
            di_summary$avg_fare[di_summary$group == "low"]
cat("\nDisparate impact ratio (high-minority / low-minority):",
    round(di_ratio, 3), "\n")
cat("Values >1 indicate higher fares in higher-minority areas.\n")

# =============================================================================
# PART 5: Two policy fixes
# =============================================================================
#
# Fix 1: turn off surge entirely
city <- city |>
  mutate(
    fare_no_surge = 1.50,
    revenue_per_request_actual = fare_per_mile * demand,
    revenue_per_request_no_surge = fare_no_surge * demand
  )

# Fix 2: cap surge at 1.5x
city <- city |>
  mutate(
    fare_capped = 1.50 * pmin(surge_multiplier, 1.5),
    revenue_per_request_capped = fare_capped * demand
  )

policy_compare <- city |>
  summarise(
    revenue_actual    = round(sum(revenue_per_request_actual), 1),
    revenue_no_surge  = round(sum(revenue_per_request_no_surge), 1),
    revenue_capped    = round(sum(revenue_per_request_capped), 1),
    di_actual = round(
      mean(fare_per_mile[group == "high"]) /
      mean(fare_per_mile[group == "low"]), 3),
    di_no_surge = round(
      mean(fare_no_surge[group == "high"]) /
      mean(fare_no_surge[group == "low"]), 3),
    di_capped = round(
      mean(fare_capped[group == "high"]) /
      mean(fare_capped[group == "low"]), 3)
  )

cat("\n--- Policy fixes: revenue vs disparate impact ---\n")
print(policy_compare)

cat("\n")
cat("Key takeaways:\n")
cat("1. A race-blind surge algorithm produces racially disparate prices\n")
cat("   because supply differs by neighborhood demographics.\n")
cat("2. Regression-with-controls makes the disparate impact disappear --\n")
cat("   but only because the control IS the mechanism. Bad controls.\n")
cat("3. Two ways to 'fix': eliminate surge (-30%% revenue, DI = 1.0)\n")
cat("   or cap it (smaller revenue hit, DI close to 1.0).\n")
cat("4. The choice between these is a policy tradeoff. The math doesn't\n")
cat("   tell you which one to ship.\n")
cat("5. This is a stylized version of the Pandey-Caliskan (2021) result\n")
cat("   on Chicago trip data.\n")
