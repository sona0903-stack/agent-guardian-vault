---
created: "{{created_date}}"
updated: "{{updated_date}}"
language: "{{language}}"
project: "{{project}}"
document_type: handoff
tags:
  - agent-guardian/project
  - project/{{project}}
  - doc/handoff
---

# {{project_readable_name}} - Handoff

## Project

- name: {{project}}
- master: [[{{project}}_master|master]]
- status: {{status}}
- active_task: {{active_task}}

## Current State

- {{current_state}}

## Latest Proof

- {{proof}}

## Decisions

- {{decisions}}

## Errors / Failed Attempts

- {{errors_or_none}}

## Unresolved

- {{unresolved_or_none}}

## Next Chat Start Packet

```text
Read this folder as an Agent Guardian Vault:
<vault-path>

Continue project: {{project}}
Use AGENT_USAGE_MODE.md, latest project-prefixed handoff, master, decisions, errors, and recent parts.
```
