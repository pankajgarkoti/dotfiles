---
name: incident-adjudication
description: Turn noisy reports, behavioral findings, issue lists, and complaints into a deduplicated, prioritized incident inventory. Use to decide what is real and actionable before RCA; do not claim technical causes or modify code.
---

# Incident adjudication

Decide what deserves investigation and attach the right evidence to it.

## Normalize reports

For each report, extract:

- affected user, tenant, environment, surface, and time window when available;
- expected and observed behavior;
- user-visible impact;
- original conversation or operational evidence;
- existing issue, PR, deployment, or prior finding references.

Do not treat a reporting thread, summary, screenshot caption, or model-written explanation as a substitute for original evidence.

## Reconcile

Compare reports by mechanism and user-visible behavior, not keyword similarity alone. Distinguish:

- duplicates of the same incident;
- related symptoms with different mechanisms;
- a regression after a purported fix;
- a historical incident with no current evidence;
- expected behavior or a product disagreement;
- evidence too weak to adjudicate.

Check whether linked fixes were merged and deployed before calling an incident fixed. A merged PR is not proof that the reported behavior disappeared.

## Classify

Assign one status:

- `new`;
- `duplicate` with canonical incident;
- `fixed` with verification evidence;
- `regressed`;
- `non-actionable` with reason;
- `needs-evidence` with the exact missing observation.

Add recurrence, severity, affected scope, confidence, and recommended next workflow. Keep prioritization separate from certainty: a weakly evidenced but severe report may deserve urgent evidence collection.

## Deliver

Return a canonical incident ledger linking each input report to its status, evidence, issue/PR/deployment history, and next action. Do not infer a root cause or start implementation.
