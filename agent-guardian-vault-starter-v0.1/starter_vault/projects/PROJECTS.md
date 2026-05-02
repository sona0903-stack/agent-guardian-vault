---
created: 2026-05-03
updated: 2026-05-03
language: en
package: agent-guardian-vault-starter
document_type: project-index
---
# Project Index

Each project gets one folder under `projects/`.

Recommended structure:

```text
projects/<project>/
|-- <project>_master.md
|-- <project>_handoff.md
|-- <project>_decisions.md
|-- <project>_errors.md
|-- <project>_registry.md
`-- parts/
    `-- <project>_part_1_initial.md
```

The project code can live outside the vault.
The vault stores memory, decisions, evidence, handoff, and human-readable status.

## Current Sample

- [[projects/example-project/example-project_master|example-project]]

## Naming Rule

Use project-prefixed file names for project memory files.
Every project note should include a `project: <project>` field and a `project/<project>` tag.

This avoids ambiguous Obsidian graph nodes when the vault contains many projects.
