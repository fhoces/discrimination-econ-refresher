# Discrimination in Labor Economics: Refresher

A short, applied refresher on the labor-economics literature on discrimination,
threaded through ride-sharing examples (Uber/Lyft). Designed for someone who
read Borjas a long time ago and wants the modern empirical version.

> **Live slides:** https://fhoces.github.io/discrimination-econ-refresher/
> *(set up after enabling GitHub Pages on this repo)*

## Why this exists

Borjas-era labor econ teaches Becker (1957) and Phelps (1972) and then mostly
moves on. The modern literature has shifted heavily toward **empirical
measurement** — audit studies, decomposition methods, and algorithmic audits —
and that's where most of the interesting discrimination research happens
today. This refresher closes the gap.

The ride-sharing setting is a clean laboratory for almost everything in this
literature: there's a published correspondence study (Ge et al. 2016), a
canonical pay-gap decomposition (Cook et al. 2021), and an active algorithmic
audit literature (Pandey-Caliskan, Chen-Mislove-Wilson). Every module is
illustrated with at least one published ride-sharing study.

## How to use this repo

Each module folder contains three files:

- **`concepts.md`** — written refresher of the ideas (the "what")
- **`slides.Rmd`** — `xaringan` slide deck rendered to `slides.html` (the "show")
- **`exercise.R`** — runnable R script with the worked example (the "do")

To rebuild the slides locally:

```r
rmarkdown::render("module-01/slides.Rmd")
```

The exercises depend on `tidyverse`, `broom`, and base R. Install with
`install.packages(...)` as needed.

## Modules

| # | Module | Concepts | Application |
|---|--------|----------|-------------|
| **1** | [Theory Primer](module-01/) | Becker (taste-based), Phelps (statistical), Coate-Loury self-fulfilling equilibria | Two indistinguishable acceptance gaps in Uber data |
| **2** | [Audit & Correspondence Studies](module-02/) | Matched-pair designs, Bertrand-Mullainathan, threats to validity | Ge, Knittel, MacKenzie & Zoepf (2016) — the Uber/Lyft audit |
| **3** | [Decomposition Methods](module-03/) | Oaxaca-Blinder, "explained" vs "unexplained" gaps | Cook, Diamond, Hall, List & Oyer (2021) — Uber driver gender pay gap |
| **4** | [Algorithmic Audits](module-04/) | Shadow audits, scraped audits, internal A/B audits | Pandey-Caliskan (2021), Chen-Mislove-Wilson (2015) |
| **5** | [Modern Methods & Practitioner](module-05/) | Causal ML, the bridge to ML fairness, the internal-economist role | Auditing pricing/dispatch from inside a TNC |

## Key papers

- **Ge, Knittel, MacKenzie & Zoepf (2016)** — *Racial and Gender Discrimination
  in Transportation Network Companies* (NBER)
- **Cook, Diamond, Hall, List & Oyer (2021)** — *The Gender Earnings Gap in
  the Gig Economy: Evidence from over a Million Rideshare Drivers*
  (Review of Economic Studies, 88(5))
- **Pandey & Caliskan (2021)** — *Disparate Impact of Artificial Intelligence
  Bias in Ridehailing Economy's Price Discrimination Algorithms* (AIES)
- **Chen, Mislove & Wilson (2015)** — *Peeking Beneath the Hood of Uber* (IMC)
- **Bertrand & Mullainathan (2004)** — *Are Emily and Greg More Employable than
  Lakisha and Jamal?* (American Economic Review, 94(4))
- **Becker (1957)** — *The Economics of Discrimination*
- **Phelps (1972)** — *The Statistical Theory of Racism and Sexism* (AER 62(4))

## Companion course

This is part of a small set of refreshers. The other one currently in this
series is the [ML Discrimination Refresher](https://github.com/fhoces/ml-discrimination-refresher),
which covers the machine-learning side: bias-variance tradeoff, fairness
metrics, the impossibility theorem, and algorithmic audits in more depth.
