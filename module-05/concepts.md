# Module 5: Modern Methods & The Practitioner Question

## Quick Refresher

You now have the four core empirical tools of the modern discrimination
literature:

| Tool | Module | Strength | Weakness |
|---|---|---|---|
| Theory (Becker, Phelps) | 1 | Tells you what mechanism to look for | Can't measure anything |
| Audit studies | 2 | Clean causal identification | Expensive, narrow |
| Decomposition | 3 | Cheap, observational | Conflates "explained" with "non-discriminatory" |
| Algorithmic audits | 4 | Scalable, low cost | Bad-controls problem; correlation only |

This last module ties them together and answers the practitioner question:
**if you walk into Uber tomorrow as a policy economist, what do you actually
do?**

We cover three things:

1. The bridge to the ML fairness literature (Module 7 of the ML course),
   so you can read both economists and computer scientists writing on the
   same questions
2. A short tour of *causal ML* methods that have become standard for
   discrimination measurement in the last few years
3. The practitioner playbook — what an internal economist's job actually
   looks like when a regulator, journalist, or executive asks "is the
   algorithm discriminating?"

---

## The Bridge to ML Fairness

The labor-econ literature on discrimination and the CS literature on
algorithmic fairness are about **the same thing**, with different
vocabulary. Once you map them you can read both.

| Labor econ | ML fairness | What it means |
|---|---|---|
| Becker (taste-based) | "Direct discrimination" | Decision-maker uses the protected attribute |
| Phelps (statistical) | "Disparate impact via proxy" | Model uses correlated features |
| Audit study | "Counterfactual fairness" | What would the prediction be if I changed only the protected attribute? |
| Decomposition | "Conditional independence" | $Y \perp A \mid X$ — fairness conditional on observables |
| Demographic parity | "Statistical parity" | Equal positive rates across groups |
| Equalized odds | "Error-rate parity" | Equal TPR and FPR across groups |
| Predictive parity | "Calibration" | Equal precision across groups |
| Disparate impact ratio | "80% rule" | The legal fairness threshold |

Two practical implications:

1. **Read both literatures.** Economists are better on identification and
   normative interpretation; computer scientists are better on
   computational tractability and the impossibility results. Each side
   has blind spots about the other.
2. **Use both vocabularies.** When you write for a regulator, "disparate
   impact" is the legal term. When you write for a research audience,
   "equalized odds" is the technical one. Knowing how they map is the
   value-add of an internal policy economist.

---

## Causal ML for Discrimination Measurement

In the last decade, the **causal ML** literature has produced new tools
for measuring discrimination in observational data. The idea: combine
the causal-inference setup from labor econ with the flexibility of
machine learning to estimate nuisance parameters.

The methods you should know:

### Doubly-robust estimation

If you want to measure the effect of group membership on an outcome
controlling for observables, you need to model two things:

- The **outcome** as a function of features (the response model)
- The **treatment assignment** as a function of features (the propensity model)

A doubly-robust estimator (e.g., AIPW — Augmented Inverse Probability
Weighting) is consistent if **either** model is correctly specified. ML
methods (random forests, gradient boosting, neural nets) can flexibly
fit both. The result is often called **DML (Double Machine Learning)**,
following Chernozhukov et al. (2018).

For discrimination measurement: you can estimate the "disparate impact
conditional on legitimate features" with much less specification anxiety
than a hand-rolled regression.

### Causal forests / heterogeneous effects

Athey & Imbens (2016, 2019) developed **causal forests** for estimating
treatment effects that vary across subgroups. Useful for discrimination
because you may want to ask: "is the discrimination concentrated in
certain subgroups?" rather than "is there discrimination on average?"

Application: rather than a single decomposition, you can look at the
*distribution* of treatment effects across demographic features.

### Counterfactual / interventional methods

Given a model, you can ask: "if I changed the protected attribute and
held everything else fixed, how would the prediction change?" This is
the empirical version of the Phelps thought experiment.

Implementation is tricky because "everything else fixed" is itself a
modeling choice — many features are correlated with the protected
attribute and should arguably also be changed in the counterfactual.
The CS literature on **counterfactual fairness** (Kusner et al. 2017)
addresses this with explicit causal graphs.

### Why these tools matter

Two practical reasons:

1. **They handle the bad-controls problem better than OLS.** With doubly
   robust methods + ML nuisance functions, you can include many features
   without overfitting and without conflating mediators with controls.
2. **They produce *intervention-relevant* estimates.** If a regulator
   asks "what would happen if we changed X?", a causal-ML estimate is
   closer to the answer than a regression coefficient.

---

## The Practitioner Question

You walk into Uber as a policy economist. A regulator sends you a
letter: "Is your algorithm discriminating against protected groups?"

What do you actually do?

### Step 1: Translate the question

