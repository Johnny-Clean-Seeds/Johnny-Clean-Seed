# VISUAL STUDIO CODE BOT SETUP — README HOW-TO GUIDE
SAVE AS: VISUAL_STUDIO_CODE_BOT_SETUP_README.txt

This guide is for using a VS Code bot with the Roblox MCP setup.

Your setup files are on the Desktop.
VS Code must open the Desktop place that contains the setup text files.

==================================================
QUICK MAP
==================================================

VS CODE:
The app named Visual Studio Code.

VS CODE BOT:
The chat/assistant inside VS Code.

DESKTOP PLACE:
C:\Users\13527\Desktop\toyBOX_BOT_SETUP

MCP SERVER NAME:
roblox-studio

MCP SERVER COMMAND:
npx -y @weppy/roblox-mcp

ROBLOX STUDIO:
The Roblox game editor.

WEPYY:
The Roblox Studio MCP plugin panel.

==================================================
STEP 1 — OPEN THE DESKTOP PLACE IN VS CODE
==================================================

WHERE YOU ARE:
Visual Studio Code

WHAT YOU DO:
1. Open Visual Studio Code.
2. Click File.
3. Click Open Folder / Open...
4. Choose this Desktop place:

C:\Users\13527\Desktop\toyBOX_BOT_SETUP

5. Open it.

If your files are directly on the Desktop instead, open:

C:\Users\13527\Desktop

GOOD RESULT:
VS Code shows your setup text files on the left side.

BAD RESULT:
You opened one text file only, or the wrong place.

==================================================
STEP 2 — CREATE THE VS CODE MCP SETTINGS FILE
==================================================

WHERE YOU ARE:
Visual Studio Code

WHAT YOU DO:
Inside the opened Desktop place, create this named place:

.vscode

Inside .vscode, create this text file:

mcp.json

The full location should be:

C:\Users\13527\Desktop\toyBOX_BOT_SETUP\.vscode\mcp.json

GOOD RESULT:
You have mcp.json open inside VS Code.

BAD RESULT:
The file is named mcp.json.txt or is not inside .vscode.

==================================================
STEP 3 — PASTE THIS INTO mcp.json
==================================================

WHERE YOU ARE:
VS Code editor

WHAT FILE IS OPEN:
.vscode\mcp.json

WHAT YOU DO:
Delete anything already inside mcp.json.
Paste this block.
Save it.

----- COPY INTO .vscode\mcp.json -----
{
  "servers": {
    "roblox-studio": {
      "command": "npx",
      "args": ["-y", "@weppy/roblox-mcp"]
    }
  }
}
----- END COPY -----

GOOD RESULT:
The file saves with no red error marks.

BAD RESULT:
VS Code shows a JSON error.
Delete the whole file contents and paste the block again.

==================================================
STEP 4 — CHECK NODE IN POWERSHELL
==================================================

WHERE YOU ARE:
PowerShell / Windows Terminal

WHAT YOU DO:
Copy and paste only these 3 lines.

----- COPY INTO POWERSHELL -----
node -v
npm -v
npx -v
----- END COPY -----

GOOD RESULT:
All three return version numbers.

BAD RESULT:
Any line says not recognized.

==================================================
STEP 5 — OPEN ROBLOX STUDIO AND CONNECT WEPYY
==================================================

WHERE YOU ARE:
Roblox Studio

WHAT YOU DO:
1. Open the correct game file.
2. Make sure it is not read-only.
3. Open the WEPYY / MCP panel.
4. Confirm it says Connected.
5. Confirm it shows 127.0.0.1 and port 3002.
6. Open Output.

GOOD OUTPUT:
The MCP Studio plugin is ready for prompts.
[WeppyRobloxMCP] Plugin loaded.
Command channel connected.

BAD RESULT:
Read-only warning or WEPYY is not connected.

==================================================
STEP 6 — START MCP IN VS CODE
==================================================

WHERE YOU ARE:
VS Code

