# Module 1: Theory Primer — Becker and Phelps

## Quick Refresher

You read Borjas a long time ago. Here's the fast version of the two
theoretical models that everyone in the labor-econ literature on
discrimination still cites — Becker (1957) and Phelps (1972). We'll do
intuition only; full derivations live in the appendix at the end.

Both models try to answer the same question: *why does an economic agent
treat one group differently from another even when they have the same
productivity?* They give two very different answers, with very different
policy implications.

---

## Becker (1957): Taste-Based Discrimination

**The idea.** Some agent — an employer, a coworker, or a customer — has a
**preference** against interacting with members of group $B$. This is
modeled as a "discrimination coefficient" $d$: the agent acts as if hiring
(or working with, or buying from) a $B$-type costs an extra $d$ over the
nominal price.

So if the market wage of an $A$-type and a $B$-type are both $w$, the
prejudiced employer treats the $B$-type as costing $w(1 + d)$ and only
hires them if their productivity advantage is large enough to compensate.

**Three flavors:**

| Source | Who has the taste | Mechanism |
|---|---|---|
| Employer | The hiring manager | Won't hire $B$ even if productive |
| Coworker | $A$-type employees | Demand a wage premium to work alongside $B$ |
| Customer | The consumer | Won't buy from a $B$-type |

**The famous prediction.** In a competitive market, taste-based
discrimination should be **eroded by competition**. A non-discriminating
employer can hire $B$-types at the prevailing $B$ wage and undercut the
prejudiced employer. Over time, prejudiced firms get out-competed.

**The famous problem with the prediction.** In practice, taste-based
discrimination *persists*. Why? Several answers, none fully satisfying:

1. **Customer discrimination** — if customers themselves are prejudiced,
   the firm has a *profit* reason to discriminate, and competition makes it
   *worse*, not better
2. **Coworker discrimination** — the firm faces a wage premium for mixed
   workplaces, so segregation (within the firm or across firms) survives
3. **Search frictions and matching costs** — markets aren't actually
   frictionless, so prejudiced employers don't pay the full cost of their
   tastes
4. **Information barriers** — see Phelps below

**Ride-sharing application: customer taste-based discrimination.**

The Ge et al. (2016) field experiment is essentially a clean test of
*customer* taste-based discrimination on Uber and Lyft. Researchers
created rider profiles with stereotypically white and stereotypically
African-American–sounding names and submitted ride requests in Boston
and Seattle. **Cancellation rates were ~2× higher** for African-American
riders. Wait times were also longer.

This fits Becker's model **exactly**: drivers are the "consumers" of the
ride request, and they're acting on a taste-based preference even though
the rider's productivity (the fare paid) is identical. Note also that
competition does *not* erase this — drivers face essentially no penalty for
cancelling, and Uber's algorithm at the time didn't punish individual
discriminatory cancellations because they were within tolerated rates.

> **Key takeaway.** Becker tells you what taste-based discrimination *is*
> and predicts that competition should eliminate it. The fact that we
> *still see it* in markets like ride-sharing tells us something about
> what's broken in the competitive-market assumption — usually that the
> "consumer" is the one with the taste, or that the algorithm tolerates
> low-cost discriminatory actions.

---

## Phelps (1972): Statistical Discrimination

**The idea.** Forget tastes. Suppose the employer is *perfectly fair* but
faces a signal-extraction problem: each candidate has a noisy signal of
productivity (test score, résumé, interview) and the employer has to make
a Bayesian update about their true type. If the **prior** distribution
over productivity differs across groups — say, group $A$ has a higher
mean — then *for the same observed signal*, the employer's posterior
estimate is higher for $A$-types than for $B$-types.

So the employer rationally pays $A$-types more even though they're
"non-prejudiced." This is **statistical discrimination**: discrimination
that arises from rational use of group information when individual
information is imperfect.

**Two distinct mechanisms:**

1. **Different group means.** Group $A$'s productivity distribution is
   centered higher (for whatever historical or contextual reason). The
   Bayesian update is the obvious one.
