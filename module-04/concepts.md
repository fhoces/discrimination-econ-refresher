# Module 4: Algorithmic Audits

## Quick Refresher

The audit studies in Module 2 are the gold standard for causal
identification of discrimination, but they're expensive, ethically
constrained, and limited to the specific gatekeeper behavior you can
manipulate. The decomposition methods in Module 3 are cheap but
methodologically fraught — they conflate "explained" with
"non-discriminatory."

This module covers the **third major approach**: algorithmic audits.
Instead of auditing a *human* gatekeeper, you audit an *algorithm*. The
algorithm is the gatekeeper now — it sets prices, dispatches drivers,
matches riders, suggests pay rates. You can audit it from the **outside**
(as an external researcher with scraped data) or from the **inside** (as
an internal economist with access to ground truth).

The two ride-sharing studies that anchor this module:

1. **Pandey & Caliskan (2021)** — disparate impact of pricing algorithms
2. **Chen, Mislove & Wilson (2015)** — *Peeking Beneath the Hood of Uber*,
   the original surge-pricing audit

Plus the methodological question that runs through both: **how do you
audit a black-box pricing system from outside?**

---

## What's Different About Auditing an Algorithm

A traditional audit (Bertrand-Mullainathan, Ge et al.) targets a *person*
making a discrete decision. An algorithmic audit targets a *function*:
some mapping from inputs to a decision (price, match, score, dispatch).
This shifts the methodology in three ways.

### 1. The "manipulation" is querying the system, not deceiving a person

You don't need to defraud anyone. You feed the algorithm different
inputs and observe the outputs. This dramatically lowers the ethical
and legal cost.

### 2. You can run *millions* of queries

A traditional audit is bottlenecked by the cost of constructing matched
pairs and waiting for callbacks. An algorithmic audit only needs an
API endpoint or a way to scrape the system. The Pandey-Caliskan paper
analyzes ~100 million Chicago trip records.

### 3. The "matched pair" is no longer a person — it's a counterfactual query

You ask: *what would the algorithm have done if everything were the same
except this one feature?* This is exactly the counterfactual that
algorithmic-fairness methods (Module 7 of the ML course) try to compute.
Algorithmic audits are the empirical version of those methods.

The catch: you usually don't *control* the inputs. You observe what real
users get. This means you're back in regression-and-controls territory
for identification, with all the bad-controls problems that implies.

---

## Pandey & Caliskan (2021)

**Title:** *Disparate Impact of Artificial Intelligence Bias in
Ridehailing Economy's Price Discrimination Algorithms*

**Venue:** AIES (AAAI/ACM Conference on Artificial Intelligence, Ethics,
and Society), 2021.

**Setting:** Chicago. The city of Chicago publishes anonymized
ride-hailing trip data, which includes fare, distance, duration, pickup
and dropoff census tracts, and a few other fields.

**The audit question:** *Are pickup or dropoff areas with higher minority
populations charged more per mile for equivalent trips?*

### The design

This is a **shadow audit**, not a matched-pair audit. The authors don't
manufacture rides — they analyze the public trip data and:

1. Compute fare per mile for each trip
2. Merge trips with census-tract demographics (% minority, median income,
   etc.)
3. Regress fare-per-mile on demographic features, controlling for
   distance, duration, time of day, and other observables
4. Look at the coefficient on the demographic feature

The methodology is essentially Module 1's "regression with controls"
applied to the algorithm's outputs rather than to a human decision.

### The results

After controlling for trip characteristics, **trips with pickup or
dropoff in census tracts with a higher non-white population have higher
fare per mile**. The effect is statistically significant and economically
meaningful (a few percentage points).

**The mechanism is implicit.** The Uber surge-pricing algorithm uses
real-time supply-and-demand signals. In neighborhoods with thinner driver
supply, prices surge more often. Driver supply is correlated with
neighborhood demographics (because of past structural patterns, including
historical redlining and current urban form). So the surge signal is
correlated with race even though the algorithm never reads "race."

This is **statistical discrimination by an algorithm**, mediated by a
proxy. Phelps's model running in real time, on a system that processes
millions of price decisions a day.

### What this paper is and isn't

**What it identifies.** A correlation between census-tract demographics
and price-per-mile, conditional on observable trip features. This is
documenting *disparate impact*.

**What it doesn't identify.** The causal mechanism. The paper can't
distinguish "the algorithm rationally responds to genuine supply-demand
gaps" from "the algorithm's training data encoded historical bias" from
"any number of other stories." The correlation is robust; the
interpretation is contested.

**What it's good for.** Producing a quantitative claim that can be
debated by regulators, journalists, and platform employees. The paper
sparked policy attention to the question of whether ride-hail pricing
should be subject to disparate-impact audits.

---

## Chen, Mislove & Wilson (2015)

**Title:** *Peeking Beneath the Hood of Uber*

