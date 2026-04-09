# Module 3: Decomposition Methods (Cook et al. 2021 centerpiece)

## Quick Refresher

The previous module gave you a clean experimental tool for measuring
discrimination. The problem with that tool is that you usually can't run
it. Most data is observational, and the discrimination question is "given
this gap I see in the data, how much of it is discrimination?" This module
covers the **decomposition methods** that the labor economics literature
uses to answer that question — and uses the **Cook et al. (2021) Uber
gender pay gap paper** as the worked example.

You'll come out of this module with three things:

1. The Oaxaca-Blinder decomposition, intuitively and mechanically
2. The standard objections to it (and why "explained" doesn't mean
   "non-discriminatory")
3. A clean reading of the most-cited recent ride-sharing paper, which
   you should be able to discuss in an interview

---

## The Problem

You observe a gap. Group $A$ earns more than group $B$, on average:

$$
\bar Y_A - \bar Y_B = \text{(some positive number)}
$$

Some of that gap is because the two groups *differ in observable
characteristics* (experience, skill, hours worked). The rest is "everything
else" — which might be discrimination, or it might be unmeasured
characteristics. You want to split the gap into these two pieces.

This is what the **Oaxaca-Blinder** decomposition does. It is the most
widely-used tool in the labor-econ literature on wage gaps and has been
the workhorse for ~50 years.

---

## Oaxaca-Blinder, Mechanically

Run a separate linear regression of the outcome on observables for each
group:

$$
Y_A = \mathbf{X}_A \beta_A + u_A
\qquad\qquad
Y_B = \mathbf{X}_B \beta_B + u_B
$$

Now decompose the mean gap:

$$
\bar Y_A - \bar Y_B = \underbrace{(\bar{\mathbf{X}}_A - \bar{\mathbf{X}}_B) \hat\beta_B}_{\text{explained (endowments)}}
+ \underbrace{\bar{\mathbf{X}}_A (\hat\beta_A - \hat\beta_B)}_{\text{unexplained (coefficients)}}
$$

In words: take the mean gap, attribute the part that's explained by
**different observable characteristics** to "endowments", and the part
that's explained by **different return rates** on those characteristics to
"coefficients" — and call the second part the unexplained / discrimination
component.

Equivalently you can flip the reference group ($\hat\beta_A$ instead of
$\hat\beta_B$) — that's the "index number problem", and it's the first
warning sign.

**The intuition.** If group $B$ has 5 fewer years of experience and the
return to experience is $1,000 per year, then $5,000 of the gap is
"explained by experience". Whatever's left is the "unexplained" part.

---

## Why the "Unexplained" Part Is Not Discrimination

This is the most important point in the module. **The unexplained
residual is not the discrimination estimate.** It is the upper bound on
discrimination, *plus* the contribution of every variable you didn't
include, *plus* any non-linearity or interaction your model doesn't
capture, *plus* selection bias.

Three specific failure modes:

### 1. Omitted variables

If group $B$ has lower returns to experience because *they have less
exposure to advancement opportunities* (an unobservable), then your
"unexplained" residual contains that omitted variable. It's not really
discrimination, but it's also not "no discrimination."

### 2. "Bad controls"

Suppose you control for *occupation* in a wage gap study. If
discrimination affects which occupation you end up in, then controlling
for occupation **removes part of the discrimination** from your estimate.
You're now measuring "the gap conditional on the discriminatory sorting
that already happened." This is the bad-controls problem (Angrist &
Pischke 2009, ch. 3) and it's why decomposition results are sensitive to
which controls you include.

### 3. The interpretation gap

"Unexplained" is a statistical category. "Discrimination" is a normative
category. Translating between them requires a theory of which differences
between groups *should* affect the outcome and which shouldn't — a
question Oaxaca-Blinder doesn't answer.

> **Mantra:** *Explained ≠ non-discriminatory. Unexplained ≠ discriminatory.*

---

## Cook, Diamond, Hall, List & Oyer (2021)

This is the centerpiece of the module and the single most relevant paper
for an applied policy economist working at Uber.

**Title:** *The Gender Earnings Gap in the Gig Economy: Evidence from
over a Million Rideshare Drivers*

**Published:** Review of Economic Studies, 88(5), 2021.

**Authors:** Cody Cook, Rebecca Diamond, Jonathan Hall, John A. List,
Paul Oyer

**Data:** Uber's internal database — every Uber driver in the U.S. over
a roughly two-year period, ~1.8 million drivers, ~740 million trips.

### The headline result

Male drivers earn ~**7% more per hour** than female drivers. The gap is
robust across cities and time periods. This is large by gig-economy
standards and worth taking seriously.

The paper's whole point: *despite Uber's algorithm being almost
absolutely gender-blind*, a 7% pay gap exists. How?

### The decomposition

The authors decompose the gap into three components:

1. **Experience.** Male drivers have more accumulated hours on the
   platform → higher earnings per hour because experienced drivers
   pick better pickups, learn shortcuts, etc. **Roughly 1/3 of the gap.**
2. **Where and when** drivers choose to work. Male drivers are more
   likely to work in higher-surge times and locations. **Roughly 1/3.**
3. **Driving speed.** Male drivers drive ~2.2% faster than female
   drivers, on average. Faster driving → more trips per hour → more
   earnings per hour. **Roughly 1/3.**

Add up the three: the **entire 7% gap is explained**. There is no
"unexplained" residual.

### The clever bit

This is a setting where you have **almost no plausible omitted variables**:

- Uber doesn't show driver gender to riders, so no rider taste-based discrimination
- Uber's pricing/dispatch algorithm is gender-blind
- Pay is per-trip and based on distance, time, and surge — no negotiation
- Hiring is open: anyone with a license and a car can sign up

