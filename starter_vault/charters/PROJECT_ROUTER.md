---
created: 2026-05-03
updated: 2026-05-03
language: en
package: agent-guardian-vault-starter
document_type: charter
---
# PROJECT_ROUTER

The project router decides where a task belongs.

## Inputs

Minimum new project input:

```text
New project: <project>
Goal: <goal>
```

Minimum continuation input:

```text
Continue project: <project>
```

## Routing Rules

If `projects/<project>/` exists, continue that project.
Read the project master, handoff, decisions, errors, registry, and the recent part notes needed for the task.

If the project does not exist, scaffold:

- `projects/<project>/<project>_master.md`
- `projects/<project>/<project>_handoff.md`
- `projects/<project>/<project>_decisions.md`
- `projects/<project>/<project>_errors.md`
- `projects/<project>/<project>_registry.md`
- `projects/<project>/parts/<project>_part_1_initial.md`

## Isolation Rule

Do not link a project note directly to another project unless the user asks for cross-project comparison or shared pattern extraction.

Use shared skills, charters, and patterns through the common vault hubs.
Keep project-specific records inside the project folder.