2. **Different signal precision.** Group $A$ and $B$ have the *same* mean
   productivity, but the test/résumé/interview is noisier for $B$-types.
   The Bayesian employer puts more weight on the prior for $B$-types and
   less on the noisy signal — which means $B$-types' productive
   individuals get penalized more for having less-informative signals.

**The famous extension: Coate-Loury (1993) self-fulfilling prophecy.** If
employers expect $B$-types to be less productive, then $B$-types
rationally invest *less* in skill (because the return is lower under the
discriminatory equilibrium), which justifies the employer's belief. There
can be multiple equilibria: a "good" one where everyone invests and
everyone is paid fairly, and a "bad" one where group $B$ doesn't invest
and gets paid less. Both are consistent with rational behavior.

**Why this matters more than Becker for the algorithmic age.** Modern
prediction systems are *literally* statistical discrimination engines.
They take a noisy signal (your features), update against a prior
estimated from training data, and output a decision. If the training data
has different distributions across groups, the model will rationally
treat them differently — *exactly as Phelps describes*. The model isn't
prejudiced; it's optimizing.

**Ride-sharing application: driver acceptance models.**

Module 2 of the ML course (linear models) showed how a race-blind
logistic regression learns to use **neighborhood** as a proxy for
acceptance probability. From the model's point of view this is just good
statistics — neighborhood is informative, the model is unbiased
conditional on its features. But from a Phelps perspective the situation
is exact:

- The model assigns a posterior probability of acceptance to each ride
- That posterior depends on the prior distribution observed during training
- The prior differs by neighborhood (because base rates of acceptance
  genuinely differ)
- Therefore the posterior differs systematically by neighborhood, which
  correlates strongly with race

The model is statistically discriminating — perfectly, rationally, in the
sense Phelps had in mind in 1972. The question for us as economists is
whether we should *care* about that, given that it's "just" Bayesian
updating. Most modern policy frameworks (e.g., the disparate-impact
doctrine in U.S. employment law) say yes.

> **Key takeaway.** Phelps tells you that discrimination can arise even
> with perfectly rational, perfectly fair agents. The mechanism is the
> *use of group information in noisy decisions*. Algorithmic systems are
> the purest possible implementation of this model; if you want to argue
> against algorithmic discrimination, you can't just say "the model is
> rational" — Phelps's model is also rational.

---

## Becker vs. Phelps: How to Tell Them Apart Empirically

This matters for an applied policy economist, because the *policy fix* is
different.

| | Becker (taste-based) | Phelps (statistical) |
|---|---|---|
| Cause | Prejudice / preference | Rational use of imperfect information |
| Eliminated by competition? | In theory, yes (in practice, often no) | No — rational firms keep doing it |
| Disappears with better signals? | No | Yes — better individual data shrinks the role of priors |
| Disappears with affirmative action? | Eventually | Can create a new equilibrium (Coate-Loury) |
| Profit cost to the discriminator | Yes | No |
| Empirical fingerprint | Higher returns to non-discriminatory firms | Patterns that scale with signal noise / prior gaps |

The two models are not mutually exclusive — both forces probably operate
in any real market. The empirical literature has spent decades trying to
*decompose* observed gaps into "taste-based" and "statistical" portions,
with limited success. We'll see this in Module 3 (decomposition methods).

---

## How This Plays Out at Uber/Lyft

1. **Customer-side taste-based** (Becker, customer flavor) — drivers
   discriminating against riders by name, photo, neighborhood. Documented
   in Ge et al. (2016). Low-cost discriminatory action, no profit penalty.
2. **Algorithmic statistical** (Phelps) — pricing, dispatch, and
   acceptance models that use proxies correlated with race. The platform
   is "rationally" using information; the result is disparate impact.
3. **Driver-side worker decisions** (a hybrid case) — the Cook et al.
   (2021) gender pay gap study (Module 3) finds the entire ~7% gap is
   "explained" by behavioral differences. The interpretation is contested
   precisely because "explained" doesn't mean "non-discriminatory" — the
   behavioral differences themselves may be products of the same
   underlying forces Becker and Phelps described.

