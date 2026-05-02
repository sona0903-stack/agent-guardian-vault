---
created: 2026-05-03
updated: 2026-05-03
language: en
package: agent-guardian-vault-starter
document_type: vault-policy
---
# MULTI_AGENT_HARNESS

This harness can be used by one model or by multiple agents.

## Roles

## Supervisor

- keeps one active task
- protects invariants
- blocks destructive actions
- prevents success claims without proof
- changes strategy after repeated failure

## Explorer

- reads files, logs, docs, and state
- separates confirmed facts, inference, and unknowns
- does not edit files

## Worker

- edits or creates files
- prefers targeted patches
- avoids broad rewrites
- records failures

## Reviewer

- checks tests, proofs, links, and regressions
- verifies that docs match the actual change
- calls out unresolved risk

## Archivist

- keeps master light
- writes part notes and handoff
- preserves decisions, errors, and failed attempts
- promotes reusable patterns

## Failure Routing

1. Preserve the error text or a faithful summary.
2. Search decisions and errors for similar failures.
3. Write at least two hypotheses.
4. Try the safest targeted fix.
5. If it fails, record it under failed attempts.
6. After two similar failures, re-diagnose.
7. After three similar failures, switch strategy.

## Multi-Agent Use

If an agent platform supports subagents, split work by role or file ownership.

If it does not support subagents, the same model should simulate these roles in order:

Supervisor -> Explorer -> Worker -> Reviewer -> Archivist
