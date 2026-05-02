---
created: 2026-05-03
updated: 2026-05-03
language: en
package: agent-guardian-vault-starter
document_type: vault-policy
---
# GRAPH_HYGIENE

Obsidian graph view can become noisy when many projects reuse the same file names.

## Rules

- Use project-prefixed memory files.
- Keep templates hidden in graph view.
- Keep `HOME.md` as a small hub, not a link list for every child note.
- Keep `projects/PROJECTS.md` as the project index.
- Keep each project master as the project hub.
- Do not create new policy files for one-off tasks.
- Prefer updating existing policies when the role is the same.
- Do not copy global charters into each project by default.
- If a project needs a local charter fork, prefix it with the project slug and record why in the registry.

## Recommended Graph Filter

```text
-path:templates -path:archives -path:.obsidian
```

## Naming Examples

Use:

- `photo-editor_master.md`
- `photo-editor_handoff.md`
- `photo-editor_decisions.md`
- `photo-editor_errors.md`
- `photo-editor_registry.md`
- `parts/photo-editor_part_1_initial.md`

Avoid:

- `handoff.md`
- `decisions.md`
- `errors.md`
- `registry.md`
- `part_1_initial.md`

## Link Shape

Preferred link shape:

```text
HOME.md
|-- AGENT_USAGE_MODE.md
|-- charters/CHARTER_HUB.md
|-- projects/PROJECTS.md
`-- projects/<project>/<project>_master.md
    |-- <project>_handoff.md
    |-- <project>_decisions.md
    |-- <project>_errors.md
    |-- <project>_registry.md
    `-- parts/<project>_part_1_initial.md
```

Avoid linking every project child note from `HOME.md` or `projects/PROJECTS.md`.
That creates forced-looking graph edges and makes unrelated projects appear more connected than they are.

## Floating Nodes

Floating nodes are acceptable for drafts, templates, or archived notes when they are hidden by graph filters.
Floating project memory notes are usually a bug.
Fix them by adding:

- a link from the project master
- `project: <project>` frontmatter
- `project/<project>` tag
- a project-prefixed file name