---

## What to Watch For

When you're reading a paper or auditing a system, ask:

- Is the discriminator a **person** or an **algorithm**? (Becker is more
  natural for the former, Phelps for the latter, but both apply to both.)
- Does the discriminator have a **profit reason** to do it? (If yes,
  Becker's competitive-erosion prediction won't work and the discrimination
  is more durable.)
- Is the **signal** about individuals **noisy**? (If yes, Phelps says even
  rational agents will lean on group priors.)
- Is the **prior** itself a product of past discrimination? (If yes,
  you're in Coate-Loury territory and the "rational" behavior just
  perpetuates the historical injustice.)

These four questions are more useful in practice than memorizing
formulas, which is why we put the formulas in the appendix.

---

## Exercise Preview

The Module 1 R exercise will:

1. Simulate a population of riders with two groups ($A$ and $B$) where
   the **true** acceptance probability is identical
2. Inject a small **taste-based** drop in acceptance for group $B$
   (drivers cancel more often), à la Ge et al. (2016)
3. Then inject a **statistical** drop: the algorithm learns from
   neighborhoods that correlate with group membership
4. Show that the *observed* acceptance gap looks the same in both cases
   even though the underlying mechanism is different
5. Discuss what an audit would and wouldn't be able to distinguish

---

## Appendix: Formal Derivations

### A.1 Becker's Discrimination Coefficient

Let $w_A$ and $w_B$ be the wages of $A$- and $B$-types, both with
productivity $p$. A prejudiced employer with discrimination coefficient
$d$ acts as if hiring a $B$-type costs $w_B(1 + d)$. The first-order
condition for hiring is:

$$
p = w_A \quad \text{and} \quad p = w_B(1 + d)
$$

so the equilibrium wage gap is $w_A / w_B = 1 + d$. In a competitive
market with free entry by non-prejudiced firms ($d = 0$), they will hire
all available $B$-types at $w_A$, eliminating the gap. The model thus
predicts that taste-based discrimination is *not* a long-run equilibrium
unless something prevents free entry.

### A.2 Phelps's Bayesian Updating

Suppose productivity $\theta$ is drawn from $\theta_g \sim \mathcal{N}(\mu_g, \sigma^2_g)$
for group $g \in \{A, B\}$. The employer observes a noisy signal
$s = \theta + \varepsilon$ with $\varepsilon \sim \mathcal{N}(0, \sigma^2_\varepsilon)$.

The Bayesian posterior mean is:

$$
\mathbb{E}[\theta \mid s, g] = (1 - \alpha_g) \mu_g + \alpha_g s
$$

where $\alpha_g = \sigma^2_g / (\sigma^2_g + \sigma^2_\varepsilon)$ is the
weight on the signal. Two distinct sources of group-conditional
discrimination:

1. **Different means** ($\mu_A \neq \mu_B$): for the same $s$, the
   posterior is shifted by $(1 - \alpha)(\mu_A - \mu_B)$
2. **Different signal precision** ($\sigma_{\varepsilon, A} \neq \sigma_{\varepsilon, B}$):
   the weight $\alpha_g$ differs across groups, so the *response* to a
   given signal differs

A profit-maximizing employer who pays $\mathbb{E}[\theta \mid s, g]$ is
behaving rationally, but the policy outcome is still discriminatory in the
group-statistical sense.

### A.3 Coate-Loury Self-Fulfilling Equilibrium

Workers choose to invest in skill at cost $c$, employers update on a noisy
test of skill, and the equilibrium fraction of $B$-types who invest depends
on the wage premium employers offer for the high-skill posterior. With
two groups, you get a fixed-point problem of the form:

$$
\pi_g^* = F(\text{wage premium}(\pi_g^*))
$$

This can have multiple solutions. The "high-investment" equilibrium and
the "low-investment" equilibrium can both be stable, and the bad
equilibrium is self-sustaining. *Affirmative action policies* in this
model work by shifting the system from the bad equilibrium to the good
one — temporarily distorting incentives in exchange for moving to a
better steady state.
