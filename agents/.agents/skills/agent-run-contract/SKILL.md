---
name: agent-run-contract
description: Create a formal agent-run contract only when the user explicitly requests one or invokes this skill. Do not load merely because a task is multi-step, risky, or long-running.
---

# Agent run contract

Create a compact contract that lets the work continue without repeatedly asking the user to reconstruct its intent.

Use the requirements below directly. Consult [references/contract-template.md](references/contract-template.md) only if a requested contract format needs it; do not reread it if already in context. Do not mechanically preserve empty fields.

## Contract before action

Resolve from the request and repository context:

- the bottom-line outcome, not merely the requested activity;
- the workflow mode: investigate, design, implement, verify, release, or respond to an incident;
- environment and allowed mutations;
- authoritative evidence and relevant constraints;
- observable acceptance criteria;
- explicit exclusions and phase boundaries;
- decisions the agent may make autonomously;
- conditions requiring user input;
- a proportionate time/checkpoint budget.

Make reasonable, reversible choices without asking. Ask only when a missing decision would materially change product behavior, require new authority, or make the result unsafe.

For an implementation request whose behavior is still ambiguous, contract for discovery or design first. Do not hide product decisions inside code changes.

## Maintain the contract

Keep the contract in the conversation for short runs. For long or interruptible work, write it to a task-state file in a user-approved or repository-appropriate location.

As work proceeds:

- add newly stated requirements to the acceptance ledger;
- record consequential reversible decisions;
- distinguish newly discovered facts from scope additions;
- return to design when a discovery changes intended behavior;
- request authority immediately before an external or destructive mutation when it was not already granted;
- stop at the declared phase boundary.

Do not let a request to diagnose silently become permission to fix, or a request to implement become permission to deploy.

## Completion

Complete the run only when each acceptance criterion has evidence or an explicit unverified status. Report:

- outcome and current status;
- criteria proved and how;
- unresolved risks or unknowns;
- artifacts and exact revision, when applicable;
- the next workflow and any authority it requires.

Do not use activity, code volume, commits, or elapsed effort as proof of completion.
