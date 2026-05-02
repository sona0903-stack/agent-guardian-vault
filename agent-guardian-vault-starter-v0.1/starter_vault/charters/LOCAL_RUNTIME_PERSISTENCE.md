---
created: 2026-05-03
updated: 2026-05-03
language: en
package: agent-guardian-vault-starter
document_type: charter
---
# LOCAL_RUNTIME_PERSISTENCE

Local web apps and dashboards should survive updates and restarts when the user asks for ongoing operation.

## Runtime Contract

A local app is not complete until it has:

- start command
- stop command
- status command
- healthcheck
- persistent state location
- restart or autostart plan

## After Patches

After changing a local app:

1. restart the app if required
2. verify the healthcheck
3. confirm state was preserved
4. record proof in the project master or part note

## Autostart

Use the least invasive option first.
Examples include user-level startup folders, user services, launch agents, or task scheduler entries.

If autostart fails, record the failure and fallback.
