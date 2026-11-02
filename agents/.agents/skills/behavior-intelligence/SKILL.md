---
name: behavior-intelligence
description: Mine real interaction evidence for recurring user friction, regressions, adoption patterns, and use cases. Use for periodic behavioral reviews or corpus analysis across many sessions; do not use for a single-incident root cause, implementation, or release work.
---

# Behavior intelligence

Turn a bounded window of real interactions into evidence-backed patterns. The deliverable is recurring mechanisms and adoption signals, not a list of keyword hits or general impressions.

## Scope the review

Establish the environment, time window, included surfaces and populations, prior run boundary, and exclusions. Preserve comparable definitions across recurring runs. Prefer incremental collection without overwriting earlier evidence.

Separate organic user interactions from dogfood, synthetic tests, scheduled platform routines, spawned workers, quoted complaints, and other populations that would distort claims.

## Find candidates

Use complementary signals appropriate to the available corpus:

- explicit user frustration and repair language;
- repeated requests, dropped constraints, unsupported completion claims, and changed diagnoses;
- retries, cancellations, partial delivery, missing artifacts, and unexpected tool or state transitions;
- new tools, tool combinations, recurring workflows, automations, and workspace adoption;
- quantitative outliers in turns, latency, failures, calls, or user intervention.

Signals identify candidates, not verdicts. Inspect the original interaction around each candidate and read enough of the session to understand the user's goal and outcome.

## Classify with evidence

For every accepted pattern, record:

- user goal and affected population;
- mechanism, not merely symptom;
- recurrence and severity;
- verbatim or directly traceable evidence;
- expected behavior;
- false-positive reasoning when a candidate is rejected;
- whether context was unavailable, available-but-unused, or lost;
- confidence and important sampling limitations.

Keep behavior findings distinct from code-level root causes. A recurring symptom can justify incident adjudication without proving why it happens.

## Deliver

Produce:

- recurring friction mechanisms ranked by impact;
- newly observed use cases and changes to prior patterns;
- representative evidence references;
- candidate incidents needing adjudication;
- data-quality caveats and the next incremental boundary.

Do not prescribe fixes unless separately asked to enter a design workflow.
