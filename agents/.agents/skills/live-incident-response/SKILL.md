---
name: live-incident-response
description: Contain and restore an actively degraded staging or production system while preserving evidence for follow-up RCA. Use when current user impact makes recovery urgent; require explicit authority for rollback, disabling, or other live mutations, and avoid broad redesign during the incident.
---

# Live incident response

Restore a stable, observable state with the smallest safe intervention.

## Establish command and scope

Confirm the affected environment, impact, start time, current symptoms, relevant deployment/configuration changes, available read-only evidence, and authority for live actions.

Do not expose secrets or customer data. Prefer read-only observation until a containment action is justified and authorized.

## Respond

1. Confirm the degradation from an authoritative signal.
2. Preserve the evidence most likely to disappear: logs, event/session identifiers, deployment revision, configuration, state snapshots, and timestamps.
3. Bound impact and identify the last known healthy state.
4. Choose the least invasive containment: disable a flag, pause a component, roll back, or isolate traffic as supported by the system.
5. Obtain authority immediately before the live mutation if not already granted.
6. Verify recovery through both system health and the affected user-visible path.

Limit retries and avoid stacking speculative fixes. If containment fails, reassess the causal assumptions before another mutation.

## After stabilization

Create an incident packet containing:

- impact and timeline;
- evidence and exact revisions/configuration;
- containment action and authority;
- recovery evidence;
- data consistency or cleanup concerns;
- unanswered causal questions;
- recommended follow-up RCA.

Do not perform a broad refactor or declare a root cause during recovery unless the evidence genuinely establishes it.
