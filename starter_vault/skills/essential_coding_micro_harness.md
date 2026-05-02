---
created: 2026-05-03
updated: 2026-05-03
language: en
package: agent-guardian-vault-starter
document_type: skill
---
# essential_coding_micro_harness

## When To Use

Use before code, document, structure, link, charter, or template edits.

## Purpose

Reduce:

- hidden assumptions
- unnecessary complexity
- broad rewrites
- unverified completion claims
- over-documentation
- graph clutter

## Gates

## Assumption Gate

- Separate confirmed facts, inference, and unknowns.
- Do not invent paths, versions, or file names.
- If a value is unknown, say so or inspect it.

## Simplicity Gate

- Prefer editing an existing file over creating a new one.
- Prefer local changes over new frameworks.
- Do not add an abstraction for one use.

## Surgical Change Gate

- Every changed line should connect to the user request, a failing test, or an existing policy.
- Do not format, rename, or restructure unrelated files.

## Success Criteria Gate

- Define what proof will count as done.
- Examples: tests pass, healthcheck works, file exists, audit passes, screenshot exists.

## No Over-Documentation Gate

- Small tasks update master, current part, and handoff only if needed.
- Global policies change only when a reusable rule changes.
- New graph nodes must be linked to a project card or policy hub.

## Balance

Safety and user goals outrank simplicity.
Simplicity outranks speculative future-proofing.
