---
created: 2026-05-03
updated: 2026-05-03
language: en
package: agent-guardian-vault-starter
document_type: guide
---
# Limitations and Conflicts

This document lists known risks before public release.

## 1. It Is Not a Runtime

The vault does not install dependencies or run tools.

Projects may still require:

- Node
- Python
- Android SDK
- Docker
- compilers
- model providers
- browser automation tools

## 2. Agents May Ignore Instructions

No Markdown system can force an AI agent to behave perfectly.

Mitigation:

- keep prompts short
- verify outputs
- record failed attempts
- use handoff before context gets too long

## 3. Over-Documentation Risk

The vault can become noisy if every small change creates a new policy file.

Mitigation:

- use the coding micro-harness
- update existing files first
- create global policies only when a reusable rule changes

## 4. Graph Clutter Risk

Obsidian graph can become cluttered if templates, archives, and duplicate links are visible.

Mitigation:

- hide templates and archives in graph filters
- keep project cards as hubs
- avoid unlinked policy files

## 5. License Expectations

MIT lets others use, modify, and redistribute the starter.

Mitigation:

- publish only what you are comfortable giving away
- keep private workflows and real project data out of the public repo
- monetize setup, customization, dashboards, and support

## 6. Name Confusion

This project references other tools only for compatibility.

It is not affiliated with OpenAI, Anthropic, OpenHands, Obsidian, Cursor, or any other referenced product.

## 7. Privacy Risk

The biggest risk is accidentally publishing a real vault.

Mitigation:

- run the release checklist
- search for paths, emails, tokens, API keys, and private project names
- publish sample data only
