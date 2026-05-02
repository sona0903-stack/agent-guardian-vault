---
created: 2026-05-03
updated: 2026-05-03
language: en
package: agent-guardian-vault-starter
document_type: guide
---
# Agent Compatibility

Agent Guardian Vault is tool-agnostic.
It works best with agents that can read and edit local Markdown files.

## Codex

- Good for direct local file edits and verification.
- Use `agent_adapters/CODEX_START.md`.
- Best when the vault path and project name are explicit.

## Claude Code

- Good for repo-level workflows and `CLAUDE.md`.
- Use `agent_adapters/CLAUDE_CODE_CLAUDE.md`.
- Keep the adapter short and point to the vault instead of pasting the whole vault into context.

## ChatGPT

- Good for planning, review, and file-aware work when local file access is available.
- Use `agent_adapters/CHATGPT_START.md`.
- If local files are unavailable, paste only the relevant master/handoff/part files.

## OpenHands / Generic Coding Agents

- Good for sandboxed implementation workflows.
- Use `agent_adapters/OPENHANDS_AGENTS.md`.
- Keep runtime state separate from vault memory.
- OpenHands-style deployments may need a rebirth structure because long context, Docker/sandbox state, agent server state, and UI/API transport can fail independently.
- Use `starter_vault/charters/OPENHANDS_REBIRTH_POLICY.md` and `starter_vault/templates/openhands_runtime_state.template.json` when OpenHands is part of the workflow.
- Other agents may only need chat handoff; OpenHands often needs both handoff and runtime rebirth.

## Local LLM Agents

- Good for private/local-first workflows.
- Use `agent_adapters/LOCAL_LLM_START.md`.
- Read top-k relevant files only; do not load the whole vault by default.

## Cursor / Other IDE Agents

- Use the generic adapter pattern.
- Keep project memory in the vault and implementation in the code repo.

## Important Limitation

The vault does not replace runtime dependencies.
Node, Python, Android SDK, Docker, compilers, and model providers remain project-specific.
