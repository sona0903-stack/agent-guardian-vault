---
created: 2026-05-03
updated: 2026-05-06
language: en
package: agent-guardian-vault-starter
document_type: documentation
---
# Start Here

This folder is a public starter kit for an Agent Guardian Vault.
It is not tied to a single AI tool.
It can be used with Codex, Claude Code, ChatGPT, OpenHands, Cursor, local LLM agents, or a custom multi-agent harness.

## Fastest Setup

Use the visible installer first if possible.
It shows step-by-step progress, warnings, failures, and the final log path.

Windows:

```text
installers/windows/Install_Agent_Guardian.bat
```

macOS:

```bash
chmod +x installers/mac/Install_Agent_Guardian.command
installers/mac/Install_Agent_Guardian.command
```

If macOS blocks the file, open it with right-click / Control-click, choose **Open**, and approve it once.
If the file lost execute permission after download, run the `chmod +x` command above before double-clicking it.

Manual setup:

1. Install Obsidian.
2. Open `starter_vault/` as an Obsidian vault.
3. Start a new chat with your AI agent.
4. Paste a prompt from `agent_adapters/`.
5. Give a new project name and goal, or ask to continue an existing project.

New project prompt:

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

## What This Vault Does

- preserves project memory
- records user commands before work
- keeps one active task visible
- stores decisions and failed attempts
- creates handoff packets for long chats
- reduces Obsidian graph clutter with project-prefixed files
- keeps reusable rules separate from project-specific notes

## What This Vault Does Not Do

This vault is not a runtime installer.
It does not install Node, Python, Docker, Android SDK, model providers, or local LLM servers.
Those dependencies belong to each project.

The included setup installers only prepare the vault, Obsidian connection, first project memory scaffold, and agent start prompt.

## Before Publishing Your Fork

Replace:

- `CONTACT.md`: maintainer name and email
- `LICENSE`: copyright holder name or handle
- `CITATION.cff`: author name, GitHub ID, and repository URL

Also remove any private project notes before publishing.
