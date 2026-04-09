# Module 2: Audit & Correspondence Studies

## Why Audit Studies Exist

Module 1 ended with a frustration: pure regression with controls can't
distinguish "no discrimination" from "discrimination perfectly mediated by
proxy features." This isn't a fixable limitation — it's a fundamental
identification problem. If race influences neighborhood and neighborhood
influences acceptance, then *controlling for neighborhood* removes the very
channel through which race operates.

The solution is to **manufacture variation in the protected attribute**
that is uncorrelated with everything else. That's exactly what audit studies
do. They are the empirical workhorse of the modern discrimination literature
because they are the only design that gives you a clean causal estimate
without strong structural assumptions.

This module covers:

1. The matched-pair audit design (Bertrand-Mullainathan 2004 as the methodological reference)
2. Ge et al. (2016) — the Uber/Lyft audit that documented racial discrimination by drivers
3. What audits identify, what they don't, and the standard threats to validity
4. Modern variants: shadow audits, scraped audits, platform-internal A/B-style audits

---

## The Matched-Pair Audit Design

**Goal:** measure the causal effect of perceived group membership on a
treatment decision.

**Method:**

1. Construct two profiles, $A$ and $B$, that are **identical** on every
   observable characteristic *except* the protected attribute (or its proxy)
2. Submit both profiles to the same gatekeeper (employer, driver, landlord,
   loan officer)
3. Record the decision (interview / acceptance / approval)
4. Compare the rates

Because the only difference between the two profiles is the protected
attribute, *any* difference in outcomes can be causally attributed to it.
You don't need to control for anything — the design handles confounding by
construction.

**The famous example: Bertrand & Mullainathan (2004).** Researchers sent
~5,000 résumés in response to job postings in Boston and Chicago. The
résumés were randomized on:

- Name (stereotypically white: Emily, Greg; or stereotypically Black: Lakisha, Jamal)
- Quality (high or low: presence of relevant skills, certifications, longer experience)
- Address, gender markers, and other small details

**Result:** white-named résumés got ~50% more callbacks than identical
Black-named résumés. The premium for being "high quality" was *much
larger* for white-named résumés than for Black-named ones, suggesting
that Black candidates couldn't compensate via credentials.

**Why this design is powerful:**

- It's a **randomized experiment**, which means the only assumption you
  need is that the experimental manipulation worked (the gatekeeper
  perceived the assigned race)
- It identifies the **causal effect of perceived group membership**,
  conditional on everything else the gatekeeper sees
- It works even when the discrimination is small relative to the noise
  in the labor market — you just send more résumés

**Why it's still controversial:**

- It identifies **discrimination at the call-back margin**, not at hiring,
  promotion, or wage-setting
- It can't distinguish taste-based from statistical (a Bayesian employer
  might rationally update on the name as a signal of group membership)
- It tells you nothing about *what would happen* if you eliminated the
  discrimination — the equilibrium effects of policy changes are
  fundamentally outside the audit framework

---

## Ge et al. (2016): The Uber/Lyft Field Experiment

This is the canonical ride-sharing audit study and the centerpiece of this
module.

**Title:** *Racial and Gender Discrimination in Transportation Network
Companies*

**Authors:** Yanbo Ge, Christopher R. Knittel, Don MacKenzie, Stephen Zoepf

**Setting:** Boston (UberX) and Seattle (UberX, Lyft, Flywheel)

**Sample:** Roughly 1,500 ride requests across the two cities, with
matched profiles

### The design

Researchers (RAs from local universities) created Uber and Lyft accounts
with profile names that signaled race:

- **"White" profiles:** stereotypically white names (e.g., "Allison")
- **"African-American" profiles:** stereotypically African-American
  names (e.g., "Aaliyah")

The RAs followed pre-specified routes within each city. At each pickup
point, an RA from each profile group made a request from the same
location at the same time. The researchers recorded:

- Whether the ride was cancelled
- Wait time before pickup
- Total trip time
- Cost

**Sample sizes were small** (a few hundred rides per profile group), but
the differences were large.

### The headline results

- **Boston, UberX:** Cancellation rate **10.1%** for African-American
  male riders vs **4.9%** for white male riders. About **2× higher.**
- **Boston, female riders:** also higher cancellations for African-American
  female riders, plus longer travel times — the researchers attribute
  some of this to drivers taking longer (less direct) routes
- **Seattle, UberX:** Wait time was **~30% longer** for African-American
  riders, even though Uber doesn't show driver names/photos to riders
  prior to acceptance

### What this is and isn't

**What it identifies.** The causal effect of the *perceived* race of the
rider on the driver's cancellation and wait-time behavior. Because the
rider profiles are otherwise matched, no confounding story explains the
gap.

**What it doesn't identify.**

- **Mechanism.** Is this taste-based (Becker) or statistical (Phelps —
  drivers using race as a signal of trip risk)? The paper can't tell
  these apart, and the authors are careful about the interpretation.
- **Aggregate impact.** The audit measures discrimination *per ride
  request*. It doesn't tell us how many minority riders get the worse
  experience in equilibrium, because riders may adapt (give up earlier,
  switch services, etc.).
- **Counterfactual policy.** It tells us discrimination *exists* in the
  current platform design. It doesn't tell us what banning name display
  or photos would do — Uber doesn't show those to drivers pre-acceptance
  in many markets, and the discrimination persists anyway.

### The clever bit

For the Seattle results, riders' names are *not* shown to drivers before
they accept. The discrimination still happens. **How?**

