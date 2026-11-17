---
name: tdd-change-delivery
description: Run a formal test-driven delivery workflow only when the user explicitly requests TDD or invokes this skill. Ordinary implementation and bug fixes should follow repository verification requirements directly without loading this skill.
---

# TDD change delivery

Treat tests as executable behavioral contracts and system-discovery tools, not as confirmation of the implementation's internal shape.

## Preconditions

Before editing, require:

- stable intended behavior;
- observable acceptance criteria;
- a sufficiently understood change surface;
- explicit authorization for workspace changes;
- a declared stop before release unless release was separately authorized.

If a shared or unfamiliar system lacks a blast-radius map, produce or request one first.

## Establish red

1. Characterize nearby behavior that already works and must remain stable.
2. Create the narrowest realistic reproduction of the exact failure or missing behavior.
3. Add side-effect assertions for meaningful sibling paths and system boundaries.
4. Run the focused check before production changes and record the expected failure.

A test that passes before the change is useful characterization, not the red reproduction. A test of a helper is insufficient when the defect lives across a wrapper, state, or delivery seam.

## Implement the smallest coherent slice

Change the source of the behavior, avoiding opportunistic refactors. Prefer a vertical slice with one observable outcome over a large partially verified framework.

Maintain a newly discovered seams ledger. For every discovery:

- include it in the current verification matrix;
- explicitly exclude it with a reason; or
- return to design if it changes intended behavior.

Do not silently patch a new product decision.

## Establish green

Run:

1. The exact reproduction.
2. Characterization and side-effect checks.
3. The proportionate repository gate.

State what each proves and which real boundaries remain untested. Remove temporary instrumentation and inspect the final diff for unrelated changes.

## Handoff

Provide the independent verifier with:

- intended behavior and acceptance ledger;
- original red observation;
- changed files and design decisions;
- focused and broad check results;
- newly discovered seams;
- remaining environment or user-path verification.

Do not deploy or claim complete system behavior from implementation-owned tests alone.
