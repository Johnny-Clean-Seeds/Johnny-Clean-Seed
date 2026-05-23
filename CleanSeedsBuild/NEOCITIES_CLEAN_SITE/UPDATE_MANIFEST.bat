@echo off
setlocal
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0UPDATE_MANIFEST.ps1"