WHAT YOU DO:
1. Open .vscode\mcp.json.
2. Look for a Start button near the MCP server entry.
3. Start the server named roblox-studio.
4. If VS Code asks for permission, allow only this command:

npx -y @weppy/roblox-mcp

IF THERE IS NO START BUTTON:
1. Press Ctrl + Shift + P.
2. Type:
MCP

3. Look for one of these:
MCP: List Servers
MCP: Start Server
MCP: Open Workspace MCP Configuration

4. Start:
roblox-studio

IF VS CODE CANNOT START IT:
Go to PowerShell and run this:

----- COPY INTO POWERSHELL ONLY IF VS CODE START FAILS -----
npx -y @weppy/roblox-mcp
----- END COPY -----

Leave PowerShell open if you start it there.

==================================================
STEP 7 — OPEN THE VS CODE BOT
==================================================

WHERE YOU ARE:
VS Code

WHAT YOU DO:
1. Open the bot/chat panel inside VS Code.
2. Use Agent mode if it has one.
3. Open tools if it has a tool picker.
4. Look for MCP tools.
5. Look for roblox-studio.

GOOD RESULT:
The VS Code bot can see setup files and MCP tools.

BAD RESULT:
No MCP tools or no setup files.
Stop until the bot can see them.

==================================================
STEP 8 — PASTE THIS FIRST INTO THE VS CODE BOT
==================================================

WHERE YOU ARE:
VS Code bot message box

WHAT YOU DO:
Copy this full block.

----- COPY INTO VS CODE BOT -----
STARTUP DIAGNOSTIC ONLY.

You are a local Roblox Studio MCP worker running from Visual Studio Code.

Use this Desktop place:

C:\Users\13527\Desktop\toyBOX_BOT_SETUP

First read these files in this exact order:

1. BOT_FILE_MAP.txt
2. WORKER_START_HERE.txt
3. API_MCP_GENERAL_RULES_V10_WORKER_LOCKED.txt
4. BOT_API_MCP_ROLE_DEFINITIONS.txt
5. PROJECT_ROADMAP_AND_PHASE_LOCK.txt
6. CURRENT_PROJECT_HANDOFF.txt
7. CURRENT_STUDIO_STATE.txt
8. ACTIVE_INSTALL_PACKAGE.txt

Do not inspect Roblox Studio yet.
Do not use MCP tools yet.
Do not create anything.
Do not edit anything.
Do not delete anything.
Do not rename anything.
Do not move anything.
Do not patch anything.
Do not guess.

Only confirm whether each required text file can load.

Report exactly:

BOT_FILE_MAP:
WORKER_START_HERE:
API_MCP_GENERAL_RULES_V10_WORKER_LOCKED:
BOT_API_MCP_ROLE_DEFINITIONS:
PROJECT_ROADMAP_AND_PHASE_LOCK:
CURRENT_PROJECT_HANDOFF:
CURRENT_STUDIO_STATE:
ACTIVE_INSTALL_PACKAGE:
FAILED:
STOPPED: Yes
----- END COPY -----

GOOD RESULT:
All files report LOADED.

BAD RESULT:
Any file reports FAILED.

==================================================
STEP 9 — PASTE THIS SECOND INTO THE VS CODE BOT
==================================================

WHERE YOU ARE:
VS Code bot message box

WHAT YOU DO:
Copy this full block.

----- COPY INTO VS CODE BOT -----
MCP CONNECTION DIAGNOSTIC ONLY.

Use the configured Roblox Studio MCP server named:

roblox-studio

Check whether MCP can reach the connected Roblox Studio session.

Do not create anything.
Do not edit anything.
Do not delete anything.
Do not rename anything.
Do not move anything.
Do not patch anything.
Do not guess.

Report exactly:

MCP_SERVER:
ROBLOX_STUDIO_CONNECTION:
AVAILABLE_TOOLS:
FAILED:
STOPPED: Yes
----- END COPY -----

