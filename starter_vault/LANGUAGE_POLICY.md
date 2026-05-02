---
created: 2026-05-03
updated: 2026-05-03
language: en
package: agent-guardian-vault-starter
document_type: vault-policy
---
# LANGUAGE_POLICY

This vault is English by default for public distribution.
Users can ask the agent to localize vault-facing output into any preferred language.

## User Command

The user may say:

```text
Rewrite the vault-facing project documents in <language>.
Keep the Agent Guardian structure intact.
```

The agent must then update the project-facing documents, status pages, and human-readable summaries in the requested language.

## Stable Technical Fields

Keep stable technical keys in English unless the user explicitly requests full localization:

- `active_task`
- `status`
- `current_part`
- `latest_user_command`
- `files_touched`
- `decisions`
- `unresolved`
- `proof`
- `next_action`

Do not translate:

- code identifiers
- commands
- package names
- file paths
- environment variable names
- API field names

## Link Safety

If file titles or file names are localized, the agent must update:

- wikilinks
- registry entries
- project master links
- handoff links
- tags
- file naming notes

If the user only wants the visible prose translated, keep file names and slugs unchanged.

## Required Record

Every language change must record:

- previous language
- new language
- scope
- date
- user command
- files changed
- proof that links still resolve

## Recommended Default

For public templates, keep file names in English and localize only the content.
This keeps GitHub, scripts, and cross-agent use predictable.
