---
name: blast-radius-analysis
description: Map side effects and behavioral reach before changing a shared or unfamiliar system. Use for runtime seams, wrappers, state, concurrency, retries, approvals, jobs, delivery platforms, feature flags, migrations, or cross-cutting behavior; skip for isolated leaf edits with an obvious focused test.
---

# Blast-radius analysis

Produce a bounded change-surface map before implementation. The output should make missing seams visible and directly determine the verification plan.

## Establish the behavior

State:

- the user-visible or externally observable behavior intended to change;
- the current behavior and evidence for it;
- what must remain unchanged;
- the environment and state assumptions.

If intended behavior is undecided, stop at design options. Do not begin implementation.

## Trace the system

Follow the behavior end to end rather than stopping at the first plausible owner:

1. Entry points and callers.
2. Transforming wrappers, adapters, middleware, replay, spawn, and scheduled paths.
3. State ownership, persistence, identity, locking, retry, cancellation, and resume behavior.
4. Consumers and user-visible delivery surfaces.
5. Sibling paths that claim equivalent behavior.
6. Platform, environment, configuration, and feature-flag differences.
7. Error, partial-success, rollback, and old-state behavior.

Use repository evidence and nearby working paths. Separate confirmed seams from suspected ones.

## Audit existing proof

For each relevant test, script, harness, or environment check, state what it proves and what production boundary it replaces or omits. Identify shared assumptions between the implementation and its tests.

Build a compact behavior matrix using meaningful equivalence classes, not every Cartesian combination. Include only dimensions capable of changing the outcome.

## Deliver the map

Return:

```text
Primary path
Transforming seams
Sibling/equivalent paths
State and concurrency
Platforms/environments
Must-preserve behavior
Known failure paths
Existing proof and gaps
Unknowns requiring experiments
Proposed red reproduction
Verification matrix
```

Timebox exploration proportionately. If the map remains incomplete, name the exact unknown and its risk instead of reading indefinitely.

Do not edit production code. Discovery that changes product intent hands off to design; a stable map hands off to TDD delivery.
