---
name: flow-protection
description: Configure a formal supervision and checkpoint policy only when the user explicitly requests that workflow or invokes this skill. Ordinary autonomous work, long tasks, and status questions do not require loading this skill.
---

# Flow protection

Make the run reviewable without making the user watch it.

## Establish the supervision budget

At the start of the run, determine:

- the durable objective and current phase;
- what the agent may decide without interruption;
- which events genuinely require user input;
- the next useful review artifact;
- a maximum silent interval appropriate to the task;
- retry and blocker limits;
- the maximum concurrent lanes.

Default to one implementation lane and, when it materially helps, one independent research or review lane. More concurrency is not free when the user must reconcile it.

## Work autonomously

Continue through ordinary reversible decisions, local failures, and expected test iteration. Record decisions in a durable task-state artifact for long runs.

Do not interrupt for:

- naming, file placement, or implementation choices already implied by repository conventions;
- whether to run relevant local checks;
- minor reversible tradeoffs inside the accepted contract;
- status updates that contain no decision or reviewable artifact.

Interrupt for:

- a product choice that changes observable behavior;
- missing authority for an external, production, destructive, or otherwise consequential action;
- evidence that invalidates the agreed approach;
- a blocker that survives the declared retry limit;
- scope that cannot fit without sacrificing an acceptance criterion.

Use concise progress updates at meaningful phase changes. Do not expose a stream of micro-decisions.

## Prevent context reloads

For an interruptible run, maintain:

- current phase and next action;
- acceptance ledger;
- decisions and reasons;
- commands/checks already run and their results;
- changed files or artifacts;
- blockers and required authority.

After a pause, resume from this state rather than asking the user to restate the task.

## Handoff

Return at a review boundary with an evidence-bearing artifact: causal map, design decision, red/green reproduction, verified diff, or deployment observation. State what needs review and what can proceed unattended next.

Flow protection never weakens verification, hides uncertainty, or broadens authority.
