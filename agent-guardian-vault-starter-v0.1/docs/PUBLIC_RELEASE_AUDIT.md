---
created: 2026-05-03
updated: 2026-05-03
language: en
package: agent-guardian-vault-starter
document_type: guide
---

# Public Release Audit

This document records what the public starter kit includes and what is intentionally excluded.

## Applied

- Public package is English-first.
- Obsidian setup instructions are included.
- Agent start prompts are included for multiple agent styles.
- Public reusable charters are grouped under `starter_vault/charters/`.
- `HOME.md` links to hubs rather than every child project note.
- Projects use project-prefixed Markdown file names.
- Project notes use `project: <project>`, `document_type`, and project tags.
- Templates instruct agents to generate project-prefixed files and metadata.
- Language customization is documented in `LANGUAGE_POLICY.md`.
- Graph hygiene and file naming policies are documented.
- Security, privacy, licensing, release, and limitation notes are included.
- Markdown files include created and updated metadata.

## Intentionally Excluded

- Private vault content.
- Real user projects.
- Personal machine paths.
- Secrets, API keys, tokens, passwords, and credentials.
- Real runtime state.
- Private logs.
- Paid service dependency setup.
- Runtime installers for Node, Python, Docker, Android SDK, or model providers.

## Known Non-Goals

This starter does not enforce behavior by itself.
It gives agents a durable operating structure.
Users still need to verify outputs and keep private data out of public releases.

## Identity Fields

Current release metadata:

- Maintainer: `learningAI26`
- Contact email: `sona0903@gmail.com`
- Repository owner used in citation URL: `sona0903-stack`

## Review Result

Release candidate status: ready for final human review.
