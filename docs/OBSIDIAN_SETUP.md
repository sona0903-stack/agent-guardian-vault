---
created: 2026-05-03
updated: 2026-05-03
language: en
package: agent-guardian-vault-starter
document_type: guide
---
# Obsidian Setup

## Install Obsidian

1. Download Obsidian from the official Obsidian website.
2. Install it for your operating system.
3. Open Obsidian.

No community plugin is required for this starter kit.

## Open The Starter Vault

1. In Obsidian, choose "Open folder as vault".
2. Select the `starter_vault/` folder from this package.
3. Open `HOME.md`.
4. Use `HOME.md` as the main entry point.

You can also copy `starter_vault/` into another folder and open the copy.

## Connect An AI Agent

Start a new chat with your AI agent and paste one of the prompts in `agent_adapters/`.

Minimal prompt:

```text
Read this folder as an Agent Guardian Vault:
<path-to-starter_vault>

Use AGENT_USAGE_MODE.md and start.

New project: photo-editor
Goal: build a small Android photo editor
```

Continuation prompt:

```text
Read this folder as an Agent Guardian Vault:
<path-to-starter_vault>

Continue project: photo-editor
Use the latest project-prefixed handoff, master, decisions, errors, and parts.
```

## Recommended Graph Filter

If the vault grows, hide noisy folders:

```text
-path:templates -path:archives -path:.obsidian
```

The starter already includes this filter in `starter_vault/.obsidian/graph.json`.
It also hides unresolved nodes and orphans by default.

## Recommended Folder Meaning

- `skills/`: reusable operating skills
- `templates/`: scaffold templates
- `charters/`: public reusable rules and invariants
- `projects/`: project memory
- project `master`: status board
- project `handoff`: continuation packet
- project `decisions`: why choices were made
- project `errors`: failures and fixes
- project `parts/`: detailed work notes

## Sync Options

Choose one sync method:

- Obsidian Sync
- Git
- Dropbox, OneDrive, iCloud, or another file sync tool
- manual zip backups

Do not sync secrets, API keys, private logs, or credentials into public repositories.

## Language

The starter is English by default.
To use another language for project-facing notes, tell the agent:

```text
Rewrite the vault-facing project documents in <language>.
Keep the Agent Guardian structure intact.
```

The agent should follow `starter_vault/LANGUAGE_POLICY.md`.
