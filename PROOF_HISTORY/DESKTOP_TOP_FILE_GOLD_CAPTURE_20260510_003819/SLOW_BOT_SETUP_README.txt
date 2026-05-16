# SLOW BOT SETUP — README HOW-TO GUIDE
SAVE AS: SLOW_BOT_SETUP_README.txt

This guide is for the slow local bot only.

Your setup files are on the Desktop.
Do not paste only a Desktop path into the bot.
A path by itself is not an instruction.

The bot needs a full message that says:
1. where the setup files are
2. what files to read
3. what not to touch
4. what report to give back

==================================================
QUICK MAP
==================================================

DESKTOP PLACE:
C:\Users\13527\Desktop\toyBOX_SLOW_BOT_SETUP

BOT:
The slow local bot screen where you type messages.

POWERSHELL:
The command window used to run Node / npx commands.

ROBLOX STUDIO:
The Roblox game editor.

WEPYY:
The Roblox Studio MCP plugin panel.

==================================================
BEFORE YOU START
==================================================

Your Desktop place should contain these text files:

BOT_FILE_MAP.txt
WORKER_START_HERE.txt
API_MCP_GENERAL_RULES_V10_WORKER_LOCKED.txt
BOT_API_MCP_ROLE_DEFINITIONS.txt
PROJECT_ROADMAP_AND_PHASE_LOCK.txt
CURRENT_PROJECT_HANDOFF.txt
CURRENT_STUDIO_STATE.txt
ACTIVE_INSTALL_PACKAGE.txt

If your files are sitting directly on the Desktop instead, use this path in the prompts:

C:\Users\13527\Desktop

If your files are inside the named Desktop place, use this path:

C:\Users\13527\Desktop\toyBOX_SLOW_BOT_SETUP

Use only one. Do not mix them.

==================================================
STEP 1 — OPEN THE SLOW BOT
==================================================

WHERE YOU ARE:
Slow bot screen

WHAT YOU DO:
Open the slow bot until you can type into it.

DO NOT PASTE THIS BY ITSELF:

C:\Users\13527\Desktop\toyBOX_SLOW_BOT_SETUP

That is only a location.
It is not a command.
It is not a full instruction.

==================================================
STEP 2 — PASTE THIS FIRST INTO THE SLOW BOT
==================================================

WHERE YOU ARE:
Slow bot message box

WHAT YOU DO:
Copy the full block below and paste it into the slow bot.

----- COPY INTO SLOW BOT -----
STARTUP DIAGNOSTIC ONLY.

You are a local Roblox Studio project worker.

Use this Desktop place as the project rule place:

C:\Users\13527\Desktop\toyBOX_SLOW_BOT_SETUP

Your first job is to read the required setup text files from that Desktop place.

Read these files in this exact order:

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

Only confirm whether each required text file can be loaded.

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
The bot says every file is LOADED.

GOOD REPORT SHOULD LOOK LIKE THIS:

BOT_FILE_MAP: LOADED
WORKER_START_HERE: LOADED
API_MCP_GENERAL_RULES_V10_WORKER_LOCKED: LOADED
BOT_API_MCP_ROLE_DEFINITIONS: LOADED
PROJECT_ROADMAP_AND_PHASE_LOCK: LOADED
CURRENT_PROJECT_HANDOFF: LOADED
CURRENT_STUDIO_STATE: LOADED
ACTIVE_INSTALL_PACKAGE: LOADED
FAILED: None
STOPPED: Yes

BAD RESULT:
The bot says it cannot help, refuses, or cannot read the files.

IF BAD:
The bot probably cannot read Desktop files from a pasted path.
Go to the next section.

==================================================
STEP 3 — IF THE SLOW BOT CANNOT READ DESKTOP FILES
==================================================

WHERE YOU ARE:
Slow bot screen or slow bot settings

WHAT YOU DO:
Check whether the slow bot has a way to choose a project place, working place, or local file access.

Use this Desktop place:

C:\Users\13527\Desktop\toyBOX_SLOW_BOT_SETUP

