---
name: incident-rca
description: Determine the evidence-backed causal mechanism behind a validated technical incident. Use after original evidence is available to trace state, compare working and failing paths, and test falsifiable hypotheses; default to diagnosis-only and stop before implementation unless explicitly authorized.
---

# Incident RCA

Explain why the incident occurred, not merely where the symptom appeared.

## Preconditions

Require a concrete observed failure, expected behavior, affected scope, and original evidence. If the report is ambiguous or duplicated, adjudicate it first. If authoritative evidence is missing, obtain it rather than building a causal story from summaries.

## Establish a red-capable observation

Find the smallest safe observation, test, script, query, or trace that distinguishes the failing behavior from the expected one. Record the baseline before proposing changes. For intermittent failures, use bounded repetition or controlled state; a non-reproduction is not a pass.

## Trace causality

Follow the bad value or state backward across relevant boundaries. Inspect:

- entry and decision points;
- transformations, wrappers, adapters, replay, and scheduling;
- persisted state, identity, concurrency, retry, cancellation, and resume behavior;
- delivery and user-visible effects;
- recent changes and a nearby working path.

State a small set of ranked, falsifiable hypotheses. For each, name the observation that would support or reject it, then test the cheapest high-value discriminator.

Do not call temporal correlation, a suspicious line, or a plausible narrative the root cause. Explain contradictions rather than ignoring them.

## Deliver

Return:

- concise incident statement and impact;
- causal timeline;
- confirmed mechanism and source;
- evidence that rejects material alternatives;
- scope and recurrence implications;
- confidence and unknowns;
- implementation options and their tradeoffs, when requested;
- recommended next workflow.

Diagnosis does not authorize edits, deployment, replay, or production mutation.