The regulator's question is normative-shaped but technical-shaped. You
need to convert it to one or more answerable empirical questions:

- *Does the algorithm produce predictions that vary by the protected
  attribute, conditional on legitimate features?* (statistical
  discrimination)
- *Does the algorithm produce predictions that would change if the
  protected attribute were changed and nothing else were?*
  (counterfactual fairness)
- *Does the algorithm produce error rates that vary across groups?*
  (equalized odds)
- *Does a positive prediction mean the same thing across groups?*
  (predictive parity / calibration)

These are *different* questions with *different* answers, and the
regulator usually doesn't know which one they want. Your first job is to
make them choose.

### Step 2: Run the audit

Once you have the question, the audit is mechanical. Pull the data,
compute the metric, do the per-group breakdown, report the result with
appropriate caveats. The technical work is the easy part.

### Step 3: Frame the result

This is where the policy economist earns their salary. The result is a
number; the framing is the policy story. A few things you should always
include in the framing:

- The **mechanism**, even if you can only speculate
- The **counterfactual**: what would the algorithm look like if you
  removed the discrimination? What would that cost?
- The **upstream causes**, if any (e.g., if the disparate impact is
  driven by historical patterns of urban form, that's relevant context)
- The **policy levers** available to the platform

### Step 4: Manage the disclosure

Internal audits have a problem: the platform's lawyers don't want them
published. Your job is to find the version of the result that:

- Is true
- Is defensible
- Doesn't expose the company to liability beyond the actual finding
- Can be communicated to the regulator without surprises

This is a real skill that matters more than the technical analysis. The
people who succeed in this role are the ones who can write a 2-page memo
that survives review by Legal, Comms, Product, and Engineering — *and*
tells the truth.

---

## Three Things to Know for the Interview

1. **The empirical literature on ride-sharing discrimination is small but
   active.** You should be able to name and describe Ge et al. (2016),
   Cook et al. (2021), Pandey-Caliskan (2021), and Chen-Mislove-Wilson
   (2015). These are the four papers that come up.

2. **The methodological debate is about *which questions* count, not
   about *which methods* work.** Regression, audit, decomposition,
   algorithmic counterfactual — all are valid for *some* question.
   The interesting debate is which question you should be asking.

3. **The internal-economist role is a *translation* role.** You translate
   between regulators, lawyers, researchers, product managers, and
   engineers. The technical work is necessary but not sufficient. The
   skill is communicating across stakeholders without losing the
   technical truth.

---

## Reading List (Short)

If you want to go deeper, the four papers from this course's modules
plus:

- **Chernozhukov, Chetverikov, Demirer, Duflo, Hansen, Newey & Robins
  (2018)** — *Double/debiased machine learning for treatment and
  structural parameters* (Econometrics Journal). The DML reference.

- **Athey & Imbens (2019)** — *Machine Learning Methods That Economists
  Should Know About* (Annual Review of Economics). The applied-economist
  introduction to causal ML.

- **Kusner, Loftus, Russell, Silva (2017)** — *Counterfactual Fairness*
  (NeurIPS). The CS take on the same set of questions.

- **Mitchell, Wu, Zaldivar, Barnes, Vasserman, Hutchinson, Spitzer, Raji
  & Gebru (2019)** — *Model Cards for Model Reporting* (FAT*). The
  practitioner template for documenting models, including fairness
  audits.

- **Hardt, Price & Srebro (2016)** — *Equality of Opportunity in
  Supervised Learning* (NeurIPS). The equalized-odds reference.

- **Chouldechova (2017)** — *Fair prediction with disparate impact*
  (Big Data). The impossibility-result paper.

---

## Where This Course Fits in Your Toolkit

The point of this five-module refresher was to give you the labor-econ
side of the discrimination literature, so you can:

1. **Read papers** — academic, regulatory, and platform-internal
2. **Run analyses** — using the methods we covered, on the data you'll
   actually see
3. **Frame results** — the translation skill that's the core of the role
4. **Talk in the interview** — you should now be able to discuss any of
   the four canonical ride-sharing studies, the impossibility theorem,
   and the practitioner playbook

For the **machine-learning side** (bias-variance, fairness metrics, the
impossibility theorem in detail, algorithmic auditing methods), see the
companion ML refresher in the sister repo.

---

## Exercise Preview

The Module 5 R exercise will:

1. Take the simulated surge-pricing data from Module 4
2. Apply a **doubly-robust** estimator (with ML nuisance functions) to
   estimate the disparate impact, comparing to the naive OLS
3. Walk through a stylized **practitioner memo** structure: question,
   data, method, result, caveats, recommendation
4. End with a self-assessment checklist: can you describe each of the
   four canonical papers, defend a methodology choice, and write a
   2-page memo that survives stakeholder review?