If the bot has upload buttons instead:
Upload these files directly:

BOT_FILE_MAP.txt
WORKER_START_HERE.txt
API_MCP_GENERAL_RULES_V10_WORKER_LOCKED.txt
BOT_API_MCP_ROLE_DEFINITIONS.txt
PROJECT_ROADMAP_AND_PHASE_LOCK.txt
CURRENT_PROJECT_HANDOFF.txt
CURRENT_STUDIO_STATE.txt
ACTIVE_INSTALL_PACKAGE.txt

Then paste this instead:

----- COPY INTO SLOW BOT ONLY IF FILES WERE UPLOADED -----
STARTUP DIAGNOSTIC ONLY.

Use the uploaded text files as the project rule files.

Read these files in this exact order:

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

Only confirm whether each required text file can be loaded.

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

==================================================
STEP 4 — CHECK NODE IN POWERSHELL
==================================================

WHERE YOU ARE:
PowerShell / Windows Terminal

WHAT YOU DO:
Copy and paste only the 3 lines below.

----- COPY INTO POWERSHELL -----
node -v
npm -v
npx -v
----- END COPY -----

GOOD RESULT:
All 3 lines return version numbers.

BAD RESULT:
Any line says not recognized.

If bad, stop. Node is not ready.

==================================================
STEP 5 — START THE ROBLOX MCP SERVER
==================================================

WHERE YOU ARE:
PowerShell / Windows Terminal

WHAT YOU DO:
Copy and paste only this line.

----- COPY INTO POWERSHELL -----
npx -y @weppy/roblox-mcp
----- END COPY -----

GOOD RESULT:
The server starts and stays running.

IMPORTANT:
Leave PowerShell open.
Closing it stops the server.

==================================================
STEP 6 — OPEN ROBLOX STUDIO AND CONNECT WEPYY
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
STEP 7 — PASTE THIS SECOND INTO THE SLOW BOT
==================================================

WHERE YOU ARE:
Slow bot message box

WHAT YOU DO:
Copy the full block below.

----- COPY INTO SLOW BOT -----
MCP CONNECTION DIAGNOSTIC ONLY.

Use the Roblox Studio MCP server named:

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
STEP 8 — PASTE THIS THIRD INTO THE SLOW BOT
==================================================

WHERE YOU ARE:
Slow bot message box

WHAT YOU DO:
Copy the full block below.

----- COPY INTO SLOW BOT -----
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
The bot lists what is in Studio and changes nothing.

BAD RESULT:
The bot creates, edits, deletes, renames, or moves anything.

If bad, stop the bot.

==================================================
STEP 9 — FIRST REAL WORK PROMPT
==================================================

WHERE YOU ARE:
Slow bot message box

WHEN TO USE:
Only after Step 2, Step 7, and Step 8 pass.

WHAT YOU DO:
Copy the full block below.

----- COPY INTO SLOW BOT -----
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
1. List the exact folders/objects you intend to create.
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

GOOD RESULT:
The bot proposes work and stops.

BAD RESULT:
The bot builds before approval.

==================================================
STEP 10 — WHAT TO SEND BACK IF SOMETHING FAILS
==================================================

WHERE YOU ARE:
Back in this chat asking for help

WHAT YOU DO:
Copy this report and fill it in.

----- COPY INTO CHAT WHEN ASKING FOR HELP -----
FAILURE REPORT

WHERE IT FAILED:
Step number:

WHAT SCREEN I WAS IN:
Slow Bot:
PowerShell:
Roblox Studio:
WEPYY:

WHAT I PASTED:
Paste the exact command or prompt here:

WHAT IT SAID BACK:
Paste the exact error/output here:

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

The slow bot is not ready to build until all of this passes:

1. It reads the rule files.
2. Node/npm/npx work.
3. MCP server is running.
4. Roblox Studio is open.
5. WEPYY is connected.
6. The game file is not read-only.
7. MCP connection passes.
8. Studio inspection passes with no edits.

If any step fails, stop there.
Do not move to the next step.
