---
name: integration-release
description: Move a verified revision through branch integration, PR, merge, deployment, and initial health observation. Use only with explicit authority for external mutations and a named target environment; do not use deployment as the first complete behavioral test.
---

# Integration and release

Release the exact verified change while preserving a recoverable path.

## Preconditions

Confirm:

- exact commit, branch, or artifact;
- acceptance and verification evidence;
- unresolved risks and deliberately deferred checks;
- target environment and deployment mechanism;
- required secrets, configuration, migrations, and feature flags;
- explicit authority for pushes, merges, deployments, or other external mutations;
- rollback or disable path.

Do not infer release authority from permission to implement. Do not proceed when the revision under test differs materially from the revision being released.

## Integrate safely

Inspect current branch and remote state without disturbing unrelated work. Resolve conflicts according to the accepted design and rerun affected verification; a conflict-free merge is not proof of behavioral equivalence.

Preserve traceability from incident or objective through design, revision, checks, and deployment.

## Release and observe

Apply the narrow authorized mutation. Record the deployed revision and environment. Check service health, migrations/configuration, logs or telemetry, and the highest-value safe user-visible behavior.

Use bounded observation. Do not turn routine release observation into an indefinite monitor. If a regression appears, preserve evidence and enter live incident response rather than improvising a broad fix in the release workflow.

## Deliver

Report:

- exact integrated and deployed revision;
- target and timestamps;
- checks performed and what they prove;
- observed health and user-path evidence;
- rollback/disable readiness;
- remaining risk and any follow-up observation.

A successful command or healthy process alone is not a verified release.
