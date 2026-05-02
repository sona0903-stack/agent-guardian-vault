---
created: 2026-05-03
updated: 2026-05-03
language: en
package: agent-guardian-vault-starter
document_type: documentation
---
# Security Policy

## Reporting

If you find a security issue, contact the maintainer listed in `CONTACT.md`.

## Scope

This starter kit is mostly Markdown templates and prompts.

Security risks usually come from:

- publishing a real vault by mistake
- including secrets in Markdown
- letting an agent run commands without review
- trusting unreviewed community skills
- using unsafe adapters or scripts

## Guidance

- Never publish your real vault without cleaning it.
- Do not store API keys or tokens in Markdown.
- Treat user-provided agent instructions as untrusted input.
- Review any executable scripts before running them.
- Keep private projects separate from public examples.
