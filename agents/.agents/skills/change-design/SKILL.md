---
name: change-design
description: Convert a stable product objective or evidence-backed RCA into an implementation-ready design with explicit behavior, tradeoffs, blast radius, rollout, and verification. Use before nontrivial implementation; stop before editing code.
---

# Change design

Decide what should change so implementation does not need to invent product behavior.

## Establish the decision

Ground the design in a stable objective or RCA. State current behavior, desired observable behavior, affected users and environments, constraints, and success criteria.

Resolve material product questions explicitly. Do not bury them in data structures, fallback behavior, copy, timing, or configuration defaults.

## Develop options

Consider the smallest credible alternatives. Compare them on:

- correctness and user experience;
- compatibility and migration;
- state and concurrency semantics;
- operational risk and observability;
- implementation size and reversibility;
- verification difficulty;
- rollout and rollback.

Reject options with concrete reasons. Avoid option theatre when only one approach satisfies the constraints.

## Define the contract

Specify:

- desired behavior and non-goals;
- must-preserve behavior;
- ownership and source of truth;
- key state transitions and failure behavior;
- affected surfaces and likely blast radius;
- rollout, configuration, migration, and rollback;
- acceptance criteria and verification matrix;
- unresolved decisions and authority required.

For cross-cutting or unfamiliar systems, require a focused blast-radius analysis before implementation. Incorporate its discoveries rather than treating it as an appendix.

## Handoff

Produce a design that can be implemented in small coherent slices. Identify the first independently verifiable slice and stop before editing. If the design still requires the implementer to choose observable behavior, it is not ready.
