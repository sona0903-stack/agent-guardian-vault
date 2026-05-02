---
created: 2026-05-03
updated: 2026-05-03
language: en
package: agent-guardian-vault-starter
document_type: charter
---
# SECRET_HANDLING

Secrets must stay out of Markdown history unless explicitly encrypted by the application.

## Secret Examples

- API keys
- passwords
- OAuth tokens
- database URLs
- private server URLs
- personal account identifiers

## Frontend Input Rule

If a project needs secrets, prefer a user-facing input flow:

- web app form
- desktop app settings screen
- mobile app settings screen
- local HTML settings page

The app should store secrets encrypted or in the operating system secret store when practical.
Docs should store placeholders only.

## Documentation Rule

Use placeholders:

```text
<YOUR_API_KEY>
<YOUR_EMAIL>
<YOUR_PRIVATE_URL>
```

Do not write real secrets into project notes, ledgers, examples, screenshots, or release bundles.
