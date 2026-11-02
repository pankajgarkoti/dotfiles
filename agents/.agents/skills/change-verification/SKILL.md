---
name: change-verification
description: Independently challenge a completed change against its acceptance criteria, original failure, side effects, alternate paths, and real user boundaries. Use after implementation or before release; report failure evidence without repairing it unless the user separately authorizes a new implementation pass.
---

# Change verification

Attempt to falsify the claim that the change is correct. Verification is a separate epistemic phase, not extra implementation time.

## Reconstruct the contract

Obtain:

- intended observable behavior;
- acceptance and must-preserve criteria;
- original incident or red reproduction;
- blast-radius and behavior matrix;
- implementation diff and claimed test evidence;
- target environment and release boundary.

If these are missing, recover them from authoritative artifacts. Do not infer success criteria solely from the implementation.

## Challenge the change

Verify, as applicable:

1. The original reproduction is green for the correct reason.
2. Characterized behavior remains stable.
3. Wrappers, adapters, replay, spawn, scheduled, retry, cancellation, and resume paths identified by the blast-radius map.
4. Platform, environment, configuration, and feature-flag variants.
5. Partial success, malformed input, old persisted state, and rollback behavior.
6. The real user-visible path at the highest safe authorized tier.

Look specifically for assumptions shared by production code and its tests. Prefer observable outputs, state transitions, and delivery evidence over mocks of the behavior under test.

## Report, do not repair

For every failed criterion, produce:

```text
Criterion
Reproduction
Expected
Observed
Evidence
Probable owning seam, if known
```

Return failures to an implementation pass. Do not alter production code during independent verification unless the user explicitly changes the workflow and authorizes the edit.

## Verdict

Use one of:

- `verified`: every required criterion has proportionate evidence;
- `conditionally verified`: local proof is complete but a named authorized environment check remains;
- `failed`: at least one criterion is disproved;
- `blocked`: required evidence or environment access is unavailable.

State exactly what each executed check proves and does not prove. Passing tests, a successful deploy, or a large diff is never sufficient by itself.
