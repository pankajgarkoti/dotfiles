---
name: outcome-accounting
description: Evaluate whether a completed body of engineering work improved the intended product outcome rather than merely producing activity, commits, or code. Use after release, a workstream, or a meaningful review window; do not reduce exploratory work to simplistic productivity scoring.
---

# Outcome accounting

Compare the promised bottom-line change with observed product behavior and the cognitive and rework cost of delivery.

## Recover the intended outcome

Use the original objective, incident, acceptance criteria, design and release record. Distinguish the user-visible result from implementation proxies such as merged PRs, lines changed, tests added, or services deployed.

## Gather evidence

Measure what is proportionate and available:

- whether the original incident or unmet need is now resolved;
- recurrence or regression after release;
- acceptance criteria with observable proof;
- first-pass verification and staging success;
- corrective turns and new seams discovered after implementation;
- follow-up fixes, reversions, churn, and deferred work;
- time spent in investigation, implementation, verification, and user supervision;
- operational or user-facing effect.

Avoid attributing team-wide or externally caused outcomes to one run without evidence. Treat code volume and commit count as cost or activity signals, not value.

## Assess

Explain:

- what changed for users or operators;
- what remained unchanged despite activity;
- whether the design closed a mechanism or patched a symptom;
- what rework reveals about missing discovery or verification;
- whether the change should be kept, iterated, rolled back, or redesigned;
- which workflow contract should change next time.

Use trends across comparable work rather than punishing one difficult exploratory task. State data limitations and uncertainty.

## Deliver

Return a concise outcome review with:

```text
Promised outcome
Observed outcome
Evidence
Reliability and recurrence
Delivery/rework cost
Cognitive supervision cost
Verdict
Workflow improvements
Next measurement boundary
```

The purpose is to improve engineering decisions and supervision economics, not to create a vanity score.
