---
created: 2026-05-03
updated: 2026-05-03
language: en
package: agent-guardian-vault-starter
document_type: charter
---
# OPENHANDS_REBIRTH_POLICY

OpenHands-style agents can need a rebirth structure because they combine several failure surfaces:

- long chat context
- local or remote LLM context limits
- Docker or sandbox runtime state
- agent server state
- UI/API transport state
- project files mounted into the sandbox

Other coding agents may only need a handoff between chats.
OpenHands often needs both handoff and runtime rebirth.

## Non-Goal

This starter does not install or manage OpenHands automatically.
It defines the memory and safety contract that an OpenHands launcher, script, or human operator should follow.

## Required State Split

Keep durable memory and runtime state separate.

- durable memory: vault project notes, master, handoff, decisions, errors, parts
- runtime state: container name, sandbox id, port, runtime logs, API ids, process ids

Never store secrets in Markdown.
Use placeholder names or local secret stores instead.

## Runtime State Fields

If OpenHands is used, keep a project-local runtime state file based on:

- `starter_vault/templates/openhands_runtime_state.template.json`

Recommended fields:

- `project_slug`
- `transport_mode`
- `openhands_url`
- `container_name`
- `runtime_name_prefix`
- `sandbox_id`
- `agent_server_url`
- `conversation_id`
- `latest_event_id`
- `start_task_id`
- `runtime_id_file`
- `project_runtime_dir`
- `last_verified_at`
- `status`

If a field is unavailable, write `null` or `unknown`.
Do not pretend unavailable state exists.

## Rebirth Triggers

Use rebirth or handoff when any of these happen:

- context is near the chosen limit
- the agent repeats the same error pattern several times
- the agent stalls and no useful file/log/runtime activity is visible
- the sandbox or container becomes unhealthy
- transport fails repeatedly
- the user reports hallucination, drift, contamination, or loss of task state

Thresholds are model- and deployment-specific.
Record the threshold values used by the project instead of assuming one universal number.

## Completion Check Before Rebirth

Before rebooting, restarting, or creating a new chat, always check whether the task is already complete.

Completion needs evidence:

- files or outputs exist
- verification was run or a clear reason is recorded
- master/handoff says what is done
- unresolved issues are not hidden

Do not rebirth a finished task just because the session is long.

## Recovery Ladder

Use the least destructive recovery first.

1. Observe current work and logs.
2. If the sandbox is still doing useful work, wait.
3. Send a short recovery instruction.
4. If recovery fails, write handoff.
5. Restart only the affected runtime if possible.
6. Start a new chat or session using the handoff.

Never delete global OpenHands sessions as a default recovery step.
Never reset project files to hide a failure.

## Handoff Requirements

An OpenHands rebirth handoff must include:

- current project and active task
- last known good state
- changed files
- commands attempted
- failed attempts
- runtime state summary
- unresolved problems
- exact next start packet

Use project-prefixed handoff files.

## Transport Rule

If an implementation supports both UI and API transport:

- `transport_mode` must be explicit
- allowed values should be documented
- unsupported transport must fail visibly
- UI automation should be treated as fallback, not the primary reliability layer

## Operator Rule

OpenHands rebirth is an operations pattern, not a promise that every OpenHands deployment can resume perfectly.
When resume is impossible, say so and preserve the best available handoff.
