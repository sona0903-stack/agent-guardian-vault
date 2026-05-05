---
created: 2026-05-06
updated: 2026-05-06
language: en
package: agent-guardian-vault-starter
document_type: documentation
---
# Visible Installers

The installer scripts are intentionally transparent.
They print each major step, write a log file, and stop with a visible error if something fails.

They do not silently overwrite an existing vault.
Existing files are skipped by default.

## Windows

Run:

```text
installers/windows/Install_Agent_Guardian.bat
```

The batch file opens the PowerShell installer and keeps the terminal open at the end.

The PowerShell installer shows:

- current step count
- install target
- Obsidian detection
- Obsidian install action if approved
- copy counts
- skipped existing file count
- first project scaffold status
- final vault path
- log file path

To test script loading without changing files:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File installers/windows/Install_Agent_Guardian.ps1 -DryRun
```

## macOS

Run:

```bash
chmod +x installers/mac/Install_Agent_Guardian.command
installers/mac/Install_Agent_Guardian.command
```

If downloaded through Finder, you can also double-click the `.command` file after it has execute permission.

The macOS installer shows:

- current step count
- install target
- Obsidian detection
- Homebrew install action if approved
- zip or git fallback if needed
- copy counts
- skipped existing file count
- first project scaffold status
- final vault path
- log file path

## Install Modes

Both installers support three user-visible modes:

1. Create or update the default vault path.
2. Create or update a custom vault path.
3. Add `AgentGuardianVault/` inside an existing Obsidian vault.

Mode 3 is recommended if you already have a large Obsidian vault and want the starter to stay grouped in one folder.

## Obsidian Handling

The installers check whether Obsidian is installed.

- Windows uses `winget install Obsidian.Obsidian` only after user confirmation.
- macOS uses `brew install --cask obsidian` only after user confirmation.
- If the package manager is missing, the installer opens the official Obsidian download page and waits for manual installation.

## Failure Behavior

If a step fails:

1. The terminal prints `[FAILED]`.
2. The log file path is shown.
3. Existing files remain in place.
4. Rerunning the installer is safe because existing files are skipped.

This makes it clear whether work is still progressing, waiting for input, or stopped on an error.
