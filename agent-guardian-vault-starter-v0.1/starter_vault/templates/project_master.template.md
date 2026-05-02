---
created: "{{created_date}}"
updated: "{{updated_date}}"
language: "{{language}}"
project: "{{project}}"
document_type: master
tags:
  - agent-guardian/project
  - project/{{project}}
  - doc/master
---

# {{project_readable_name}} - Master

## State

- project: {{project}}
- active_task: {{active_task}}
- status: {{status}}
- current_part: [[parts/{{project}}_{{current_part}}|{{current_part}}]]
- latest_user_command: {{latest_user_command}}

## Command Log

- {{date}}: {{user_command}}

## Decisions

- {{decision_or_none}}

## Files Touched

- {{file_or_none}}: {{summary}}

## Proof

- {{proof_or_not_verified}}

## Unresolved

- {{unresolved_or_none}}

## Next Action

- {{next_action}}

## Links

- project index: [[projects/PROJECTS|Project Index]]
- handoff: [[{{project}}_handoff|handoff]]
- decisions: [[{{project}}_decisions|decisions]]
- errors: [[{{project}}_errors|errors]]
- registry: [[{{project}}_registry|registry]]
- current part: [[parts/{{project}}_{{current_part}}|{{current_part}}]]
