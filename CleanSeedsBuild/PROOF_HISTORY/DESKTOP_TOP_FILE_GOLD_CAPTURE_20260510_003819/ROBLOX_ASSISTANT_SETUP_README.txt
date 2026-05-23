# ROBLOX ASSISTANT SETUP — README HOW-TO GUIDE
SAVE AS: ROBLOX_ASSISTANT_SETUP_README.txt

This guide is for Roblox Assistant inside Roblox Studio.

Roblox Assistant is different from the local MCP bot.
It does not need PowerShell.
It does not need Node.js.
It does not need npx.
It does not need WEPYY MCP for this guide.

You paste instructions directly into Roblox Assistant.

==================================================
QUICK MAP
==================================================

ROBLOX STUDIO:
The Roblox game editor.

ROBLOX ASSISTANT:
The AI helper inside Roblox Studio.

OUTPUT:
The Studio panel that shows warnings and script messages.

GAME FILE:
The Roblox project/place you are working on.

==================================================
STEP 1 — OPEN THE RIGHT GAME FILE
==================================================

WHERE YOU ARE:
Roblox Studio

WHAT YOU DO:
1. Open Roblox Studio.
2. Open the correct game file.
3. Make sure it is not read-only.
4. Open Output.
5. Look for big errors.
6. Save a clean copy before using Assistant.

GOOD RESULT:
The game opens normally.

BAD RESULT:
Studio says read-only.

IF READ-ONLY:
1. Click File.
2. Click Save As.
3. Save a new copy.
4. Close the read-only game.
5. Open the new copy.

==================================================
STEP 2 — OPEN ROBLOX ASSISTANT
==================================================

WHERE YOU ARE:
Roblox Studio

WHAT YOU DO:
Open Roblox Assistant.

GOOD RESULT:
You can type into Roblox Assistant.

BAD RESULT:
You cannot find it or cannot type into it.

==================================================
STEP 3 — PASTE THIS FIRST INTO ROBLOX ASSISTANT
==================================================

WHERE YOU ARE:
Roblox Assistant message box

WHAT YOU DO:
Copy this full block.

----- COPY INTO ROBLOX ASSISTANT -----
ROBLOX ASSISTANT STARTUP RULES.

You are helping inside Roblox Studio.

You must follow controlled project rules.

Do not create anything yet.
Do not edit anything yet.
Do not delete anything.
Do not rename anything.
Do not move anything.
Do not replace scripts.
Do not insert models.
Do not import assets.
Do not generate extra systems.
Do not jump ahead.
Do not guess.

Your first job is only to acknowledge the working rules.

You must work in small controlled steps.
You must explain what you intend to change before changing it.
You must wait for approval before creating, deleting, renaming, moving, or replacing anything.
You must not assume missing project structure.
You must not build outside the active phase.
You must not create future systems early.
You must not mix debug UI with final UI.
You must not silently rewrite working scripts.
You must not delete existing work unless specifically approved.

Current project type:
Roblox adventure game / toyBOX-style test project.

Current goal:
Build a clean foundation for a Marioish adventure game with secrets, combat, hazards, switches, gates, coins, UI messages, and later elemental/weird-room systems.

For now, only confirm that you understand.

Report exactly:

ROBLOX_AI_RULES:
CONTROLLED_WORKFLOW:
NEEDS_APPROVAL_BEFORE_EDITS:
PHASE_LOCK:
FAILED:
STOPPED: Yes
----- END COPY -----

GOOD RESULT:
Assistant confirms the rules and stops.

GOOD REPORT SHOULD LOOK LIKE THIS:

ROBLOX_AI_RULES: UNDERSTOOD
CONTROLLED_WORKFLOW: ENABLED
NEEDS_APPROVAL_BEFORE_EDITS: YES
PHASE_LOCK: ACKNOWLEDGED
FAILED: None
STOPPED: Yes

BAD RESULT:
Assistant creates or edits something.

