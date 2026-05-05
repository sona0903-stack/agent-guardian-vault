param(
  [switch]$DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$RepoUrl = "https://github.com/sona0903-stack/agent-guardian-vault"
$TotalSteps = 10
$script:StepNumber = 0
$LogRoot = Join-Path $HOME "agent_guardian_install_logs"
$LogFile = Join-Path $LogRoot ("install_" + (Get-Date -Format "yyyyMMdd_HHmmss") + ".log")
New-Item -ItemType Directory -Force -Path $LogRoot | Out-Null

function Write-Log {
  param(
    [string]$Level,
    [string]$Message
  )
  $stamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
  $line = "[$stamp] [$Level] $Message"
  Add-Content -LiteralPath $LogFile -Value $line -Encoding UTF8
  switch ($Level) {
    "OK" { Write-Host $line -ForegroundColor Green }
    "WARN" { Write-Host $line -ForegroundColor Yellow }
    "ERROR" { Write-Host $line -ForegroundColor Red }
    default { Write-Host $line }
  }
}

function Enter-Step {
  param([string]$Title)
  $script:StepNumber += 1
  $percent = [int](($script:StepNumber / $TotalSteps) * 100)
  Write-Progress -Activity "Agent Guardian Vault installer" -Status $Title -PercentComplete $percent
  Write-Host ""
  Write-Host ("==== [{0}/{1}] {2} ====" -f $script:StepNumber, $TotalSteps, $Title) -ForegroundColor Cyan
  Write-Log "INFO" ("Step {0}/{1}: {2}" -f $script:StepNumber, $TotalSteps, $Title)
}

function Read-Default {
  param(
    [string]$Prompt,
    [string]$Default
  )
  if ($DryRun) {
    Write-Log "INFO" "Dry run input: $Prompt = $Default"
    return $Default
  }
  $value = Read-Host "$Prompt [$Default]"
  if ([string]::IsNullOrWhiteSpace($value)) {
    return $Default
  }
  return $value.Trim()
}

function Read-YesNo {
  param(
    [string]$Prompt,
    [bool]$DefaultYes = $true
  )
  if ($DryRun) {
    Write-Log "INFO" "Dry run input: $Prompt = $DefaultYes"
    return $DefaultYes
  }
  $suffix = if ($DefaultYes) { "Y/n" } else { "y/N" }
  $answer = Read-Host "$Prompt [$suffix]"
  if ([string]::IsNullOrWhiteSpace($answer)) {
    return $DefaultYes
  }
  return ($answer.Trim().ToLowerInvariant() -in @("y", "yes"))
}

function Invoke-VisibleCommand {
  param(
    [string]$Label,
    [scriptblock]$Command
  )
  Write-Log "INFO" "Running: $Label"
  if ($DryRun) {
    Write-Log "INFO" "Dry run: skipped command."
    return
  }
  & $Command
  if ($LASTEXITCODE -ne 0 -and $null -ne $LASTEXITCODE) {
    throw "Command failed: $Label"
  }
}

function Find-Obsidian {
  $candidates = @(
    (Join-Path $env:LOCALAPPDATA "Obsidian\Obsidian.exe"),
    (Join-Path $env:ProgramFiles "Obsidian\Obsidian.exe")
  )
  if (${env:ProgramFiles(x86)}) {
    $candidates += (Join-Path ${env:ProgramFiles(x86)} "Obsidian\Obsidian.exe")
  }
  foreach ($candidate in $candidates) {
    if (Test-Path -LiteralPath $candidate) {
      return $candidate
    }
  }
  $cmd = Get-Command "obsidian.exe" -ErrorAction SilentlyContinue
  if ($cmd) {
    return $cmd.Source
  }
  return $null
}

function Get-RepoRoot {
  $scriptRoot = Split-Path -Parent $MyInvocation.ScriptName
  $repoRoot = Resolve-Path -LiteralPath (Join-Path $scriptRoot "..\..") -ErrorAction SilentlyContinue
  if ($repoRoot) {
    return $repoRoot.Path
  }
  return $null
}

function Ensure-SourceVault {
  $repoRoot = Get-RepoRoot
  if ($repoRoot) {
    $localVault = Join-Path $repoRoot "starter_vault"
    if (Test-Path -LiteralPath $localVault) {
      Write-Log "OK" "Using bundled starter_vault: $localVault"
      return @{ RepoRoot = $repoRoot; Vault = $localVault }
    }
  }

  $cacheRoot = Join-Path $HOME ".agent_guardian_installer_source"
  if ($DryRun) {
    Write-Log "WARN" "Dry run: bundled starter_vault not found; would clone or download from $RepoUrl."
    return @{ RepoRoot = $cacheRoot; Vault = (Join-Path $cacheRoot "starter_vault") }
  }

  New-Item -ItemType Directory -Force -Path $cacheRoot | Out-Null
  $git = Get-Command "git.exe" -ErrorAction SilentlyContinue
  if ($git) {
    if (Test-Path -LiteralPath (Join-Path $cacheRoot ".git")) {
      Invoke-VisibleCommand "git pull latest starter" { git -C $cacheRoot pull --ff-only }
    } else {
      if ((Get-ChildItem -LiteralPath $cacheRoot -Force | Measure-Object).Count -gt 0) {
        Write-Log "WARN" "Source cache exists but is not a git repo. It will be left untouched."
        $cacheRoot = Join-Path $HOME (".agent_guardian_installer_source_" + (Get-Date -Format "yyyyMMdd_HHmmss"))
      }
      Invoke-VisibleCommand "git clone $RepoUrl" { git clone $RepoUrl $cacheRoot }
    }
    return @{ RepoRoot = $cacheRoot; Vault = (Join-Path $cacheRoot "starter_vault") }
  }

  Write-Log "WARN" "Git was not found. Falling back to zip download."
  $zipPath = Join-Path $env:TEMP "agent-guardian-vault-main.zip"
  $extractRoot = Join-Path $env:TEMP ("agent-guardian-vault-" + (Get-Date -Format "yyyyMMdd_HHmmss"))
  Invoke-VisibleCommand "download repository zip" {
    Invoke-WebRequest -Uri "$RepoUrl/archive/refs/heads/main.zip" -OutFile $zipPath
  }
  Invoke-VisibleCommand "extract repository zip" {
    Expand-Archive -LiteralPath $zipPath -DestinationPath $extractRoot -Force
  }
  $repo = Get-ChildItem -LiteralPath $extractRoot -Directory | Select-Object -First 1
  return @{ RepoRoot = $repo.FullName; Vault = (Join-Path $repo.FullName "starter_vault") }
}

function Copy-DirectoryNoOverwrite {
  param(
    [string]$Source,
    [string]$Destination
  )
  if (!(Test-Path -LiteralPath $Source)) {
    throw "Source directory not found: $Source"
  }
  if ($DryRun) {
    Write-Log "INFO" "Dry run: would copy $Source to $Destination without overwriting existing files."
    return @{ Copied = 0; Skipped = 0 }
  }
  New-Item -ItemType Directory -Force -Path $Destination | Out-Null
  $copied = 0
  $skipped = 0
  Get-ChildItem -LiteralPath $Source -Recurse -Force | ForEach-Object {
    $relative = $_.FullName.Substring($Source.Length).TrimStart("\")
    if ([string]::IsNullOrWhiteSpace($relative)) {
      return
    }
    $target = Join-Path $Destination $relative
    if ($_.PSIsContainer) {
      New-Item -ItemType Directory -Force -Path $target | Out-Null
      return
    }
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $target) | Out-Null
    if (Test-Path -LiteralPath $target) {
      $skipped += 1
      return
    }
    Copy-Item -LiteralPath $_.FullName -Destination $target
    $copied += 1
  }
  return @{ Copied = $copied; Skipped = $skipped }
}

function Convert-ToSlug {
  param([string]$Name)
  $slug = $Name.Trim().ToLowerInvariant()
  $slug = $slug -replace "[^a-z0-9._-]+", "-"
  $slug = $slug.Trim("-")
  if ([string]::IsNullOrWhiteSpace($slug)) {
    throw "Project slug cannot be empty."
  }
  return $slug
}

function New-TextFileIfMissing {
  param(
    [string]$Path,
    [string]$Content
  )
  if ($DryRun) {
    Write-Log "INFO" "Dry run: would create if missing: $Path"
    return
  }
  if (Test-Path -LiteralPath $Path) {
    Write-Log "WARN" "Skipped existing file: $Path"
    return
  }
  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Path) | Out-Null
  Set-Content -LiteralPath $Path -Value $Content -Encoding UTF8
  Write-Log "OK" "Created: $Path"
}

