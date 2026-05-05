@echo off
setlocal

cd /d "%~dp0"

echo ========================================
echo  Agent Guardian Vault Windows Installer
echo ========================================
echo.
echo This launcher will run the transparent PowerShell installer.
echo You will see every major step, progress count, warnings, and failures.
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Install_Agent_Guardian.ps1"
set EXIT_CODE=%ERRORLEVEL%

echo.
if not "%EXIT_CODE%"=="0" (
  echo [FAILED] Installer exited with code %EXIT_CODE%.
) else (
  echo [DONE] Installer finished successfully.
)
echo.
pause
exit /b %EXIT_CODE%
