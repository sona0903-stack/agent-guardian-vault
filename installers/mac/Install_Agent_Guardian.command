#!/usr/bin/env bash
set -Euo pipefail

REPO_URL="https://github.com/sona0903-stack/agent-guardian-vault"
TOTAL_STEPS=10
STEP_NUMBER=0
LOG_ROOT="${HOME}/agent_guardian_install_logs"
LOG_FILE="${LOG_ROOT}/install_$(date +%Y%m%d_%H%M%S).log"
mkdir -p "${LOG_ROOT}"

log() {
  local level="$1"
  shift
  local msg="$*"
  local stamp
  stamp="$(date '+%Y-%m-%d %H:%M:%S')"
  printf '[%s] [%s] %s\n' "${stamp}" "${level}" "${msg}" | tee -a "${LOG_FILE}"
}

step() {
  STEP_NUMBER=$((STEP_NUMBER + 1))
  echo
  printf '==== [%s/%s] %s ====\n' "${STEP_NUMBER}" "${TOTAL_STEPS}" "$1"
  log "INFO" "Step ${STEP_NUMBER}/${TOTAL_STEPS}: $1"
}

ask_default() {
  local prompt="$1"
  local default="$2"
  local answer
  read -r -p "${prompt} [${default}]: " answer
  if [ -z "${answer}" ]; then
    printf '%s' "${default}"
  else
    printf '%s' "${answer}"
  fi
}

ask_yes_no() {
  local prompt="$1"
  local default_yes="$2"
  local suffix="y/N"
  local answer
  if [ "${default_yes}" = "yes" ]; then
    suffix="Y/n"
  fi
  read -r -p "${prompt} [${suffix}]: " answer
  answer="$(printf '%s' "${answer}" | tr '[:upper:]' '[:lower:]')"
  if [ -z "${answer}" ]; then
    [ "${default_yes}" = "yes" ]
    return
  fi
  [ "${answer}" = "y" ] || [ "${answer}" = "yes" ]
}

run_visible() {
  local label="$1"
  shift
  log "INFO" "Running: ${label}"
  "$@"
}

find_obsidian() {
  if [ -d "/Applications/Obsidian.app" ]; then
    printf '%s' "/Applications/Obsidian.app"
    return 0
  fi
  return 1
}

repo_root_from_script() {
  local script_dir
  script_dir="$(cd "$(dirname "$0")" && pwd)"
  local repo_root
  repo_root="$(cd "${script_dir}/../.." 2>/dev/null && pwd || true)"
  if [ -n "${repo_root}" ] && [ -d "${repo_root}/starter_vault" ]; then
    printf '%s' "${repo_root}"
    return 0
  fi
  return 1
}

ensure_source_vault() {
  local repo_root
  if repo_root="$(repo_root_from_script)"; then
    SOURCE_REPO_ROOT="${repo_root}"
    SOURCE_VAULT="${repo_root}/starter_vault"
    log "OK" "Using bundled starter_vault: ${SOURCE_VAULT}"
    return 0
  fi

  local cache_root="${HOME}/.agent_guardian_installer_source"
  if command -v git >/dev/null 2>&1; then
    if [ -d "${cache_root}/.git" ]; then
      run_visible "git pull latest starter" git -C "${cache_root}" pull --ff-only
    else
      if [ -e "${cache_root}" ]; then
        cache_root="${HOME}/.agent_guardian_installer_source_$(date +%Y%m%d_%H%M%S)"
      fi
      run_visible "git clone ${REPO_URL}" git clone "${REPO_URL}" "${cache_root}"
    fi
    SOURCE_REPO_ROOT="${cache_root}"
    SOURCE_VAULT="${cache_root}/starter_vault"
    return 0
  fi

  log "WARN" "Git was not found. Falling back to zip download."
  local zip_path="/tmp/agent-guardian-vault-main.zip"
  local extract_root="/tmp/agent-guardian-vault-$(date +%Y%m%d_%H%M%S)"
  mkdir -p "${extract_root}"
  run_visible "download repository zip" curl -L "${REPO_URL}/archive/refs/heads/main.zip" -o "${zip_path}"
  run_visible "extract repository zip" unzip -q "${zip_path}" -d "${extract_root}"
  SOURCE_REPO_ROOT="$(find "${extract_root}" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
  SOURCE_VAULT="${SOURCE_REPO_ROOT}/starter_vault"
}

