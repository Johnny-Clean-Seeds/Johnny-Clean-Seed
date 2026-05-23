& {
    $ErrorActionPreference = "Stop"

    $Root = "$env:USERPROFILE\Desktop\Jxhnny_Kleen_C3dz"
    $BridgeRoot = "$env:USERPROFILE\Desktop\123\TOOLS\LOCAL_HARD_BRIDGE_V1"
    $RunStamp = Get-Date -Format "yyyyMMdd_HHmmss"

    Set-Location $Root

    Write-Host "POINT OF WORK READBACK"
    Write-Host "Task: Save front-door bridge use rule plus work-request sorting/place-finder rule."
    Write-Host "Boundary: support rules and usage cards only. No doctrine. No ACTIVE_GUIDES. No CURRENT_TRUTH_INDEX. No runtime. No automation. No dashboard. No bridge house-write expansion."
    Write-Host ""

    if (-not (Test-Path ".git")) {
        throw "STOP. Not in Mr.Kleen root."
    }

    if ((git branch --show-current).Trim() -ne "main") {
        throw "STOP. Wrong branch. Expected main."
    }

    $StatusBefore = @(git status --short)
    if ($StatusBefore.Count -gt 0) {
        Write-Host "Dirty state before save:"
        $StatusBefore | ForEach-Object { Write-Host $_ }
        throw "STOP. Mr.Kleen must be clean before this save."
    }

    $HeadBefore = (git rev-parse HEAD).Trim()
    $ShortBefore = (git rev-parse --short HEAD).Trim()

    $BridgeRunOnce = Join-Path $BridgeRoot "TOOLS\RUN_BRIDGE_ONCE.ps1"
    $BridgePolicy = Join-Path $BridgeRoot "CONFIG\POLICY.json"
    $BridgeReadMe = Join-Path $BridgeRoot "READ_ME_FIRST_LOCAL_HARD_BRIDGE_V1.md"
    $BridgeRepairReceipt = Join-Path $BridgeRoot "HUB\RECEIPTS\LOCAL_HARD_BRIDGE_V1_GIT_SENSOR_REPAIR_RECEIPT_20260520_235640.txt"

    if (-not (Test-Path -LiteralPath $BridgeRunOnce)) {
        throw "STOP. Local Hard Bridge V1 runner missing: $BridgeRunOnce"
    }

    if (-not (Test-Path -LiteralPath $BridgePolicy)) {
        throw "STOP. Local Hard Bridge V1 policy missing: $BridgePolicy"
    }

    $BridgeRunHash = (Get-FileHash -LiteralPath $BridgeRunOnce -Algorithm SHA256).Hash
    $BridgePolicyHash = (Get-FileHash -LiteralPath $BridgePolicy -Algorithm SHA256).Hash
    $BridgeReadMeHash = if (Test-Path -LiteralPath $BridgeReadMe) { (Get-FileHash -LiteralPath $BridgeReadMe -Algorithm SHA256).Hash } else { "MISSING" }
    $BridgeRepairHash = if (Test-Path -LiteralPath $BridgeRepairReceipt) { (Get-FileHash -LiteralPath $BridgeRepairReceipt -Algorithm SHA256).Hash } else { "MISSING" }

    $RuleSort = "BRAIN_LEARNING\WORK_REQUEST_SORTING_FORMULA_AND_PLACE_FINDER_RULE_20260521.md"
    $RuleBridge = "BRAIN_LEARNING\LOCAL_HARD_BRIDGE_FRONT_DOOR_USE_RULE_20260521.md"
    $GearSort = "HOUSE_WORK\WORK_SHED\GEAR_RACK\WORK_REQUEST_SORTING_FORMULA_CARD_20260521.md"
    $GearBridge = "HOUSE_WORK\WORK_SHED\GEAR_RACK\LOCAL_HARD_BRIDGE_FRONT_DOOR_USAGE_CARD_20260521.md"
    $Dissection = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\FRONT_DOOR_AND_WORK_REQUEST_SORTING_DISSECTION_20260521.md"
    $Todo = "HOUSE_WORK\TODO\LOCAL_HARD_BRIDGE_AND_WORK_SORTING_LIVE_USE_TODO_20260521.md"
    $StatusFile = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"
    $AnchorFile = "ACTIVE_ANCHOR.txt"
    $Receipt = "PROOF_HISTORY\FRONT_DOOR_AND_WORK_SORTING_RULES_SAVE_RECEIPT_20260521.txt"

    $NewFiles = @($RuleSort, $RuleBridge, $GearSort, $GearBridge, $Dissection, $Todo, $Receipt)
    foreach ($Target in $NewFiles) {
        if (Test-Path -LiteralPath $Target) {
            throw "STOP. Target already exists, not overwriting: $Target"
        }
    }

    foreach ($Dir in @(
        (Split-Path -Parent $RuleSort),
        (Split-Path -Parent $RuleBridge),
        (Split-Path -Parent $GearSort),
        (Split-Path -Parent $GearBridge),
        (Split-Path -Parent $Dissection),
        (Split-Path -Parent $Todo),
        (Split-Path -Parent $Receipt)
    )) {
        New-Item -ItemType Directory -Force -Path $Dir | Out-Null
    }

    @(
        "# Work Request Sorting Formula And Place Finder Rule",
        "",
        "Date: 2026-05-21",
        "Lane: BRAIN_LEARNING",
        "Status: SUPPORT RULE / LIVE-USE REQUIRED / NOT DOCTRINE",
        "",
        "## Purpose",
        "",
        "When the user gives a job, task, note pile, file, research request, edit request, mimic/adopt/adapt request, or possible fix, the assistant must not jump straight to writing, researching, saving, or agreeing.",
        "",
        "The assistant must first sort the request into the right work mode, decide where the object belongs, and name the proof needed before save/adoption.",
        "",
        "## Trigger",
        "",
        "Fire this rule when the user says or implies:",
        "",
        "- do this job;",
        "- use these notes;",
        "- research this;",
        "- edit/rewrite/revise this;",
        "- mimic this pattern;",
        "- adopt/adapt this fix;",
        "- save/add rules;",
        "- put this into files;",
        "- make future assistants know this;",
        "- this might be a fix;",
        "- this feels like the missing part;",
        "- use the bridge/front door/hard bridge.",
        "",
        "## Formula",
        "",
        "Use this sequence before action:",
        "",
        "1. OBJECT",
        "   Name what the user gave: note, command, problem, evidence, source ore, candidate rule, tool, bridge, file, return, or active job.",
        "",
        "2. INTENT",
        "   Identify the requested move: edit, research, mimic, adopt/adapt, diagnose issue, save/lock, test, bridge transfer, handoff, or park.",
        "",
        "3. MODE",
        "   Choose one primary mode and any support modes:",
        "   - EDIT: improve existing text/code/file without changing authority.",
        "   - RESEARCH: gather outside/source support and map claims to sources.",
        "   - MIMIC: copy a working pattern shape while adapting to local boundaries.",
        "   - ADOPT/ADAPT: take a found fix or method and fit it into the house after proof.",
        "   - ISSUE/FIX: classify leak, root cause, repair, proof, and close condition.",
        "   - PLACE/FIND: decide the correct room/lane before writing.",
        "   - BRIDGE/TRANSFER: use local hard bridge or mule exchange bridge as carrier, not authority.",
        "   - SAVE/LOCK: write, receipt, git proof, push, and clean status.",
        "",
        "4. PLACE",
        "   Run Place Finder before writing. Decide exact lane:",
        "   BRAIN_LEARNING, GEAR_RACK, SORTING_BENCH, TODO, SOURCE_ORE, MULE_WORKSHOP, BRIDGES, PROOF_HISTORY, 123 local-only, or bridge WORKSPACE.",
        "",
        "5. AUTHORITY",
        "   Name what can and cannot steer: user command, ACTIVE_ANCHOR, active guides, CURRENT_TRUTH_INDEX, git state, receipts, mule output, bridge output, outside sources, notes.",
        "",
        "6. STALENESS",
        "   Ask whether this object is current, stale, docked, copied, old support, source ore, or live active work. A useful object can still be stale as a command.",
        "",
        "7. PROOF",
        "   Name proof needed: file exists, hash, bridge response, git status, receipt, live-use test, source-to-claim map, or user review.",
        "",
        "8. DISPOSITION",
        "   Choose one: APPLY, ADAPT, PARK, REJECT, BLOCK, NEEDS PROOF, SAVE SUPPORT ONLY, or TEST FIRST.",
        "",
        "9. OUTPUT",
        "   Produce only the needed output: answer, file, request packet, bridge request, helper, receipt, or save commit.",
        "",
        "10. CLOSE",
        "   State what changed, what did not change, what remains candidate, and the next clean move.",
        "",
        "## Default decisions",
        "",
        "If the user gives raw notes and says they might matter, default to DISSECT + PLACE + PARK/SUPPORT unless they explicitly request doctrine.",
        "",
        "If the user asks to mimic, copy the ability or relation pattern, not the surface costume.",
        "",
        "If the user asks to adopt a fix, first ask: where does it live, what proof exists, and what neighbor rule can it disturb?",
        "",
        "If the user asks to save a rule everywhere, do not scatter it everywhere. Save it into every appropriate lane: rule, usage card, dissection, TODO/live-use, status, anchor, and receipt.",
        "",
        "If the user asks to use the hard bridge, treat bridge output as carrier/proof surface only. It does not become house authority.",
        "",
        "## Blocked",
        "",
        "- no doctrine install from raw notes;",
        "- no ACTIVE_GUIDES rewrite;",
        "- no CURRENT_TRUTH_INDEX rewrite;",
        "- no runtime, dashboard, automation, permanent service, or open shell;",
        "- no all-places scatter;",
        "- no bridge output as authority;",
        "- no mule output as authority;",
        "- no editing/saving before Place Finder chooses a lane.",
        "",
        "## Live-use standard",
        "",
        "This rule must be tested on real user notes and bridge requests before promotion. Until then it is a support rule."
    ) | Set-Content -LiteralPath $RuleSort -Encoding UTF8

    @(
        "# Local Hard Bridge Front Door Use Rule",
        "",
        "Date: 2026-05-21",
        "Lane: BRAIN_LEARNING",
        "Status: SUPPORT RULE / TOOL USE BOUNDARY / NOT DOCTRINE",
        "",
        "## Purpose",
        "",
        "Future assistants must know how to use the Local Hard Bridge front door without treating it as authority or an open PC shell.",
        "",
        "The bridge is a local PowerShell-backed actuator for allowlisted actions. It is a carrier, proof surface, and front-door sensor. It is not Mr.Kleen authority.",
        "",
        "## Current bridge",
        "",
        "Bridge root:",
        "C:\\Users\\13527\\Desktop\\123\\TOOLS\\LOCAL_HARD_BRIDGE_V1",
        "",
        "Run once tool:",
        "C:\\Users\\13527\\Desktop\\123\\TOOLS\\LOCAL_HARD_BRIDGE_V1\\TOOLS\\RUN_BRIDGE_ONCE.ps1",
        "",
        "Current fixed runner SHA256:",
        $BridgeRunHash,
        "",
        "Policy SHA256:",
        $BridgePolicyHash,
        "",
        "Readme SHA256:",
        $BridgeReadMeHash,
        "",
        "Git sensor repair receipt SHA256:",
        $BridgeRepairHash,
        "",
        "## Use order",
        "",
        "1. Treat the bridge as local-only support.",
        "2. Create or inspect request files in HUB/REQUESTS only when needed.",
        "3. Run RUN_BRIDGE_ONCE manually from PowerShell.",
        "4. Read HUB/RESPONSES and HUB/RECEIPTS.",
        "5. Trust only outputs that pass their own proof and boundary checks.",
        "6. For house work, always read house_front_door before action.",
        "7. If git status is not clean, stop or diagnose before writing.",
        "",
        "## Front door check",
        "",
        "The first bridge request for nontrivial house work should be house_front_door.",
        "",
        "The response must show:",
        "- house_root;",
        "- branch;",
        "- HEAD;",
        "- short;",
        "- origin/main;",
        "- clean true or explicit status lines;",
        "- ACTIVE_ANCHOR exists;",
        "- CURRENT_TRUTH_INDEX exists.",
        "",
        "If the response shows git usage text, missing fields, ok true with nonsense output, or stale root, the bridge has failed and must be repaired before use.",
        "",
        "## Allowed use in V1",
        "",
        "- write/read/hash inside bridge WORKSPACE;",
        "- read/list/hash house files;",
        "- read house git front door;",
        "- produce receipts;",
        "- support request/response flow.",
        "",
        "## Blocked in V1",
        "",
        "- no arbitrary shell;",
        "- no delete;",
        "- no overwrite;",
        "- no house write;",
        "- no git commit;",
        "- no git push;",
        "- no network service;",
        "- no treating local bridge receipts as house proof unless mapped to a house save.",
        "",
        "## House placement",
        "",
        "Bridge rules belong in BRAIN_LEARNING and GEAR_RACK support cards.",
        "",
        "Bridge results that matter to Mr.Kleen should be saved through normal house save gates with receipt and git proof.",
        "",
        "Local bridge files in 123 are local-only tool material until intentionally imported or referenced in a house receipt.",
        "",
        "## Relation to Assistant-Mule Exchange Bridge",
        "",
        "Local Hard Bridge V1 moves between chat logic and the user's PC.",
        "",
        "Assistant-Mule Exchange Bridge moves between assistant and mule inside Mr.Kleen.",
        "",
        "These bridges are neighbors, not the same bridge and not authority.",
        "",
        "## Failure classes to watch",
        "",
        "- false success from tool output;",
        "- stale root pointer;",
        "- dirty house front door;",
        "- path separator mismatch;",
        "- long path failures;",
        "- helper left loose after proof;",
        "- support tool trying to become rule king."
    ) | Set-Content -LiteralPath $RuleBridge -Encoding UTF8

    @(
        "# Work Request Sorting Formula Card",
        "",
        "Date: 2026-05-21",
        "Lane: HOUSE_WORK / WORK_SHED / GEAR_RACK",
        "Status: REUSABLE CARD / SUPPORT ONLY",
        "",
        "Use when a user request could become editing, research, mimicry, adoption, issue repair, bridge transfer, or save.",
        "",
        "Fast card:",
        "",
        "OBJECT -> INTENT -> MODE -> PLACE -> AUTHORITY -> STALE? -> PROOF -> DISPOSITION -> OUTPUT -> CLOSE",
        "",
        "Mode choices:",
        "",
        "- EDIT",
        "- RESEARCH",
        "- MIMIC",
        "- ADOPT/ADAPT",
        "- ISSUE/FIX",
        "- PLACE/FIND",
        "- BRIDGE/TRANSFER",
        "- SAVE/LOCK",
        "",
        "Disposition choices:",
        "",
        "- APPLY",
        "- ADAPT",
        "- PARK",
        "- REJECT",
        "- BLOCK",
        "- NEEDS PROOF",
        "- SAVE SUPPORT ONLY",
        "- TEST FIRST",
        "",
        "Minimum output before commands:",
        "",
        "- current mode;",
        "- target place;",
        "- proof needed;",
        "- blocked moves;",
        "- next action.",
        "",
        "Do not let a useful method become an all-task ritual. Fire it when routing could be wrong or consequences matter."
    ) | Set-Content -LiteralPath $GearSort -Encoding UTF8

    @(
        "# Local Hard Bridge Front Door Usage Card",
        "",
        "Date: 2026-05-21",
        "Lane: HOUSE_WORK / WORK_SHED / GEAR_RACK",
        "Status: REUSABLE CARD / SUPPORT ONLY",
        "",
        "## Front door rule",
        "",
        "Before nontrivial bridge-assisted house work, run or inspect a house_front_door response.",
        "",
        "Required clean state:",
        "",
        "- branch main;",
        "- HEAD present;",
        "- origin/main present;",
        "- HEAD equals origin/main for save work;",
        "- clean true or clear dirty paths;",
        "- ACTIVE_ANCHOR exists;",
        "- CURRENT_TRUTH_INDEX exists.",
        "",
        "## If dirty",
        "",
        "Stop. Diagnose whether dirty paths are expected active save, failed helper residue, dock copy dirt, or unrelated changes.",
        "",
        "## If git output is nonsense",
        "",
        "Stop. Tool failure. Repair bridge before trusting it.",
        "",
        "## V1 write boundary",
        "",
        "V1 may write new text only inside LOCAL_HARD_BRIDGE_V1/WORKSPACE.",
        "",
        "V1 may read house files but may not write house files, commit, push, delete, overwrite, or execute arbitrary shell.",
        "",
        "## Use result",
        "",
        "Bridge responses can support house work, but house saves still require normal receipt, git proof, and final clean status."
    ) | Set-Content -LiteralPath $GearBridge -Encoding UTF8

    @(
        "# Front Door And Work Request Sorting Dissection",
        "",
        "Date: 2026-05-21",
        "Lane: HOUSE_WORK / WORK_SHED / SORTING_BENCH",
        "Status: DISSECTION / SUPPORT SAVE",
        "",
        "## Triggering user note",
        "",
        "The user identified a missing formula: when they give a job/task or ask for anything, the assistant needs a sorting method to decide whether the move is editing, research, mimic, adopt/adapt, issue repair, bridge transfer, or save.",
        "",
        "The user also identified the Local Hard Bridge front door as a real new tool surface that future assistants must know how to use.",
        "",
        "## Problem",
        "",
        "Without a sorting formula, the assistant may:",
        "",
        "- research when it should edit;",
        "- edit when it should place/find;",
        "- adopt when it should mimic/adapt;",
        "- save when it should park;",
        "- use a bridge as authority;",
        "- scatter a rule into too many places;",
        "- miss stale/support status;",
        "- fail to choose proof before action.",
        "",
        "## Repair",
        "",
        "Saved a support rule and card for Work Request Sorting Formula and Place Finder.",
        "",
        "Saved a support rule and card for Local Hard Bridge Front Door use.",
        "",
        "## Why not all places literally",
        "",
        "The user said the rule should find its way into all places. Clean interpretation: all appropriate places, not uncontrolled scatter.",
        "",
        "Appropriate places for this save:",
        "",
        "- BRAIN_LEARNING for behavior rule;",
        "- GEAR_RACK for reusable card;",
        "- SORTING_BENCH for dissection;",
        "- TODO for live-use testing;",
        "- CURRENT_HOUSE_WORK_STATUS for orientation;",
        "- ACTIVE_ANCHOR for next action;",
        "- PROOF_HISTORY for receipt.",
        "",
        "## Bridge proof used",
        "",
        "Local Hard Bridge V1 exists and was repaired.",
        "",
        "Current fixed runner SHA256:",
        $BridgeRunHash,
        "",
        "Policy SHA256:",
        $BridgePolicyHash,
        "",
        "Git sensor repair receipt SHA256:",
        $BridgeRepairHash,
        "",
        "## Boundary",
        "",
        "No bridge house-write expansion happened in this save.",
        "",
        "No doctrine, ACTIVE_GUIDES, CURRENT_TRUTH_INDEX, runtime, automation, dashboard, or permanent service was created.",
        "",
        "## Verdict",
        "",
        "PASS AS SUPPORT RULE SAVE if commit/push/clean proof succeeds.",
        "",
        "Live-use still required before promotion."
    ) | Set-Content -LiteralPath $Dissection -Encoding UTF8

    @(
        "# TODO - Local Hard Bridge And Work Sorting Live Use",
        "",
        "Date: 2026-05-21",
        "Lane: HOUSE_WORK / TODO",
        "Status: OPEN / LIVE-USE REQUIRED",
        "",
        "## Purpose",
        "",
        "Test the Work Request Sorting Formula and Local Hard Bridge Front Door rule on real work.",
        "",
        "## Test 1 - User notes as real problem",
        "",
        "Trigger: user gives notes and says they might be a real fix/problem.",
        "",
        "Expected: assistant runs OBJECT -> INTENT -> MODE -> PLACE -> AUTHORITY -> STALE -> PROOF -> DISPOSITION -> OUTPUT -> CLOSE before writing.",
        "",
        "## Test 2 - Bridge front door before house action",
        "",
        "Trigger: bridge-assisted house work.",
        "",
        "Expected: house_front_door response proves branch, HEAD, origin/main, clean status, and anchor/truth existence before any save.",
        "",
        "## Test 3 - Mimic/adopt/adapt distinction",
        "",
        "Trigger: user says mimic, copy, adopt, adapt, or this might be a fix.",
        "",
        "Expected: assistant copies the ability/pattern, not surface costume; adoption waits for place/proof/neighbor check.",
        "",
        "## Test 4 - All places request",
        "",
        "Trigger: user says put it everywhere or make future assistants know.",
        "",
        "Expected: assistant saves into appropriate lanes only and names why not uncontrolled scatter.",
        "",
        "## Blocked",
        "",
        "- no doctrine promotion;",
        "- no ACTIVE_GUIDES rewrite;",
        "- no CURRENT_TRUTH_INDEX rewrite;",
        "- no bridge house-write expansion without separate proof;",
        "- no runtime/automation/dashboard/permanent service;",
        "- no all-task ceremony."
    ) | Set-Content -LiteralPath $Todo -Encoding UTF8

    Add-Content -LiteralPath $StatusFile -Encoding UTF8 -Value @(
        "",
        "---",
        "",
        "## Front Door And Work Request Sorting Rules",
        "",
        "Status: SUPPORT RULES SAVED / LIVE-USE REQUIRED",
        "Date: 2026-05-21",
        "Base before save: main @ $ShortBefore",
        "",
        "Saved:",
        "- Work Request Sorting Formula and Place Finder Rule.",
        "- Local Hard Bridge Front Door Use Rule.",
        "- Gear Rack reusable cards.",
        "- Sorting Bench dissection.",
        "- TODO live-use queue.",
        "",
        "Meaning:",
        "Future assistant requests must be sorted by object, intent, mode, place, authority, stale state, proof, disposition, output, and close before action when routing matters.",
        "",
        "Bridge meaning:",
        "Local Hard Bridge V1 is a local-only PowerShell-backed front door and carrier. It can support house reads and workspace writes, but it is not authority and V1 cannot write house files.",
        "",
        "Boundary:",
        "No doctrine, ACTIVE_GUIDES rewrite, CURRENT_TRUTH_INDEX rewrite, runtime, dashboard, automation, bridge house-write expansion, or all-places scatter.",
        "",
        "Next:",
        "Use the sorting formula and bridge front door on the next real note/bridge-assisted task as live-use proof."
    )

    @(
        "# ACTIVE ANCHOR",
        "",
        "Recorded base before this save:",
        "main @ $ShortBefore",
        "",
        "Current active ball:",
        "Front Door Bridge use rule and Work Request Sorting Formula have been saved as support rules; next use should test them on a real note or bridge-assisted task.",
        "",
        "Next allowed move:",
        "Use Local Hard Bridge V1 front door plus Work Request Sorting Formula on the next real job/note before writing or saving. If the bridge is used, inspect house_front_door first and require clean git state before save.",
        "",
        "Blocked moves:",
        "- Do not promote these support rules to doctrine.",
        "- Do not rewrite ACTIVE_GUIDES.",
        "- Do not rewrite CURRENT_TRUTH_INDEX.",
        "- Do not expand Local Hard Bridge V1 into house write mode without separate proof.",
        "- Do not build runtime, dashboard, automation, network service, or permanent bridge process.",
        "- Do not treat bridge output as authority.",
        "- Do not treat mule output as authority.",
        "- Do not scatter rules into all places literally; use appropriate lanes only.",
        "- Do not skip Place Finder before writing when routing matters."
    ) | Set-Content -LiteralPath $AnchorFile -Encoding UTF8

    $HashRuleSort = (Get-FileHash -LiteralPath $RuleSort -Algorithm SHA256).Hash
    $HashRuleBridge = (Get-FileHash -LiteralPath $RuleBridge -Algorithm SHA256).Hash
    $HashGearSort = (Get-FileHash -LiteralPath $GearSort -Algorithm SHA256).Hash
    $HashGearBridge = (Get-FileHash -LiteralPath $GearBridge -Algorithm SHA256).Hash
    $HashDissection = (Get-FileHash -LiteralPath $Dissection -Algorithm SHA256).Hash
    $HashTodo = (Get-FileHash -LiteralPath $Todo -Algorithm SHA256).Hash
    $HashStatus = (Get-FileHash -LiteralPath $StatusFile -Algorithm SHA256).Hash
    $HashAnchor = (Get-FileHash -LiteralPath $AnchorFile -Algorithm SHA256).Hash

    @(
        "FRONT DOOR AND WORK SORTING RULES SAVE RECEIPT",
        "Date: " + (Get-Date -Format o),
        "",
        "Base before save:",
        $HeadBefore,
        "",
        "Verdict:",
        "PASS AS SUPPORT RULE SAVE / LIVE-USE REQUIRED",
        "",
        "Saved files:",
        $RuleSort,
        "SHA256:",
        $HashRuleSort,
        "",
        $RuleBridge,
        "SHA256:",
        $HashRuleBridge,
        "",
        $GearSort,
        "SHA256:",
        $HashGearSort,
        "",
        $GearBridge,
        "SHA256:",
        $HashGearBridge,
        "",
        $Dissection,
        "SHA256:",
        $HashDissection,
        "",
        $Todo,
        "SHA256:",
        $HashTodo,
        "",
        "Updated status:",
        $StatusFile,
        "SHA256:",
        $HashStatus,
        "",
        "Updated anchor:",
        $AnchorFile,
        "SHA256:",
        $HashAnchor,
        "",
        "Local Hard Bridge V1 evidence:",
        "Bridge root: $BridgeRoot",
        "Run once SHA256: $BridgeRunHash",
        "Policy SHA256: $BridgePolicyHash",
        "Readme SHA256: $BridgeReadMeHash",
        "Git sensor repair receipt SHA256: $BridgeRepairHash",
        "",
        "Meaning:",
        "A real sorting formula now exists for user jobs/tasks/notes/research/edit/mimic/adopt/fix/bridge/save requests. A front-door rule now exists for future assistants using Local Hard Bridge V1.",
        "",
        "Boundary:",
        "No doctrine, no ACTIVE_GUIDES rewrite, no CURRENT_TRUTH_INDEX rewrite, no runtime, no dashboard, no automation, no network service, no bridge house-write expansion, no all-places scatter.",
        "",
        "Next:",
        "Use the formula and bridge front-door check on the next real note/bridge-assisted task as live-use proof."
    ) | Set-Content -LiteralPath $Receipt -Encoding UTF8

    $HashReceipt = (Get-FileHash -LiteralPath $Receipt -Algorithm SHA256).Hash

    $AddNormal = @(
        $RuleSort,
        $RuleBridge,
        $GearSort,
        $GearBridge,
        $Dissection,
        $Todo,
        $StatusFile,
        $AnchorFile
    )

    git add -- $AddNormal
    if ($LASTEXITCODE -ne 0) {
        throw "STOP. git add failed for normal files."
    }

    git add -f -- $Receipt
    if ($LASTEXITCODE -ne 0) {
        throw "STOP. git add -f failed for receipt."
    }

    $Unstaged = @(git diff --name-only)
    if ($Unstaged.Count -gt 0) {
        Write-Host "Unstaged files remain:"
        $Unstaged | ForEach-Object { Write-Host $_ }
        throw "STOP. Unstaged changes remain after add."
    }

    git commit -m "Add front door and work sorting rules"
    if ($LASTEXITCODE -ne 0) {
        throw "STOP. Commit failed."
    }

    git push origin main
    if ($LASTEXITCODE -ne 0) {
        throw "STOP. Push failed."
    }

    git fetch origin main | Out-Null

    $HeadAfter = (git rev-parse HEAD).Trim()
    $OriginAfter = (git rev-parse origin/main).Trim()
    $ShortAfter = (git rev-parse --short HEAD).Trim()
    $StatusAfter = @(git status --short)

    if ($HeadAfter -ne $OriginAfter) {
        throw "STOP. HEAD does not match origin/main after push."
    }

    Write-Host ""
    Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX" -ForegroundColor Green
    Write-Host "FRONT DOOR AND WORK SORTING RULES SAVE COMPLETE"
    Write-Host "Verdict: PASS AS SUPPORT RULE SAVE / LIVE-USE REQUIRED"
    Write-Host "Work sorting rule: $RuleSort"
    Write-Host "Work sorting rule SHA256: $HashRuleSort"
    Write-Host "Front door rule: $RuleBridge"
    Write-Host "Front door rule SHA256: $HashRuleBridge"
    Write-Host "Work sorting card: $GearSort"
    Write-Host "Work sorting card SHA256: $HashGearSort"
    Write-Host "Front door card: $GearBridge"
    Write-Host "Front door card SHA256: $HashGearBridge"
    Write-Host "Dissection: $Dissection"
    Write-Host "Dissection SHA256: $HashDissection"
    Write-Host "TODO: $Todo"
    Write-Host "TODO SHA256: $HashTodo"
    Write-Host "Receipt: $Receipt"
    Write-Host "Receipt SHA256: $HashReceipt"
    Write-Host "Bridge runner SHA256 used as evidence: $BridgeRunHash"
    Write-Host "Commit: $ShortAfter"
    Write-Host "HEAD: $HeadAfter"
    Write-Host "origin/main: $OriginAfter"
    if ($StatusAfter.Count -gt 0) {
        Write-Host "Repo status after: NOT CLEAN"
        $StatusAfter | ForEach-Object { Write-Host $_ }
    } else {
        Write-Host "Repo status after: clean"
    }
    Write-Host "Next: use Work Request Sorting Formula plus Local Hard Bridge front door on the next real note/bridge-assisted task as live-use proof."
    Write-Host "Boundary: no doctrine/ACTIVE_GUIDES/CURRENT_TRUTH_INDEX/runtime/dashboard/automation/network service/bridge house-write expansion/all-places scatter."
    Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX" -ForegroundColor Green
}