If bad, stop it.

==================================================
STEP 4 — PASTE THIS SECOND INTO ROBLOX ASSISTANT
==================================================

WHERE YOU ARE:
Roblox Assistant message box

WHAT YOU DO:
Copy this full block.

----- COPY INTO ROBLOX ASSISTANT -----
PROJECT ROADMAP AND PHASE LOCK.

CURRENT STATUS:
We are restarting as a Marioish adventure game with combat, secrets, elemental gimmicks, weird rooms, mystery zones, and side systems.

ACTIVE PHASE:
PHASE 1 — CORE ADVENTURE FOUNDATION.

PHASE 1 GOAL:
Build the basic playable game shell.

PHASE 1 ALLOWED SYSTEMS:
- Clean setup structure
- Player movement support
- Camera support
- Health
- Damage
- Coins
- Basic UI messages
- One simple enemy
- One switch
- One gate
- One hazard
- Debug prints
- Small test room

PHASE 1 TEST ROOM:
A small hub/test room where the player can:
- Collect a coin
- Take damage
- Fight or avoid one enemy
- Press one switch
- Open one gate
- See basic UI messages
- Trigger clear debug prints

DO NOT BUILD YET:
- Crawl-bot
- Cloners
- Quicksand
- Full worlds
- Full reaction systems
- Dungeon systems
- Save/load
- Inventory
- Economy
- Marketplace
- Large maps
- Procedural systems
- Advanced elemental systems
- Polished final UI
- Complex NPC systems

RULE:
If a request conflicts with Phase 1, say it is phase-locked and do not build it.

For now, only confirm the active phase.

Report exactly:

ACTIVE_PHASE:
ALLOWED_SCOPE:
LOCKED_SYSTEMS:
FAILED:
STOPPED: Yes
----- END COPY -----

GOOD RESULT:
Assistant confirms Phase 1 and stops.

BAD RESULT:
Assistant starts building.

==================================================
STEP 5 — PASTE THIS THIRD INTO ROBLOX ASSISTANT
==================================================

WHERE YOU ARE:
Roblox Assistant message box

WHAT YOU DO:
Copy this full block.

----- COPY INTO ROBLOX ASSISTANT -----
CURRENT STUDIO STATE CHECK.

Before making any changes, inspect the current visible Studio structure only.

Do not create anything.
Do not edit anything.
Do not delete anything.
Do not rename anything.
Do not move anything.
Do not insert scripts.
Do not insert models.
Do not guess.

Report what currently exists in:
1. Workspace
2. ReplicatedStorage
3. ServerScriptService
4. StarterPlayer
5. StarterGui
6. Lighting
7. SoundService, if relevant

Also report any obvious warnings:
- Missing setup items
- Duplicate systems
- Read-only file warning
- Existing scripts that should not be overwritten
- Existing test objects that should be preserved

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
Assistant reports Studio state and changes nothing.

BAD RESULT:
Assistant creates or edits anything.

==================================================
STEP 6 — FIRST REAL WORK PROMPT
==================================================

WHERE YOU ARE:
Roblox Assistant message box

WHEN TO USE:
Only after Steps 3, 4, and 5 pass.

----- COPY INTO ROBLOX ASSISTANT -----
CONTROLLED SETUP PROPOSAL ONLY.

Using the confirmed Phase 1 scope, propose the minimum object structure needed for the core adventure foundation.

Do not create anything yet.
Do not edit anything yet.
Do not delete anything.
Do not rename anything.
Do not move anything.

Only propose the structure.

Every item must include its Roblox object type.

Example format:
ReplicatedStorage (Service)
├─ Remotes (Folder)
│  └─ ShowMessage (RemoteEvent)

ServerScriptService (Service)
├─ Systems (Folder)
│  └─ HealthService (Script)

StarterPlayer (Service)
└─ StarterPlayerScripts (Folder)
   └─ PlayerController (LocalScript)