copy_no_overwrite() {
  local source="$1"
  local dest="$2"
  local copied=0
  local skipped=0
  mkdir -p "${dest}"
  while IFS= read -r -d '' item; do
    local rel="${item#${source}/}"
    local target="${dest}/${rel}"
    if [ -d "${item}" ]; then
      mkdir -p "${target}"
      continue
    fi
    mkdir -p "$(dirname "${target}")"
    if [ -e "${target}" ]; then
      skipped=$((skipped + 1))
      continue
    fi
    cp -p "${item}" "${target}"
    copied=$((copied + 1))
  done < <(find "${source}" -mindepth 1 -print0)
  COPY_COPIED="${copied}"
  COPY_SKIPPED="${skipped}"
}

slugify() {
  printf '%s' "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E 's/[^a-z0-9._-]+/-/g; s/^-+//; s/-+$//'
}

write_if_missing() {
  local path="$1"
  local content="$2"
  if [ -e "${path}" ]; then
    log "WARN" "Skipped existing file: ${path}"
    return 0
  fi
  mkdir -p "$(dirname "${path}")"
  printf '%s\n' "${content}" > "${path}"
  log "OK" "Created: ${path}"
}

create_project() {
  local vault_root="$1"
  local slug="$2"
  local goal="$3"
  local language="$4"
  local today
  today="$(date +%Y-%m-%d)"
  local project_dir="${vault_root}/projects/${slug}"
  local parts_dir="${project_dir}/parts"
  mkdir -p "${parts_dir}"

  write_if_missing "${project_dir}/${slug}_master.md" "---
created: ${today}
updated: ${today}
language: ${language}
project: ${slug}
document_type: master
tags:
  - agent-guardian/project
  - project/${slug}
  - doc/master
---

# ${slug} - Master

## State

- project: ${slug}
- active_task: initialize project memory
- status: active
- current_part: [[parts/${slug}_part_1_initial|part_1_initial]]
- latest_user_command: create project scaffold from installer

## Goal

- ${goal}

## Command Log

- ${today}: Project scaffold created by visible installer.

## Decisions

- Use project-prefixed memory files.

## Proof

- Installer created the project memory files without overwriting existing files.

## Unresolved

- Add real project-specific constraints after the first agent session.

## Next Action

- Paste the generated agent start prompt into your AI coding agent.

## Links

- project index: [[../PROJECTS|Project Index]]
- handoff: [[${slug}_handoff|handoff]]
- decisions: [[${slug}_decisions|decisions]]
- errors: [[${slug}_errors|errors]]
- registry: [[${slug}_registry|registry]]
- current part: [[parts/${slug}_part_1_initial|part_1_initial]]"

  write_if_missing "${project_dir}/${slug}_handoff.md" "---
created: ${today}
updated: ${today}
language: ${language}
project: ${slug}
document_type: handoff
tags:
  - agent-guardian/project
  - project/${slug}
  - doc/handoff
---

# ${slug} - Handoff

## Project

- name: ${slug}
- master: [[${slug}_master|master]]
- status: active
- active_task: initialize project memory

## Current State

- Project scaffold was created by the installer.

## Latest Proof

- Project memory files exist under this project folder.

## Next Chat Start Packet

\`\`\`text
Read this folder as an Agent Guardian Vault:
${vault_root}

Continue project: ${slug}
Use AGENT_USAGE_MODE.md, latest project-prefixed handoff, master, decisions, errors, and recent parts.
\`\`\`"

  write_if_missing "${project_dir}/${slug}_decisions.md" "---
created: ${today}
updated: ${today}
language: ${language}
project: ${slug}
document_type: decision-ledger
tags:
  - agent-guardian/project
  - project/${slug}
  - doc/decision-ledger
---

# ${slug} - Decisions

Project master: [[${slug}_master|master]]

## ${today} | Project scaffold initialized

- Context: The user created this project through the visible installer.
- Decision: Keep memory files project-prefixed and local-first.
- Reason: Project-specific context should stay easy to inspect and continue."

  write_if_missing "${project_dir}/${slug}_errors.md" "---
created: ${today}
updated: ${today}
language: ${language}
project: ${slug}
document_type: error-ledger
tags:
  - agent-guardian/project
  - project/${slug}
  - doc/error-ledger
---

# ${slug} - Errors

Project master: [[${slug}_master|master]]

No errors recorded yet."

  write_if_missing "${project_dir}/${slug}_registry.md" "---
created: ${today}
updated: ${today}
language: ${language}
project: ${slug}
document_type: registry
tags:
  - agent-guardian/project
  - project/${slug}
  - doc/registry
---

# ${slug} - Registry

Project master: [[${slug}_master|master]]

## Project Names

| Name | Role | Notes |
| --- | --- | --- |
| ${slug} | project slug | Created by installer. |"

  write_if_missing "${parts_dir}/${slug}_part_1_initial.md" "---
created: ${today}
updated: ${today}
language: ${language}
project: ${slug}
document_type: part
part_number: \"1\"
tags:
  - agent-guardian/project
  - project/${slug}
  - doc/part
---

# ${slug} - Part 1 Initial

Project master: [[${slug}_master|master]]

## Goal

- ${goal}

## Work

- Initial project memory scaffold created.

## Proof

- Project files exist under projects/${slug}.

## Next Action

- Start the first agent session with the generated start prompt."
}

write_agent_prompt() {
  local vault_root="$1"
  local slug="$2"
  local agent="$3"
  local language="$4"
  local prompt_dir="${vault_root}/agent_prompts"
  local prompt_file="${prompt_dir}/START_${slug}_${agent}.txt"
  mkdir -p "${prompt_dir}"
  write_if_missing "${prompt_file}" "Read this folder as an Agent Guardian Vault:
${vault_root}

Use AGENT_USAGE_MODE.md and the charter hub.
Preferred human-facing language: ${language}
Agent profile: ${agent}

Continue project: ${slug}
Use the latest project-prefixed handoff, master, decisions, errors, registry, and recent parts.

Before editing:
1. Read existing project records first.
2. Record the user command.
3. Keep one active task.
4. Preserve failed attempts and proof."
}

fail_handler() {
  local line="$1"
  log "ERROR" "Installer failed near line ${line}."
  echo
  echo "[FAILED] The installer stopped before completion."
  echo "Log file: ${LOG_FILE}"
  echo "Fix the error above, then run the installer again."
  read -r -p "Press Enter to close this window."
}
trap 'fail_handler $LINENO' ERR

echo "========================================"
echo " Agent Guardian Vault macOS Installer"
echo "========================================"
log "INFO" "Log file: ${LOG_FILE}"

step "Check installer source"
ensure_source_vault
if [ ! -d "${SOURCE_VAULT}" ]; then
  log "ERROR" "starter_vault was not found: ${SOURCE_VAULT}"
  exit 1
fi

step "Check Obsidian installation"
if obsidian_path="$(find_obsidian)"; then
  log "OK" "Obsidian found: ${obsidian_path}"
else
  log "WARN" "Obsidian was not found."
  if ask_yes_no "Install Obsidian now?" "yes"; then
    if command -v brew >/dev/null 2>&1; then
      run_visible "brew install --cask obsidian" brew install --cask obsidian
    else
      log "WARN" "Homebrew was not found. Opening the official Obsidian download page."
      open "https://obsidian.md/download"
      read -r -p "Install Obsidian manually, then press Enter to continue."
    fi
  else
    log "WARN" "Continuing without installing Obsidian. You can install it later."
  fi
fi

step "Choose vault location"
DEFAULT_VAULT="${HOME}/workspace/docs/ai_data"
echo "Choose install mode:"
echo "  1. Create or update the default vault path"
echo "  2. Create or update a custom vault path"
echo "  3. Add AgentGuardianVault inside an existing Obsidian vault"
MODE="$(ask_default "Mode" "1")"
if [ "${MODE}" = "2" ]; then
  VAULT_ROOT="$(ask_default "Vault path" "${DEFAULT_VAULT}")"
  OPEN_ROOT="${VAULT_ROOT}"
elif [ "${MODE}" = "3" ]; then
  EXISTING_VAULT="$(ask_default "Existing Obsidian vault path" "${HOME}/Documents")"
  FOLDER_NAME="$(ask_default "Subfolder name inside that vault" "AgentGuardianVault")"
  VAULT_ROOT="${EXISTING_VAULT}/${FOLDER_NAME}"
  OPEN_ROOT="${EXISTING_VAULT}"
else
  VAULT_ROOT="${DEFAULT_VAULT}"
  OPEN_ROOT="${VAULT_ROOT}"
fi
log "INFO" "Install target: ${VAULT_ROOT}"
log "INFO" "Open in Obsidian: ${OPEN_ROOT}"

step "Copy starter vault without overwriting"
copy_no_overwrite "${SOURCE_VAULT}" "${VAULT_ROOT}"
log "OK" "Vault copy complete. copied=${COPY_COPIED}, skipped_existing=${COPY_SKIPPED}"

step "Copy agent adapter prompts"
ADAPTER_SOURCE="${SOURCE_REPO_ROOT}/agent_adapters"
ADAPTER_DEST="${VAULT_ROOT}/agent_prompts/adapters"
if [ -d "${ADAPTER_SOURCE}" ]; then
  copy_no_overwrite "${ADAPTER_SOURCE}" "${ADAPTER_DEST}"
  log "OK" "Adapter copy complete. copied=${COPY_COPIED}, skipped_existing=${COPY_SKIPPED}"
else
  log "WARN" "agent_adapters folder was not found. Skipping adapter copy."
fi

step "Choose language and agent profile"
LANGUAGE="$(ask_default "Preferred human-facing language" "en")"
echo "Agent profile examples: codex, chatgpt, claude-code, cursor, openhands, local-llm"
AGENT_PROFILE="$(ask_default "Agent profile" "codex")"
log "INFO" "Language=${LANGUAGE}, Agent=${AGENT_PROFILE}"

step "Create first project memory"
PROJECT_SLUG="example-project"
if ask_yes_no "Create a first project now?" "yes"; then
  PROJECT_INPUT="$(ask_default "Project name or slug" "example-project")"
  PROJECT_SLUG="$(slugify "${PROJECT_INPUT}")"
  if [ -z "${PROJECT_SLUG}" ]; then
    log "ERROR" "Project slug cannot be empty."
    exit 1
  fi
  PROJECT_GOAL="$(ask_default "Project goal" "Describe the project goal here")"
  create_project "${VAULT_ROOT}" "${PROJECT_SLUG}" "${PROJECT_GOAL}" "${LANGUAGE}"
  write_agent_prompt "${VAULT_ROOT}" "${PROJECT_SLUG}" "${AGENT_PROFILE}" "${LANGUAGE}"
else
  log "WARN" "Skipped first project creation."
fi

step "Write install report"
REPORT_PATH="${VAULT_ROOT}/INSTALL_REPORT.md"
mkdir -p "${VAULT_ROOT}"
cat > "${REPORT_PATH}" <<REPORT
---
created: $(date +%Y-%m-%d)
updated: $(date +%Y-%m-%d)
document_type: install-report
---

# Install Report

- installed_at: $(date '+%Y-%m-%d %H:%M:%S')
- installer: macOS command
- target_vault: ${VAULT_ROOT}
- open_in_obsidian: ${OPEN_ROOT}
- language: ${LANGUAGE}
- agent_profile: ${AGENT_PROFILE}
- log_file: ${LOG_FILE}

## What Happened

- The installer printed each major step to the terminal.
- Existing files were skipped instead of overwritten.
- A project scaffold was offered.
- A start prompt was generated when a project was created.

## If Something Failed

Read the log file above and rerun the installer.
It is designed to continue safely without overwriting existing files.
REPORT
log "OK" "Install report written: ${REPORT_PATH}"

step "Open vault folder"
mkdir -p "${OPEN_ROOT}"
open "${OPEN_ROOT}" || true
if find_obsidian >/dev/null 2>&1; then
  open -a "Obsidian" || true
  log "OK" "Started Obsidian. Use 'Open folder as vault' and select: ${OPEN_ROOT}"
else
  log "WARN" "Obsidian is still not installed. Open this folder after installing it: ${OPEN_ROOT}"
fi

step "Finish"
echo
echo "========================================"
echo "[DONE] Agent Guardian Vault is ready."
echo "Vault path : ${VAULT_ROOT}"
echo "Open path  : ${OPEN_ROOT}"
echo "Log file   : ${LOG_FILE}"
echo "========================================"
read -r -p "Press Enter to close this window."
