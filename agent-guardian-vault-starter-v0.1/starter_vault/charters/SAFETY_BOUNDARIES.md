---
created: 2026-05-03
updated: 2026-05-03
language: en
package: agent-guardian-vault-starter
document_type: charter
---
# SAFETY_BOUNDARIES

Safety boundaries protect user data and project integrity.

## Do Not Modify By Default

Do not modify:

- private vaults
- secrets
- credentials
- real user records
- production databases
- runtime state
- generated backups

Read-only inspection is allowed when the user grants access and the task requires it.

## Copy Before Editing Sensitive Inputs

If a protected source must be transformed, copy the needed content into a project workspace and edit the copy.

## Destructive Actions

Do not run destructive resets or recursive deletes unless the user explicitly requests the exact operation and target.

## Public Release Rule

Never publish:

- real project names that should stay private
- API keys
- private URLs
- private logs
- user identity data
- local machine paths
- personal trading or financial data