The likely answer: drivers are using the **pickup neighborhood** as a
proxy. This is *exactly* the Phelps story from Module 1, embedded in
hard data. The driver doesn't see the rider's race directly, but uses
neighborhood-based statistical inference. Cancellation happens after the
driver sees the destination address, which can also signal race.

This finding made the paper much more important — it showed that even
"anonymized" matching can produce racially disparate outcomes via
correlated features. It's the empirical anchor for everything in the
algorithmic-fairness literature that followed.

---

## What Audits Can and Can't Identify

A practical taxonomy:

| Question | Audit answers? |
|---|---|
| Is there a *causal* effect of perceived group membership on the decision, conditional on observables? | **Yes** |
| Is the discrimination taste-based or statistical? | **No** (you need additional structure) |
| Does the discrimination persist in equilibrium? | **No** (riders/workers may adapt) |
| Would policy X eliminate it? | **No** (equilibrium effects are outside the audit) |
| Is the gap "fair" given some normative criterion? | **No** (audits are positive, not normative) |
| How big is the *aggregate* welfare loss? | **No** (need a model of selection and adaptation) |

The right way to read an audit study: as a clean documentation of the
existence and magnitude of the discrimination, *without* strong claims
about mechanism or policy.

---

## Standard Threats to Validity

When you read or design an audit study, here's the checklist:

### 1. The manipulation must actually work

If the gatekeeper can't tell the difference between the two profile types,
you're measuring nothing. (Audit studies that use names verify this with
follow-up surveys or pilot data on name perception.)

### 2. The profiles must be matched on everything else

This is harder than it sounds. In Bertrand-Mullainathan, "Lakisha" might
trigger different inferences about *socioeconomic background* in addition
to race. The researchers controlled for this with manipulation checks but
the criticism survived. In Ge et al., the rider's photo is randomized too,
to avoid confounding with attractiveness.

### 3. The sample of gatekeepers must be representative

If you only audit gatekeepers in one region or one segment of the market,
you can't generalize. Ge et al. only covered Boston and Seattle; the
Pandey-Caliskan paper (Module 4) extends to a wider geography.

### 4. The decision being measured must be the one that matters

Bertrand-Mullainathan identifies discrimination *at the callback*. If
discrimination shifts to the interview or the hire stage, the audit
misses it. (Subsequent work by Pager, Western, Bonikowski (2009) ran an
in-person audit for the hire stage.)

### 5. Ethical and legal constraints

Audit studies essentially defraud the gatekeeper. IRB approval is
non-trivial and the legal status of audit studies in some jurisdictions
is contested. Ge et al. minimized harm by completing the rides and paying
the drivers; some in-person audit studies have run into legal trouble.

---

## Modern Variants

### Shadow / scraped audits

Instead of submitting fake profiles, scrape the platform's public
behavior for many real users and *infer* the protected attribute from
proxies (name, location, photo). The Pandey-Caliskan (2021) paper on
ride-hail pricing uses this approach because they can't submit thousands
of fake ride requests for ethical reasons.

**Tradeoff:** you get more data and don't defraud anyone, but the
identification of the protected attribute is now noisy, and you have to
control for confounders the way a regression does — you've lost the
clean experimental variation.

### Platform-internal A/B-style audits

If you work *inside* the platform, you have access to ground truth
demographic data and a randomization mechanism (the platform's own A/B
infrastructure). You can run experiments that vary specific aspects of
the algorithm and measure the impact on different groups directly.

This is what an internal economist at Uber or Lyft actually does. You
don't need to manufacture the variation — the platform creates it for
you, every time it ships an experiment. The challenge is *not* the
identification; it's getting the platform to ship experiments designed
to detect discrimination, and getting the results published.

### Algorithmic counterfactual audits

Take the model itself and ask: if I changed only the protected attribute
(or its strongest proxy), how would the prediction change? This is
essentially Phelps's Bayesian update made concrete and is the basis of
many of the methods in the ML fairness literature (Module 7 of the ML
course).

---

## How This Plays Out at Uber/Lyft

The post–Ge et al. world has seen several rounds of platform response:

1. **Uber removed driver-visible rider photos** in some markets after the
   paper. Discrimination persisted (via neighborhood and other proxies).
2. **Cancellation penalties** were introduced and then weakened in
   response to driver pushback. Driver cancellation remains the easiest
   discriminatory action because the cost is small.
3. **Algorithmic dispatch** has become the dominant matching mechanism,
   which moves the discrimination from individual driver decisions to
   the model itself — and that's where Modules 4 and 5 pick up.
4. **Internal audit teams** at major platforms now run regular audits
   of pricing and dispatch for disparate impact. The findings are
   typically not published, which is part of why the external literature
   relies so heavily on shadow audits.

---

## What to Watch For

When you see an audit-study claim:

- **What was randomized?** (The protected attribute, or just a proxy?)
- **What's the manipulation check?** (How do we know the gatekeeper saw what we intended?)
- **What's the outcome being measured?** (Callback ≠ hire ≠ wage.)
- **What's the sample of gatekeepers?** (One employer, one city, one platform?)
- **How are the authors interpreting "mechanism"?** (Are they careful about Becker vs Phelps, or sloppy?)

---

## Exercise Preview

The Module 2 R exercise will:

1. Simulate a stylized version of the Ge et al. (2016) design with two
   rider profiles ($A$ and $B$) and a population of drivers
2. Inject driver-level discriminatory cancellation behavior
3. Compute the audit estimator (mean cancellation rate gap) and its
   standard error
4. Show how the **statistical power** of the audit depends on the
   sample size and the magnitude of the discriminatory effect
5. Conclude with a back-of-envelope calculation: how many ride requests
   would you need to detect a cancellation gap of 5 percentage points
   with 80% power?
