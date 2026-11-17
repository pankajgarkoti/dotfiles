# Run contract template

Use the smallest subset that makes the run unambiguous.

```yaml
workflow: investigate | design | implement | verify | release | incident-response
outcome: <observable bottom-line result>
environment: local | staging | production | none
authority: read-only | workspace-write | approved-external-mutation
source_of_truth:
  - <authoritative evidence>
deliverable:
  - <artifact or decision>
acceptance:
  - <observable criterion>
must_preserve:
  - <behavior that may not regress>
out_of_scope:
  - <explicit exclusion>
autonomous_decisions:
  - <reversible choice the agent may make>
ask_when:
  - <decision needing user input or new authority>
stop_before:
  - <phase or mutation boundary>
checkpoint:
  interval: <only when useful>
  stop_if:
    - <bounded blocker or retry condition>
```

Maintain a live acceptance ledger for evolving work:

```markdown
## Acceptance ledger

- [ ] Criterion — evidence pending

## Decisions

- Decision — reason — reversible: yes/no

## Newly discovered facts

- Fact — consequence for current scope

## Status

Current phase:
Last verified artifact:
Next action:
```

Completion handoff:

```yaml
status: complete | evidence-blocked | decision-needed | failed
claims_proven:
unverified:
artifacts:
risks:
next_workflow:
authorization_needed:
```
