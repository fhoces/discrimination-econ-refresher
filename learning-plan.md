# Discrimination in Labor Economics: Refresher

A short, applied refresher on the labor-economics literature on discrimination,
threaded through ride-sharing examples (Uber/Lyft). Designed for someone who
read Borjas a long time ago and wants the modern empirical version.

**Time budget: ~5 hours**

| # | Module | Time | Focus |
|---|--------|------|-------|
| 1 | Theory primer: Becker + Phelps | 0.75h | The two classical models, intuition only |
| 2 | Audit & Correspondence Studies | 1h | Ge et al. (2016), the dominant empirical paradigm |
| 3 | Decomposition Methods | 1.5h | Oaxaca-Blinder, Cook et al. (2021) on the Uber gender gap |
| 4 | Algorithmic Audits | 1h | Pandey-Caliskan, Chen-Mislove-Wilson, surge pricing |
| 5 | Modern Methods & The Practitioner Question | 0.75h | Causal ML, the bridge to ML fairness, what an internal economist actually does |

**Two design choices for this refresher:**

1. **Empirical-heavy.** Theory is consolidated to one module with intuition only;
   formal derivations live in an appendix. The other four modules are about
   measurement, identification, and what the empirical literature actually says.
2. **Ride-sharing throughout.** Every model and method is illustrated with
   a published or simulated ride-sharing example. The course is designed to
   be useful background for an applied policy economist role at a TNC (Uber,
   Lyft, etc.).

---

## 1. Theory primer: Becker + Phelps

- **Becker (1957)** taste-based discrimination: employer / coworker / customer
  variants, the discrimination coefficient $d$, why competition is *supposed*
  to erode it
- **Phelps (1972)** statistical discrimination: rational use of group averages
  when individual signals are noisy, the role of signal precision
- Applications: rider taste-based discrimination (Ge et al. 2016 preview),
  algorithmic statistical discrimination via neighborhood proxies
- **Appendix**: full derivations of both models

## 2. Audit & Correspondence Studies

- The matched-pair design (Bertrand-Mullainathan 2004 as the methodological
  reference)
- **Ge et al. (2016)** *Racial and Gender Discrimination in TNCs* — the
  Boston/Seattle field experiment that documented ~2x cancellation rates for
  African-American–sounding rider names
- What audits identify, what they don't, and the standard threats to validity
- Modern variants: shadow audits, scraped audits, A/B-style platform audits

## 3. Decomposition Methods (Cook et al. 2021 centerpiece)

- Oaxaca-Blinder decomposition: explained vs unexplained portions of a gap
- Why "unexplained ≠ discrimination" and "explained ≠ no discrimination"
- **Cook, Diamond, Hall, List & Oyer (2021)** *The Gender Earnings Gap in the
  Gig Economy* (REStud) — the famous Uber driver pay-gap paper that explains
  the entire ~7% gap with experience, ride-volume returns, and *driving speed*
- How to read the paper as an applied economist: what's identified, what
  isn't, and why the result is contested
- Replicating a stylized version on synthetic data

## 4. Algorithmic Audits

- **Pandey & Caliskan (2021)** on disparate impact in ride-hail pricing
- **Chen, Mislove & Wilson (2015)** *Peeking Beneath the Hood of Uber* —
  the original surge-pricing audit
- Methodology: how do you audit a black-box pricing or dispatch algorithm
  from outside?
- Hands-on: simulate a simple surge-pricing rule and audit it

## 5. Modern Methods & The Practitioner Question

- The bridge to the ML fairness literature (Module 7 of the ML course)
- Causal ML for discrimination measurement: doubly-robust methods,
  conditional ATEs, role of off-the-shelf ML in selection-on-observables
- The practitioner question: if a regulator asks "is your algorithm
  discriminating?", what does an honest answer look like, and what's the role
  of an internal economist?

---

## Key papers

- **Ge, Knittel, MacKenzie & Zoepf (2016)** — *Racial and Gender Discrimination
  in Transportation Network Companies* (NBER working paper)
- **Cook, Diamond, Hall, List & Oyer (2021)** — *The Gender Earnings Gap in
  the Gig Economy: Evidence from over a Million Rideshare Drivers*
  (Review of Economic Studies, 88(5))
- **Pandey & Caliskan (2021)** — *Disparate Impact of Artificial Intelligence
  Bias in Ridehailing Economy's Price Discrimination Algorithms* (AIES)
- **Chen, Mislove & Wilson (2015)** — *Peeking Beneath the Hood of Uber*
  (IMC '15)
- **Bertrand & Mullainathan (2004)** — *Are Emily and Greg More Employable
  than Lakisha and Jamal?* (American Economic Review, 94(4))
- **Becker, G. (1957)** — *The Economics of Discrimination*
- **Phelps, E. (1972)** — *The Statistical Theory of Racism and Sexism*
  (American Economic Review, 62(4))

## How to use this plan

1. Read the concept review for each module
2. Walk through the slide deck
3. Run the R exercise (each module reproduces a stylized version of a published
   result on synthetic data)

Say **"start module 1"** to begin.
