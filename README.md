---
created: 2026-05-03
updated: 2026-05-03
language: en
package: agent-guardian-vault-starter
document_type: documentation
---
# Agent Guardian Vault Starter

Local-first project memory and handoff starter kit for AI coding agents.

This is not a replacement for Codex, Claude Code, ChatGPT, OpenHands, Cursor, or local LLM agents.
It is a small Obsidian-style vault that gives those agents a shared operating layer:

- project memory
- active task tracking
- handoff between chats
- decision and error ledgers
- reusable skills
- anti-overengineering micro-harness
- human-readable project status
- project-prefixed memory files to reduce Obsidian graph ambiguity
- language-customizable project records

OpenHands users should also read the OpenHands rebirth policy.
Unlike simple chat handoff, OpenHands workflows can need runtime/session rebirth because Docker, sandbox, agent server, and transport state can fail independently.
This starter includes the memory and rebirth policy, not a ready-to-run OpenHands automation launcher.
If you want a project-specific OpenHands launcher or recovery harness, contact the maintainer in `CONTACT.md`.

## Quick Start

1. Install Obsidian.
2. Open Obsidian and choose "Open folder as vault".
3. Select the `starter_vault/` folder.
4. Open `HOME.md`.
5. Start a new chat with your AI agent.
6. Paste one of the prompts in `agent_adapters/`.
7. Give either a new project name and goal, or an existing project name.

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
Use the latest handoff, master, decisions, errors, and parts.
```

See `docs/OBSIDIAN_SETUP.md` for the full Obsidian setup path.

## Search Landing Page

The repository includes a lightweight GitHub Pages landing page under `docs/`.
After enabling GitHub Pages with `main` / `docs` as the publishing source, the public page will be:

```text
https://sona0903-stack.github.io/agent-guardian-vault/
```

The landing page includes search metadata, a sitemap, robots instructions, and a short Korean summary for Korean search discovery.

## What This Is

Agent Guardian Vault is a memory harness, not a runtime.

It does not install Node, Python, Android SDK, Docker, or model providers.
Those are still project-specific dependencies, just like with any AI agent framework.
For OpenHands, this also means the repository does not provide a complete Docker/API/UI automation stack.
It provides a policy and template layer that a separate launcher can follow.

## What Makes It Different

Most AI coding tools focus on execution.
This vault focuses on memory, proof, and handoff.

- short tasks stay simple
- long projects keep context
- failed attempts are preserved
- project decisions are visible
- Obsidian graph clutter is reduced
- agents avoid unnecessary rewrites

## Repository Contents

- `starter_vault/`: the Obsidian-style vault users can copy or open
- `agent_adapters/`: start prompts for Codex, Claude Code, ChatGPT, OpenHands, and local LLM agents
- `docs/`: publishing, security, compatibility, and limitation notes
- `starter_vault/charters/`: reusable public operating rules
- `starter_vault/templates/`: project memory templates
- `starter_vault/skills/`: always-on operating skills

## Language Customization

The public starter is English by default.
Users can ask their agent to rewrite vault-facing project documents in any preferred language.

Example:

```text
Rewrite the vault-facing project documents in Korean.
Keep the Agent Guardian structure intact.
```

The agent should preserve stable slugs, file paths, and technical keys unless the user explicitly requests full localization.
See `starter_vault/LANGUAGE_POLICY.md`.

## Compatibility

This project is tool-agnostic.

It can be used with any agent that can read local Markdown files.

See `docs/AGENT_COMPATIBILITY.md` for differences between Codex, Claude Code, ChatGPT, OpenHands, Cursor, and local LLM agents.

## Design Safety

The starter uses project-prefixed memory files such as `<project>_handoff.md`.
This prevents every project from creating identical `handoff`, `decisions`, `errors`, and `registry` nodes in Obsidian graph view.

The home page links to hubs rather than every child note.
Project child notes link through their own project master.
This keeps graph view readable as the vault grows.

## License

This starter kit uses the MIT License by default.
You can change the license before publishing if your goals are different.

See `docs/LICENSING_STRATEGY.md` before publishing if you care about commercial reuse, dual licensing, or keeping advanced tooling private.

## Maintainer And Fork Checklist

Before publishing a fork or a customized version, read:

- `docs/RELEASE_CHECKLIST.md`
- `docs/SECURITY_AND_PRIVACY.md`
- `docs/LIMITATIONS_AND_CONFLICTS.md`
- `docs/LICENSING_STRATEGY.md`
- `docs/PUBLIC_RELEASE_AUDIT.md`

## Commercial Use

Contact information is listed in `CONTACT.md`.
Private setup, team customization, managed vault design, and project-specific OpenHands launcher design can be handled separately.

## Disclaimer

This project is not affiliated with OpenAI, Anthropic, OpenHands, Obsidian, Cursor, or any other referenced product.
Product names are used only for compatibility and documentation purposes.
