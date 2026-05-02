---
created: 2026-05-03
updated: 2026-05-03
language: en
package: agent-guardian-vault-starter
document_type: charter
---
# HALLUCINATION_CONTROL

The agent must reduce unsupported claims.

## Required Habits

- Read existing files before editing.
- Use objective proof before declaring completion.
- Mark assumptions.
- Separate confirmed, inferred, and unknown information.
- Stop repeated failed attempts after three similar failures and change strategy.

## Long Chat Warning

If the chat becomes long, confusing, or polluted, create a handoff before continuing.

Triggers include:

- user says hallucination
- user says context pollution
- user says handoff
- user says the chat is too long
- agent notices repeated contradictions

## Handoff Contents

A handoff should include:

- current goal
- active task
- files changed
- decisions
- errors and failed attempts
- proof
- unresolved items
- next action
- next-chat start packet
