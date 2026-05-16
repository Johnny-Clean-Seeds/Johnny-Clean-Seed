@echo off
setlocal
title Roblox Studio MCP Startup

set "MCP_CMD=npx -y robloxstudio-mcp@latest"

echo ==========================================================
echo ROBLOX STUDIO + MCP STARTUP
echo No map. No ChatGPT browser launch.
echo ==========================================================
echo.

echo [1/3] Looking for Roblox Studio...
set "STUDIO_EXE="

for /f "delims=" %%F in ('dir /b /s "%LOCALAPPDATA%\Roblox\Versions\RobloxStudioBeta.exe" 2^>nul') do (
  set "STUDIO_EXE=%%F"
)

if not defined STUDIO_EXE (
  echo [FAIL] Could not find RobloxStudioBeta.exe.
  echo.
  echo Open Roblox Studio manually once, then try this launcher again.
  echo If it still fails, Roblox Studio may be installed in a non-standard path.
  echo.
  pause
  exit /b 1
)

echo Found:
echo %STUDIO_EXE%
echo.
echo [2/3] Opening Roblox Studio only.
echo You choose the map/project after Studio opens.
start "" "%STUDIO_EXE%"

echo.
echo Waiting for Studio to start...
timeout /t 8 /nobreak >nul

echo [3/3] Starting MCP server...
start "Roblox MCP Server - keep open" cmd /k "%MCP_CMD%"

echo.
echo DONE.
echo - Pick your map/project inside Roblox Studio.
echo - Keep the black MCP server window open while using MCP.
echo - This launcher does not open ChatGPT.
echo.
pause
endlocal