**Venue:** Internet Measurement Conference (IMC '15)

**Setting:** New York and San Francisco, on Uber's surge-pricing system.

**The original goal:** measure how Uber's surge-pricing algorithm worked.
Not technically a *discrimination* study, but the methodology became the
template for everything that followed.

### The design

The researchers used a **measurement infrastructure** they built around
Uber's app. They polled the surge multipliers and driver counts in
hundreds of locations across the two cities, every few seconds, for
weeks. They recorded:

- Surge multiplier as a function of time and location
- Driver count in each cell
- The spatial structure of surge (small "cells" with sharp boundaries)

### The findings

- Surge pricing is **highly localized**: cells of about 0.5 km × 0.5 km,
  each with its own surge multiplier
- Surge changes **rapidly**: typical durations of 5-10 minutes
- Surge *does* increase driver supply over time, but the effect is small —
  most of the rebalancing happens because riders cancel
- The algorithm appeared to use simple rules at the time

### Why this matters for our story

The methodological contribution: **you can audit a black-box pricing
system using only the public-facing API**. Chen et al. didn't need
internal Uber data; they used the rider-app's public surge query and
constructed a synthetic dataset of millions of observations.

This is the template that subsequent algorithmic-audit work has built on.
Pandey & Caliskan extended the idea to public trip records; later work
has used the Uber app, Lyft's web interface, ride-share aggregators, and
ad-hoc HTTP scraping.

---

## How to Audit a Black-Box Pricing Algorithm

If you walk into an Uber interview and they ask "how would you audit our
pricing algorithm for disparate impact," here's the answer.

### Step 1: define the disparate-impact question precisely

"Higher prices for minority riders" can mean a dozen different things.
You need to pin down:

- **Whose price?** Rider or driver?
- **Per what?** Per trip, per mile, per minute, per hour of service?
- **Conditional on what?** Distance, duration, time, route quality?
- **Compared to what?** A counterfactual where the demographic feature
  is changed, or a different geographic stratum?

### Step 2: pick the data source

Internal: trip log, dispatch log, surge log, demographics linked from
external sources (Census, ACS).

External: scraped surge data, public city ride-hail data (Chicago, NYC),
ride-share aggregators.

### Step 3: pick the comparison

Three flavors:

1. **Within-trip comparison:** what would this trip's price have been if
   the pickup were in a different demographic neighborhood, holding
   distance/time constant? (Counterfactual via a model.)
2. **Within-rider comparison:** does the same rider get systematically
   different prices in different neighborhoods? (Within-rider FE.)
3. **Cross-sectional regression:** simple OLS of price on demographics
   with controls. (Pandey-Caliskan style.)

The first two are stronger; the third is what most external auditors can
actually do.

### Step 4: report carefully

The honest report includes:

- The point estimate, the SE, and the model spec
- A robustness table varying the controls
- The interpretation (correlation, not causation)
- The power calculation (how much would the result need to be off for
  the conclusion to flip?)
- The downstream policy lever (if the result is real, what would you do
  about it?)

The bad version of the report is "we found the algorithm is racist" with
no caveats.

---

## What External vs Internal Audits Can and Can't Do

The core asymmetry: as an external researcher you have a **clean** but
**limited** dataset; as an internal researcher you have a **messy** but
**comprehensive** one.

| | External | Internal |
|---|---|---|
| Sample | Small, biased toward queryable behavior | Universe of decisions |
| Variables | Public observables | Everything the system uses |
| Counterfactuals | Hard (need a model) | Easy (run an A/B test) |
| Mechanism identification | Hard | Hard but easier |
| Reportability | Free to publish | Constrained by IP / legal / PR |
| Can test policy fixes? | Indirectly | Directly |

The interesting move for an internal economist is to **bring the
external auditor's questions in-house** — running the disparate-impact
analyses that an outside researcher *would* run, but with the internal
data and the ability to ship fixes.

---

## How This Plays Out at Uber/Lyft (For Real)

The post-Pandey-Caliskan world has seen:

1. **Internal disparate-impact audits** at major platforms. These are
   typically not published. You can occasionally see them through
   regulatory filings or leaked memos.
2. **Settlement of lawsuits** based on external audits. The audits are
   used as evidence, not always conclusively.
3. **Pressure on the algorithm design** — some platforms have changed
   how surge zones are computed to reduce demographic correlation.
4. **A growing professional class** of internal auditors and policy
   economists at major platforms, of which the Uber Policy Economist
   role is one example.

When you walk into the interview, the value you bring is exactly this
hybrid skill: the ability to **read external audits like a critic** and
to **run internal audits like an analyst**.

---

## Exercise Preview

The Module 4 R exercise will:

1. Simulate a stylized surge-pricing system across many neighborhoods
   with demographics that differ by race
2. Inject a *purely supply-demand* surge mechanism (no race in the model)
3. Show that the resulting prices have a non-zero coefficient on
   neighborhood demographics — the Pandey-Caliskan result, in miniature
4. Try to "fix" the algorithm two ways:
   - Remove the surge multiplier (and watch revenue drop)
   - Cap the surge differential across neighborhoods (and watch the
     demographic coefficient shrink)
5. Compute the **disparate impact ratio** under each version and discuss
   the policy tradeoff
