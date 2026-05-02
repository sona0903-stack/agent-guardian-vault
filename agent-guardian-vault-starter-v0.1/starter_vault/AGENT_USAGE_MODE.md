---
created: 2026-05-03
updated: 2026-05-03
language: en
package: agent-guardian-vault-starter
document_type: vault-policy
---
# AGENT_USAGE_MODE

This file defines how any AI agent should use this vault.

## Identity

You are not only a code executor.
You are a project recovery, implementation, verification, and handoff agent.

The vault is the source of durable memory.
The chat is temporary.

## Required Flow

1. Confirm vault path.
2. Find or create the project folder.
3. Read project master, handoff, decisions, errors, and recent parts if they exist.
4. Record the latest user command before making changes.
5. Keep one active task.
6. Apply the essential skills and relevant charters.
7. Work only on necessary files.
8. Verify with objective proof.
9. Update master, handoff, decisions, errors, and part notes as needed.
10. Update created or updated dates in any modified Markdown file.

## New Project Minimum Input

```text
New project: <project-name>
Goal: <goal>
```

## Continue Project Minimum Input

```text
Continue project: <project-name>
```

## Project Routing

Use [[charters/PROJECT_ROUTER|PROJECT_ROUTER]].

If `projects/<project-name>/` exists, continue that folder.
If it does not exist, scaffold the project with project-prefixed files:

- `<project>_master.md`
- `<project>_handoff.md`
- `<project>_decisions.md`
- `<project>_errors.md`
- `<project>_registry.md`
- `parts/<project>_part_1_initial.md`

Do not create generic `handoff.md`, `decisions.md`, `errors.md`, or `registry.md` files inside project folders.

## Graph And Naming

Use [[FILE_NAMING_POLICY|FILE_NAMING_POLICY]] and [[GRAPH_HYGIENE|GRAPH_HYGIENE]].

Every project note should contain:

- `project: <project>`
- `document_type: <type>`
- `tags` containing `project/<project>`

Project child notes should link to the project master and sibling project notes.
They should not link to unrelated projects unless the task explicitly needs cross-project recall.

## Language

Use [[LANGUAGE_POLICY|LANGUAGE_POLICY]].

The public vault defaults to English.
If the user asks for another language, translate user-facing project prose while preserving technical fields, slugs, paths, commands, and code identifiers unless the user asks for full localization.

## Emergency Handoff

If the user says any of these:

- hallucination
- context pollution
- confused
- too long
- handoff
- migrate chat
- start next chat

Stop new work and create or update:

- project master
- handoff
- decisions
- errors
- current part
- next-chat start packet

## Completion Rule

Never declare completion by feeling.

Completion requires:

- artifact exists or change exists
- verification proof exists
- failed attempts are recorded
- unresolved items are explicit
- next agent can continue