GOOD RESULT:
MCP_SERVER: CONNECTED
ROBLOX_STUDIO_CONNECTION: CONNECTED
AVAILABLE_TOOLS: LISTED
FAILED: None
STOPPED: Yes

==================================================
STEP 10 — PASTE THIS THIRD INTO THE VS CODE BOT
==================================================

WHERE YOU ARE:
VS Code bot message box

WHAT YOU DO:
Copy this full block.

----- COPY INTO VS CODE BOT -----
STUDIO INSPECTION ONLY.

Inspect the current Roblox Studio place using MCP.

Do not create anything.
Do not edit anything.
Do not delete anything.
Do not rename anything.
Do not move anything.
Do not patch anything.
Do not guess.

Report only:
1. Workspace top-level objects.
2. ReplicatedStorage top-level objects.
3. ServerScriptService top-level objects.
4. StarterPlayer top-level objects.
5. StarterGui top-level objects.
6. Lighting top-level objects.
7. Any read-only warning if visible.
8. Any obvious missing foundation items.

Report exactly:

WORKSPACE:
REPLICATED_STORAGE:
SERVER_SCRIPT_SERVICE:
STARTER_PLAYER:
STARTER_GUI:
LIGHTING:
WARNINGS:
FAILED:
STOPPED: Yes
----- END COPY -----

GOOD RESULT:
The bot lists Studio items and changes nothing.

BAD RESULT:
The bot edits anything.
Stop it.

==================================================
STEP 11 — FIRST REAL WORK PROMPT
==================================================

WHERE YOU ARE:
VS Code bot message box

WHEN TO USE:
Only after Steps 8, 9, and 10 pass.

----- COPY INTO VS CODE BOT -----
CONTROLLED SETUP PROPOSAL ONLY.

Use the loaded project rules and phase lock.

Propose only the minimum missing foundation structure required for the current active phase.

Do not create anything yet.
Do not edit anything yet.
Do not delete anything.
Do not rename anything.
Do not move anything.
Do not patch anything.
Do not create gameplay logic yet.
Do not create enemies yet.
Do not create combat yet.
Do not create save/load yet.
Do not create extra worlds yet.
Do not import outside assets.

Every proposed item must include its Roblox object type.

Before making changes:
1. List the exact items you intend to create.
2. Label each item type.
3. Explain why each is needed.
4. Stop and wait for approval.

Report exactly:

PROPOSED_CREATIONS:
WHY_NEEDED:
PHASE_LOCK_CHECK:
RISKS:
NEEDS_APPROVAL: Yes
STOPPED: Yes
----- END COPY -----

==================================================
STEP 12 — WHAT TO SEND BACK IF SOMETHING FAILS
==================================================

----- COPY INTO CHAT WHEN ASKING FOR HELP -----
FAILURE REPORT

WHERE IT FAILED:
Step number:

WHAT SCREEN I WAS IN:
VS Code:
VS Code Bot:
PowerShell:
Roblox Studio:
WEPYY:

WHAT I PASTED:
Paste the exact command or prompt here:

WHAT IT SAID BACK:
Paste the exact output here:

ROBLOX STUDIO OUTPUT:
Paste the newest Output lines here:

MCP STATUS:
Connected / Not connected / Unknown

PORT:
3002 / Other / Unknown

GAME FILE:
Normal / Read-only / Unknown

WHAT CHANGED IN STUDIO:
Nothing / Something changed / Unknown

STOPPED:
Yes
----- END COPY -----

==================================================
FINAL HARD RULE
==================================================

The VS Code bot is not ready to build until all of this passes:

1. VS Code opened the Desktop place.
2. mcp.json exists and is correct.
3. Node/npm/npx work.
4. Roblox Studio is open.
5. WEPYY is connected.
6. MCP server starts.
7. Rule files load.
8. MCP connection passes.
9. Studio inspection passes with no edits.

If any step fails, stop there.
Do not move to the next step.