function New-ProjectScaffold {
  param(
    [string]$VaultRoot,
    [string]$ProjectSlug,
    [string]$Goal,
    [string]$Language
  )
  $today = Get-Date -Format "yyyy-MM-dd"
  $projectDir = Join-Path (Join-Path $VaultRoot "projects") $ProjectSlug
  $partsDir = Join-Path $projectDir "parts"
  $decisionContent = ""
  if (!$DryRun) {
    New-Item -ItemType Directory -Force -Path $partsDir | Out-Null
  }

  $frontMatter = @"
---
created: $today
updated: $today
language: $Language
project: $ProjectSlug
"@

  New-TextFileIfMissing (Join-Path $projectDir "$ProjectSlug`_master.md") @"
$frontMatter
document_type: master
tags:
  - agent-guardian/project
  - project/$ProjectSlug
  - doc/master
---

# $ProjectSlug - Master

## State

- project: $ProjectSlug
- active_task: initialize project memory
- status: active
- current_part: [[parts/$ProjectSlug`_part_1_initial|part_1_initial]]
- latest_user_command: create project scaffold from installer

## Goal

- $Goal

## Command Log

- ${today}: Project scaffold created by visible installer.

## Decisions

- Use project-prefixed memory files.

## Files Touched

- $ProjectSlug`_master.md: created
- $ProjectSlug`_handoff.md: created
- $ProjectSlug`_decisions.md: created
- $ProjectSlug`_errors.md: created
- $ProjectSlug`_registry.md: created
- parts/$ProjectSlug`_part_1_initial.md: created

## Proof

- Installer created the project memory files without overwriting existing files.

## Unresolved

- Add real project-specific constraints after the first agent session.

## Next Action

- Paste the generated agent start prompt into your AI coding agent.

## Links

- project index: [[../PROJECTS|Project Index]]
- handoff: [[$ProjectSlug`_handoff|handoff]]
- decisions: [[$ProjectSlug`_decisions|decisions]]
- errors: [[$ProjectSlug`_errors|errors]]
- registry: [[$ProjectSlug`_registry|registry]]
- current part: [[parts/$ProjectSlug`_part_1_initial|part_1_initial]]
"@

  New-TextFileIfMissing (Join-Path $projectDir "$ProjectSlug`_handoff.md") @"
$frontMatter
document_type: handoff
tags:
  - agent-guardian/project
  - project/$ProjectSlug
  - doc/handoff
---

# $ProjectSlug - Handoff

## Project

- name: $ProjectSlug
- master: [[$ProjectSlug`_master|master]]
- status: active
- active_task: initialize project memory

## Current State

- Project scaffold was created by the installer.

## Latest Proof

- Project memory files exist under this project folder.

## Decisions

- Use project-prefixed files to reduce graph ambiguity.

## Errors / Failed Attempts

- None recorded yet.

## Unresolved

- Add project-specific runtime and dependency notes.

## Next Chat Start Packet

```text
Read this folder as an Agent Guardian Vault:
$VaultRoot

Continue project: $ProjectSlug
Use AGENT_USAGE_MODE.md, latest project-prefixed handoff, master, decisions, errors, and recent parts.
```
"@

  $decisionContent = @"
$frontMatter
document_type: decision-ledger
tags:
  - agent-guardian/project
  - project/$ProjectSlug
  - doc/decision-ledger
---

# $ProjectSlug - Decisions

Project master: [[$ProjectSlug`_master|master]]

## $today | Project scaffold initialized

- Context: The user created this project through the visible installer.
- Decision: Keep memory files project-prefixed and local-first.
- Reason: Project-specific context should stay easy to inspect and continue.
"@
  New-TextFileIfMissing (Join-Path $projectDir ($ProjectSlug + "_decisions.md")) $decisionContent

  New-TextFileIfMissing (Join-Path $projectDir "$ProjectSlug`_errors.md") @"
$frontMatter
document_type: error-ledger
tags:
  - agent-guardian/project
  - project/$ProjectSlug
  - doc/error-ledger
---

# $ProjectSlug - Errors

Project master: [[$ProjectSlug`_master|master]]

No errors recorded yet.

When an error occurs, record symptom, environment, failed attempts, hypotheses, solution, proof, and residual risk.
"@

  New-TextFileIfMissing (Join-Path $projectDir "$ProjectSlug`_registry.md") @"
$frontMatter
document_type: registry
tags:
  - agent-guardian/project
  - project/$ProjectSlug
  - doc/registry
---

# $ProjectSlug - Registry

Project master: [[$ProjectSlug`_master|master]]

## Project Names

| Name | Role | Notes |
| --- | --- | --- |
| $ProjectSlug | project slug | Created by installer. |

## Shared Paths

None yet.
"@

  New-TextFileIfMissing (Join-Path $partsDir "$ProjectSlug`_part_1_initial.md") @"
$frontMatter
document_type: part
part_number: "1"
tags:
  - agent-guardian/project
  - project/$ProjectSlug
  - doc/part
---

# $ProjectSlug - Part 1 Initial

Project master: [[$ProjectSlug`_master|master]]

## User Command

- ${today}: Create project scaffold from installer.

## Goal

- $Goal

## Facts

- Confirmed: The project memory folder was created.
- Inferred: Runtime dependencies will be project-specific.
- Unknown: Exact implementation stack.

## Work

- Initial project memory scaffold created.

## Decisions

- Use local-first Markdown records.

## Failed Attempts

- None recorded yet.

## Proof

- Project files exist under projects/$ProjectSlug.

## Next Action

- Start the first agent session with the generated start prompt.
"@

  $projectsIndex = Join-Path (Join-Path $VaultRoot "projects") "PROJECTS.md"
  if (!$DryRun -and (Test-Path -LiteralPath $projectsIndex)) {
    $indexText = Get-Content -LiteralPath $projectsIndex -Raw
    $link = "- [[projects/$ProjectSlug/$ProjectSlug`_master|$ProjectSlug]]"
    if ($indexText -notmatch [regex]::Escape($link)) {
      Add-Content -LiteralPath $projectsIndex -Value "`n$link" -Encoding UTF8
      Write-Log "OK" "Updated project index: $projectsIndex"
    }
  }
}

function Write-AgentPrompt {
  param(
    [string]$VaultRoot,
    [string]$ProjectSlug,
    [string]$AgentProfile,
    [string]$Language
  )
  $promptDir = Join-Path $VaultRoot "agent_prompts"
  $promptFile = Join-Path $promptDir ("START_" + $ProjectSlug + "_" + $AgentProfile + ".txt")
  $content = @"
Read this folder as an Agent Guardian Vault:
$VaultRoot

Use AGENT_USAGE_MODE.md and the charter hub.
Preferred human-facing language: $Language
Agent profile: $AgentProfile

Continue project: $ProjectSlug
Use the latest project-prefixed handoff, master, decisions, errors, registry, and recent parts.

Before editing:
1. Read existing project records first.
2. Record the user command.
3. Keep one active task.
4. Preserve failed attempts and proof.
"@
  New-TextFileIfMissing $promptFile $content
}

try {
  Write-Host "========================================" -ForegroundColor Cyan
  Write-Host " Agent Guardian Vault Windows Installer" -ForegroundColor Cyan
  Write-Host "========================================" -ForegroundColor Cyan
  Write-Log "INFO" "Log file: $LogFile"
  if ($DryRun) {
    Write-Log "WARN" "Dry run mode is enabled. No files will be changed."
  }

  Enter-Step "Check installer source"
  $source = Ensure-SourceVault
  if (!(Test-Path -LiteralPath $source.Vault) -and !$DryRun) {
    throw "starter_vault was not found: $($source.Vault)"
  }

  Enter-Step "Check Obsidian installation"
  $obsidianPath = Find-Obsidian
  if ($obsidianPath) {
    Write-Log "OK" "Obsidian found: $obsidianPath"
  } else {
    Write-Log "WARN" "Obsidian was not found."
    if (Read-YesNo "Install Obsidian now?" $true) {
      $winget = Get-Command "winget.exe" -ErrorAction SilentlyContinue
      if ($winget) {
        Invoke-VisibleCommand "winget install Obsidian.Obsidian" {
          winget install --id Obsidian.Obsidian -e --source winget
        }
      } else {
        Write-Log "WARN" "winget was not found. Opening the official Obsidian download page."
        if (!$DryRun) {
          Start-Process "https://obsidian.md/download"
          Read-Host "Install Obsidian manually, then press Enter to continue"
        }
      }
    } else {
      Write-Log "WARN" "Continuing without installing Obsidian. You can install it later."
    }
  }

  Enter-Step "Choose vault location"
  $defaultVault = Join-Path $HOME "workspace\docs\ai_data"
  Write-Host "Choose install mode:"
  Write-Host "  1. Create or update the default vault path"
  Write-Host "  2. Create or update a custom vault path"
  Write-Host "  3. Add AgentGuardianVault inside an existing Obsidian vault"
  $mode = Read-Default "Mode" "1"
  if ($mode -eq "2") {
    $vaultRoot = Read-Default "Vault path" $defaultVault
    $openRoot = $vaultRoot
  } elseif ($mode -eq "3") {
    $existingVault = Read-Default "Existing Obsidian vault path" (Join-Path $HOME "Documents")
    $folderName = Read-Default "Subfolder name inside that vault" "AgentGuardianVault"
    $vaultRoot = Join-Path $existingVault $folderName
    $openRoot = $existingVault
  } else {
    $vaultRoot = $defaultVault
    $openRoot = $vaultRoot
  }
  Write-Log "INFO" "Install target: $vaultRoot"
  Write-Log "INFO" "Open in Obsidian: $openRoot"

  Enter-Step "Copy starter vault without overwriting"
  $copyResult = Copy-DirectoryNoOverwrite $source.Vault $vaultRoot
  Write-Log "OK" "Vault copy complete. copied=$($copyResult.Copied), skipped_existing=$($copyResult.Skipped)"

  Enter-Step "Copy agent adapter prompts"
  $adapterSource = Join-Path $source.RepoRoot "agent_adapters"
  $adapterDest = Join-Path $vaultRoot "agent_prompts\adapters"
  if (Test-Path -LiteralPath $adapterSource) {
    $adapterCopy = Copy-DirectoryNoOverwrite $adapterSource $adapterDest
    Write-Log "OK" "Adapter copy complete. copied=$($adapterCopy.Copied), skipped_existing=$($adapterCopy.Skipped)"
  } else {
    Write-Log "WARN" "agent_adapters folder was not found. Skipping adapter copy."
  }

  Enter-Step "Choose language and agent profile"
  $language = Read-Default "Preferred human-facing language" "en"
  Write-Host "Agent profile examples: codex, chatgpt, claude-code, cursor, openhands, local-llm"
  $agentProfile = (Read-Default "Agent profile" "codex").ToLowerInvariant()
  Write-Log "INFO" "Language=$language, Agent=$agentProfile"

  Enter-Step "Create first project memory"
  if (Read-YesNo "Create a first project now?" $true) {
    $projectInput = Read-Default "Project name or slug" "example-project"
    $projectSlug = Convert-ToSlug $projectInput
    $goal = Read-Default "Project goal" "Describe the project goal here"
    New-ProjectScaffold $vaultRoot $projectSlug $goal $language
    Write-AgentPrompt $vaultRoot $projectSlug $agentProfile $language
  } else {
    Write-Log "WARN" "Skipped first project creation."
    $projectSlug = "example-project"
  }

  Enter-Step "Write install report"
  $reportPath = Join-Path $vaultRoot "INSTALL_REPORT.md"
  $report = @"
---
created: $(Get-Date -Format "yyyy-MM-dd")
updated: $(Get-Date -Format "yyyy-MM-dd")
document_type: install-report
---

# Install Report

- installed_at: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
- installer: Windows PowerShell
- target_vault: $vaultRoot
- open_in_obsidian: $openRoot
- language: $language
- agent_profile: $agentProfile
- log_file: $LogFile

## What Happened

- The installer printed each major step to the terminal.
- Existing files were skipped instead of overwritten.
- A project scaffold was offered.
- A start prompt was generated when a project was created.

## If Something Failed

Read the log file above and rerun the installer.
It is designed to continue safely without overwriting existing files.
"@
  if (!$DryRun) {
    Set-Content -LiteralPath $reportPath -Value $report -Encoding UTF8
    Write-Log "OK" "Install report written: $reportPath"
  } else {
    Write-Log "INFO" "Dry run: would write install report: $reportPath"
  }

  Enter-Step "Open vault folder"
  if (!$DryRun) {
    if (Test-Path -LiteralPath $openRoot) {
      Start-Process explorer.exe $openRoot
      Write-Log "OK" "Opened folder in Explorer: $openRoot"
    }
    $obsidianPath = Find-Obsidian
    if ($obsidianPath) {
      Start-Process $obsidianPath
      Write-Log "OK" "Started Obsidian. Use 'Open folder as vault' and select: $openRoot"
    } else {
      Write-Log "WARN" "Obsidian is still not installed. Open this folder after installing it: $openRoot"
    }
  }

  Enter-Step "Finish"
  Write-Progress -Activity "Agent Guardian Vault installer" -Completed
  Write-Host ""
  Write-Host "========================================" -ForegroundColor Green
  Write-Host "[DONE] Agent Guardian Vault is ready." -ForegroundColor Green
  Write-Host "Vault path : $vaultRoot"
  Write-Host "Open path  : $openRoot"
  Write-Host "Log file   : $LogFile"
  Write-Host "========================================" -ForegroundColor Green
  exit 0
} catch {
  Write-Progress -Activity "Agent Guardian Vault installer" -Completed
  Write-Log "ERROR" $_.Exception.Message
  if ($_.InvocationInfo -and $_.InvocationInfo.ScriptLineNumber) {
    Write-Log "ERROR" ("Failure location: line {0}, command: {1}" -f $_.InvocationInfo.ScriptLineNumber, $_.InvocationInfo.Line.Trim())
  }
  Write-Host ""
  Write-Host "[FAILED] The installer stopped before completion." -ForegroundColor Red
  Write-Host "Log file: $LogFile"
  Write-Host "Fix the error above, then run the installer again."
  exit 1
}
