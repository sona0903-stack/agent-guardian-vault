---
created: 2026-05-03
updated: 2026-05-03
language: en
package: agent-guardian-vault-starter
document_type: vault-policy
---
# FILE_NAMING_POLICY

File names are part of the graph design.
Clear names reduce duplicate nodes and make Obsidian graph view useful.

## Project Memory Files

Use project-prefixed names:

- `<project>_master.md`
- `<project>_handoff.md`
- `<project>_decisions.md`
- `<project>_errors.md`
- `<project>_registry.md`
- `parts/<project>_part_<number>_<short-name>.md`

Avoid generic names inside project folders:

- `master.md`
- `handoff.md`
- `decisions.md`
- `errors.md`
- `registry.md`
- `part_1_initial.md`

## Tags

Every project note should include tags like:

```yaml
tags:
  - agent-guardian/project
  - project/<project>
  - doc/<type>
```

Use `doc/master`, `doc/handoff`, `doc/decision-ledger`, `doc/error-ledger`, `doc/registry`, or `doc/part`.

## Human-Friendly Titles

The first heading can be more readable than the file name.
For example:

```markdown
# Photo Editor - Master
```

The file name should still keep the stable slug:

```text
photo-editor_master.md
```

## Date In File Names

Dates are optional.
Use dates when a note is a snapshot, daily report, release record, audit, or one-time handoff.

Recommended formats:

- `<project>_YYYY-MM-DD_<topic>.md`
- `<project>_<topic>_YYYYMMDD.md`

Keep the project slug first.
This keeps dated notes grouped with their project in search and graph views.

## Duplicate Handling

If two policy files have the same name and the same role, merge them into one policy and append a dated change log.
If they have different roles, rename them by role rather than leaving duplicate generic nodes.