So the usual suspects of "unexplained" wage gaps (taste-based hiring,
negotiation, occupation sorting) are largely absent. The paper takes
advantage of this clean setting to show that *even without those
mechanisms*, you can get a 7% gender pay gap — through behavioral
choices that are themselves correlated with gender.

### What the paper claims

The paper is explicit that this is **not** an argument that "there's no
discrimination at Uber." It's an argument that **the standard
decomposition framework will mark a gap as fully explained even when the
underlying mechanism is socially meaningful.** Driving speed is correlated
with risk preferences, with childcare obligations (women drivers report
more time pressure to return home), with gendered patterns of leisure and
work.

If society wanted to *eliminate* the gap, the only available levers would
be:
- subsidize female drivers' experience accumulation (training, mentoring)
- subsidize female drivers' work in higher-paying times/locations (e.g.
  childcare during evening/night shifts)
- something about the speed difference, which is harder to act on

None of these are "stop discriminating" actions. They are policy
interventions that would change the *behavioral* gap.

### Why this matters for an applied policy economist

You will be asked some version of this question in your interview:

> "Uber has a 7% gender pay gap among drivers. Is that a problem?"

The right answer isn't "yes" or "no". The right answer is:

1. The platform algorithms are gender-blind, so it's not algorithmic discrimination in the usual sense.
2. The gap is fully decomposed by behavioral and tenure differences (Cook et al. 2021).
3. **The decomposition is not a license to ignore the gap.** Behavioral differences arise from social and structural conditions outside the platform.
4. If we want to change it, we need policy interventions targeting those upstream conditions — not algorithm changes.
5. The decomposition tells us the *intervention surface*. It does not tell us whether to intervene. That's a normative question.

---

## How to Read a Decomposition Result, Generally

When you see a paper that says "X% of the gap is unexplained":

1. **What's in the regression?** More controls = more "explained" by definition. The choice of controls is itself a normative judgment about which differences "shouldn't matter."
2. **Are any of the controls *bad controls*?** Anything downstream of the discriminatory mechanism eats into the estimate.
3. **What's the reference group?** Oaxaca-Blinder is sensitive to the choice of $\hat\beta_A$ vs $\hat\beta_B$ as the counterfactual. The "two-fold" decomposition ($\hat\beta_A$) and the "Reimers" / pooled-coefficients version can give different numbers.
4. **What's the implicit counterfactual?** "Unexplained" is shorthand for "the gap that would remain if we equalized observables." That's not always the policy question.
5. **What does the author say about the residual?** Honest authors are careful about the interpretation. Sloppy ones say "unexplained = discrimination" and walk away.

---

## How This Plays Out at Uber/Lyft

The Cook et al. (2021) paper is unusual because it had access to **internal
data** that's normally inaccessible. Most decomposition studies of
ride-sharing (or any platform) work from sample surveys and external
audits, which have a fraction of the power. The interesting empirical
question is now: *given clean platform data, what other gaps would
decomposition reveal?*

Some likely candidates:

- **Racial gaps in driver earnings**, conditional on hours and location.
  Documented in some external work (e.g., Hyman, Lewis, Patel & Yuksel 2022).
- **Geographic gaps in rider service quality**, conditional on tip,
  rating, and route. We saw this implicitly in the ML course as the
  per-neighborhood acceptance rate.
- **Surge pricing gaps** by neighborhood demographics — Pandey-Caliskan
  (2021) is a step in this direction (Module 4).
- **Driver rating disparities** that affect dispatch priority — there's
  an active debate about whether the rating system is gender- or race-
  neutral.

Each of these would yield to a Cook-et-al.-style decomposition if you had
the data.

---

## Exercise Preview

The Module 3 R exercise will:

1. Simulate a population of 5,000 Uber drivers with gender-correlated
   features (experience, location, speed)
2. Reproduce the basic Cook et al. (2021) finding: a ~7% gender gap that
   can be decomposed by these three features
3. Run a manual Oaxaca-Blinder decomposition step by step
4. Show the **bad-controls problem** by adding a "occupation tenure"
   variable that's downstream of the discriminatory mechanism
5. Discuss what each version of the result would let you say to a
   regulator

---

## Appendix: A Quick Algebra Refresher

For two groups with separate regressions $Y_g = \mathbf{X}_g \beta_g$, the
mean gap is:

$$
\Delta = \bar Y_A - \bar Y_B = \bar{\mathbf{X}}_A \hat\beta_A - \bar{\mathbf{X}}_B \hat\beta_B
$$

Add and subtract $\bar{\mathbf{X}}_B \hat\beta_A$ (or $\bar{\mathbf{X}}_A \hat\beta_B$):

$$
\Delta = (\bar{\mathbf{X}}_A - \bar{\mathbf{X}}_B) \hat\beta_A + \bar{\mathbf{X}}_B (\hat\beta_A - \hat\beta_B)
$$

Two interpretations:

1. **Endowments (E):** what $A$ would earn if it had $B$'s
   characteristics, holding $A$'s coefficients fixed
2. **Coefficients (C):** what $B$ would earn if it had $A$'s coefficients,
   holding $B$'s characteristics fixed

If you swap which group's coefficients you use as the reference, you get
a *different* decomposition. There are three popular conventions:

- **$\beta_A$** as the counterfactual (above)
- **$\beta_B$** as the counterfactual (similar formula, with sub indices flipped)
- **Pooled $\beta$** from a regression with a group dummy (Reimers 1983,
  Cotton 1988, Neumark 1988)

The "right" choice is a normative call. There is no statistical fact of
the matter.
