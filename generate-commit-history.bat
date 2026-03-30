@echo off
echo ==========================================
echo Git Commit History Generator
echo ==========================================
echo.
echo This script will generate commit history for your team
echo Time range: 30/03/2026 10:00 AM to 12:00 PM
echo.
echo Team Members:
echo - Dinesh0203s (dineshsenathipathi@gmail.com) - 18 commits
echo - HazSha28 (tohazsha@gmail.com) - 7 commits
echo - prakashb96 (prakashbalakrishnan2005@gmail.com) - 5 commits
echo.
echo ==========================================
echo.

powershell -ExecutionPolicy Bypass -File generate-commit-history.ps1

echo.
pause
