---
name: system-mapping
description: Explain how an unfamiliar feature or subsystem currently works, including execution flow, state, ownership, boundaries, and failure seams. Use for comprehension without a specific incident; do not redesign the system or treat preferences as defects unless asked.
---

# System mapping

Build a reliable mental model of the current system in plain language.

## Define the question

Clarify the user-visible capability or system boundary being mapped. Identify the relevant entry points, outputs, environment, and the depth needed for the user's decision. Avoid cataloguing the entire repository.

## Trace the flow

Use code, tests, architecture records, configuration, schemas, and operational evidence as appropriate. Map:

- triggers and entry points;
- orchestration and key transformations;
- state ownership and persistence;
- tool, service, and platform boundaries;
- asynchronous work, retries, cancellation, and recovery;
- user-visible outputs and errors;
- configuration and environment variants;
- observability and existing verification seams.

Cross-check documentation against the implementation and flag drift. Distinguish the primary path from fallback, legacy, and exceptional paths.

## Explain, do not merely enumerate

Describe why important boundaries exist and where behavior can diverge. Use exact symbols or files only where they help the user navigate or verify the explanation.

## Deliver

Return:

- a plain-language end-to-end narrative;
- a compact flow or state map when relationships are nontrivial;
- ownership and source-of-truth boundaries;
- important invariants and failure seams;
- uncertain or undocumented behavior;
- focused follow-up questions or experiments.

Do not propose a replacement architecture or edit code unless the user transitions to change design.
