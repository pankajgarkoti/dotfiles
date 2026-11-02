---
name: environment-forensics
description: Retrieve authoritative state and reconstruct exact interactions from local, staging, or production environments. Use for transcripts, logs, memories, jobs, database rows, tool calls, and user-visible timelines; remain read-only unless a separate explicit mutation is authorized, and stop before root-cause claims.
---

# Environment forensics

Establish what happened or what currently exists using the safest authoritative source.

## Set the evidence boundary

Resolve:

- environment: local, staging, or production;
- exact time window and timezone;
- tenant, user, channel, thread, session, event, job, deployment, or other locator;
- authoritative sources and their freshness;
- access level and secret-handling constraints.

Default production work to read-only sources and replicas. Do not print secrets, connection strings, tokens, or clipboard contents. Obtain new authority immediately before any live mutation.

## Choose the mode

### Evidence lookup

Retrieve the requested records, logs, memories, state, transcript, deployment identity, or configuration. Record query/filter boundaries and identify missing or ambiguous fields.

### Interaction reconstruction

Rebuild the sequence from original request through:

- context and instructions available at the time;
- model/tool decisions and arguments;
- tool results, errors, retries, state transitions, and approvals;
- generated artifacts and delivery attempts;
- user-visible result and subsequent repair.

Preserve ordering and timestamps. Distinguish event time, ingestion time, processing time, and observation time when they differ.

## Evidence discipline

Separate:

- observed facts;
- reasonable inferences;
- claims copied from other actors;
- missing evidence.

Use original tenant/channel/conversation or durable environment identifiers in shared reports. A local export path may aid analysis but should not be the only reference.

## Deliver

Return the scoped evidence bundle, provenance, chronological timeline when requested, and unresolved gaps. Identify the first observable divergence from expected behavior without claiming its technical cause. Hand causal questions to incident RCA.
