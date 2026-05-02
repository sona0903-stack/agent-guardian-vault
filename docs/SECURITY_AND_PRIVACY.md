---
created: 2026-05-03
updated: 2026-05-03
language: en
package: agent-guardian-vault-starter
document_type: guide
---
# Security and Privacy

Do not publish your real vault without cleaning it.

Remove:

- personal paths
- secrets
- API keys
- tokens
- logs with credentials
- private project ideas
- client data
- screenshots with sensitive info
- investment records

## Rule

The public starter kit should contain templates and examples only.

## Secret Handling

Agents should not write real secrets into Markdown.

For real projects:

- use environment variables
- use OS credential stores
- use encrypted app settings
- show only `[REDACTED]` in docs and logs