Required:
- Label every object type.
- Explain why each object is needed.
- Keep it minimal.
- Do not include future phase systems.
- Stop and wait for approval.

Report exactly:

PROPOSED_STRUCTURE:
WHY_NEEDED:
PHASE_LOCK_CHECK:
RISKS:
NEEDS_APPROVAL: Yes
STOPPED: Yes
----- END COPY -----

GOOD RESULT:
Assistant proposes and stops.

BAD RESULT:
Assistant creates anything before approval.

==================================================
STEP 7 — APPROVE STRUCTURE CREATION ONLY
==================================================

WHERE YOU ARE:
Roblox Assistant message box

WHEN TO USE:
Only after you approve the proposal.

----- COPY INTO ROBLOX ASSISTANT -----
APPROVED FOR STRUCTURE CREATION ONLY.

Create only the approved items from the proposal.

Do not create gameplay logic yet.
Do not write full scripts yet.
Do not create enemies yet.
Do not create combat yet.
Do not create save/load.
Do not create extra systems.
Do not import assets.
Do not delete existing objects.
Do not rename existing objects.

After creating the approved structure, report exactly:

CREATED:
SKIPPED:
WARNINGS:
FAILED:
STOPPED: Yes
----- END COPY -----

==================================================
STEP 8 — SCRIPT PROPOSAL RULE
==================================================

WHERE YOU ARE:
Roblox Assistant message box

WHAT YOU DO:
Use this before any script work.

----- COPY INTO ROBLOX ASSISTANT -----
SCRIPTING CONTROL RULE.

Before writing or replacing any script:
1. Identify the exact script name.
2. Identify the exact Roblox location.
3. Identify the exact script type:
   - Script
   - LocalScript
   - ModuleScript
4. Explain the script's job.
5. Explain what events/remotes it depends on.
6. Explain what it should print for debugging.
7. Stop and wait for approval.

Do not paste or install the script until approved.

Report exactly:

SCRIPT_NAME:
SCRIPT_TYPE:
SCRIPT_LOCATION:
SCRIPT_JOB:
DEPENDENCIES:
DEBUG_PRINTS:
RISKS:
NEEDS_APPROVAL: Yes
STOPPED: Yes
----- END COPY -----

==================================================
STEP 9 — TESTING PROMPT
==================================================

WHERE YOU ARE:
Roblox Assistant message box

WHAT YOU DO:
Use this after Assistant installs something.

----- COPY INTO ROBLOX ASSISTANT -----
TEST DIAGNOSTIC ONLY.

Do not create anything.
Do not edit anything.
Do not delete anything.

Tell me exactly how to test the last installed item in Play mode.

Include:
1. What button to press.
2. What the player should do.
3. What should happen in-game.
4. What should appear in Output.
5. What failure signs to watch for.

Report exactly:

TEST_STEPS:
EXPECTED_GAME_RESULT:
EXPECTED_OUTPUT:
FAILURE_SIGNS:
NEXT_SAFE_FIX_IF_FAILED:
STOPPED: Yes
----- END COPY -----

==================================================
STEP 10 — WHAT TO SEND BACK IF SOMETHING FAILS
==================================================

----- COPY INTO CHAT WHEN ASKING FOR HELP -----
FAILURE REPORT

WHERE IT FAILED:
Step number:

WHAT SCREEN I WAS IN:
Roblox Studio:
Roblox Assistant:

WHAT I PASTED:
Paste the exact prompt here:

WHAT IT SAID BACK:
Paste the exact answer/error here:

ROBLOX STUDIO OUTPUT:
Paste the newest Output lines here:

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

Roblox Assistant is not ready to build until all of this passes:

1. Correct game file is open.
2. Game file is not read-only.
3. Assistant startup rules are confirmed.
4. Phase lock is confirmed.
5. Studio state check passes with no edits.
6. First real task is proposal only.

If any step fails, stop there.
Do not move to the next step.
