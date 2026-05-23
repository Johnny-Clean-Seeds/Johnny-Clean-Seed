& {
    $ErrorActionPreference = "Stop"

    $Root = "$env:USERPROFILE\Desktop\Jxhnny_Kleen_C3dz"
    $BridgeRoot = "$env:USERPROFILE\Desktop\123\TOOLS\LOCAL_HARD_BRIDGE_V1"
    $Stamp = "20260521_001704"

    Set-Location $Root

    Write-Host "POINT OF WORK READBACK"
    Write-Host "Task: Save Child Shell / Sub-PowerShell Actuator live-test proof."
    Write-Host "Boundary: support rule and proof only. No doctrine. No ACTIVE_GUIDES. No CURRENT_TRUTH_INDEX. No bridge expansion. No house-write mode. No runtime. No automation. No dashboard."
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

    $Responses = Join-Path $BridgeRoot "HUB\RESPONSES"
    $Receipts = Join-Path $BridgeRoot "HUB\RECEIPTS"
    $Workspace = Join-Path $BridgeRoot "WORKSPACE"
    $RunOnce = Join-Path $BridgeRoot "TOOLS\RUN_BRIDGE_ONCE.ps1"
    $Policy = Join-Path $BridgeRoot "CONFIG\POLICY.json"

    if (-not (Test-Path -LiteralPath $RunOnce)) {
        throw "STOP. Bridge runner missing: $RunOnce"
    }

    if (-not (Test-Path -LiteralPath $Policy)) {
        throw "STOP. Bridge policy missing: $Policy"
    }

    $ReqFront = "REQ_CHILD_SHELL_FRONT_DOOR_$Stamp"
    $ReqWrite = "REQ_CHILD_SHELL_WRITE_$Stamp"
    $ReqOverwrite = "REQ_CHILD_SHELL_OVERWRITE_BLOCK_$Stamp"
    $ReqShell = "REQ_CHILD_SHELL_RAW_SHELL_BLOCK_$Stamp"

    function Get-JsonResponse {
        param([string]$RequestId)
        $Path = Join-Path $Responses ($RequestId + "_RESPONSE.json")
        if (-not (Test-Path -LiteralPath $Path)) {
            throw "STOP. Missing bridge response: $Path"
        }
        return [pscustomobject]@{
            Path = $Path
            Json = (Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json)
            Hash = (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
        }
    }

    function Get-ReceiptHash {
        param([string]$RequestId)
        $Path = Join-Path $Receipts ($RequestId + "_RECEIPT.txt")
        if (-not (Test-Path -LiteralPath $Path)) {
            throw "STOP. Missing bridge receipt: $Path"
        }
        return [pscustomobject]@{
            Path = $Path
            Hash = (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
        }
    }

    $Front = Get-JsonResponse $ReqFront
    $Write = Get-JsonResponse $ReqWrite
    $Overwrite = Get-JsonResponse $ReqOverwrite
    $Shell = Get-JsonResponse $ReqShell

    $FrontReceipt = Get-ReceiptHash $ReqFront
    $WriteReceipt = Get-ReceiptHash $ReqWrite
    $OverwriteReceipt = Get-ReceiptHash $ReqOverwrite
    $ShellReceipt = Get-ReceiptHash $ReqShell

    if (-not $Front.Json.ok) {
        throw "STOP. Front door request did not pass."
    }
    if ($Front.Json.clean -ne $true) {
        throw "STOP. Front door did not report clean house."
    }
    if ($Front.Json.head -ne $Front.Json.origin_main) {
        throw "STOP. Front door HEAD and origin/main do not match."
    }

    if ($Overwrite.Json.ok -ne $true) {
        throw "STOP. First write behavior did not pass. Expected the lexicographically earlier OVERWRITE_BLOCK request to create the file."
    }

    if ($Write.Json.ok -ne $false) {
        throw "STOP. Second write behavior did not block overwrite."
    }

    if (($Write.Json.error -notmatch "Overwrite blocked") -and ($Write.Json.error -notmatch "already exists")) {
        throw "STOP. Write failure was not an overwrite block."
    }

    if ($Shell.Json.ok -ne $false) {
        throw "STOP. Raw shell request did not block."
    }

    if ($Shell.Json.error -notmatch "Blocked or unknown action") {
        throw "STOP. Raw shell failure was not a block."
    }

    $TargetRel = "CHILD_SHELL_TEST\child_shell_first_limb_$Stamp.md"
    $TargetFile = Join-Path $Workspace $TargetRel
    if (-not (Test-Path -LiteralPath $TargetFile)) {
        throw "STOP. Child shell test target file missing: $TargetFile"
    }

    $TargetHash = (Get-FileHash -LiteralPath $TargetFile -Algorithm SHA256).Hash
    $RunOnceHash = (Get-FileHash -LiteralPath $RunOnce -Algorithm SHA256).Hash
    $PolicyHash = (Get-FileHash -LiteralPath $Policy -Algorithm SHA256).Hash

    $Rule = "BRAIN_LEARNING\CHILD_SHELL_ACTUATOR_RULE_20260521.md"
    $Card = "HOUSE_WORK\WORK_SHED\GEAR_RACK\CHILD_SHELL_ACTUATOR_CARD_20260521.md"
    $Disposition = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\CHILD_SHELL_FIRST_LIVE_TEST_DISPOSITION_20260521.md"
    $Todo = "HOUSE_WORK\TODO\CHILD_SHELL_ACTUATOR_NEXT_TESTS_TODO_20260521.md"
    $StatusFile = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"
    $AnchorFile = "ACTIVE_ANCHOR.txt"
    $Receipt = "PROOF_HISTORY\CHILD_SHELL_ACTUATOR_FIRST_LIVE_TEST_RECEIPT_20260521.txt"

    foreach ($Target in @($Rule, $Card, $Disposition, $Todo, $Receipt)) {
        if (Test-Path -LiteralPath $Target) {
            throw "STOP. Target already exists, not overwriting: $Target"
        }
    }

    foreach ($Dir in @(
        (Split-Path -Parent $Rule),
        (Split-Path -Parent $Card),
        (Split-Path -Parent $Disposition),
        (Split-Path -Parent $Todo),
        (Split-Path -Parent $Receipt)
    )) {
        New-Item -ItemType Directory -Force -Path $Dir | Out-Null
    }

    @(
        "# Child Shell Actuator Rule",
        "",
        "Date: 2026-05-21",
        "Lane: BRAIN_LEARNING",
        "Status: SUPPORT RULE / LIVE-TESTED / NOT DOCTRINE",
        "",
        "## Purpose",
        "",
        "The assistant must not treat raw PowerShell as the bridge-facing surface.",
        "",
        "PowerShell is the parent engine. The bridge-facing surface is a smaller child shell: a named, allowlisted action layer with hardstops, root guards, false-success guards, and receipts.",
        "",
        "## Clean definition",
        "",
        "Child Shell = request -> policy gate -> named safe function -> local PowerShell execution -> response and receipt.",
        "",
        "The child shell exposes only approved limbs. It does not expose arbitrary shell.",
        "",
        "## Why this matters",
        "",
        "The safe answer to PowerShell risk is not fear of PowerShell. The safe answer is a smaller command surface.",
        "",
        "The child shell is the bridge's local actuator boundary. It lets the assistant use local capability without giving the assistant a terminal.",
        "",
        "## V1 allowed child limbs",
        "",
        "- ping;",
        "- front_door;",
        "- powershell_check;",
        "- list/read/write_new_text/hash inside bridge WORKSPACE;",
        "- house_front_door read-only;",
        "- house_list read-only;",
        "- house_read_text read-only;",
        "- house_hash read-only.",
        "",
        "## V1 hardstops",
        "",
        "- no arbitrary shell;",
        "- no delete;",
        "- no overwrite;",
        "- no executable/script writes;",
        "- no path traversal;",
        "- no house write;",
        "- no git commit;",
        "- no git push;",
        "- no network service;",
        "- no success if the returned state is nonsense.",
        "",
        "## Live-test proof",
        "",
        "A first live test ran through Local Hard Bridge V1.",
        "",
        "It proved:",
        "- house_front_door returned real clean git state;",
        "- one write_new_text action created a new file inside WORKSPACE;",
        "- a later write_new_text to the same target was blocked as overwrite;",
        "- raw shell action was blocked as unknown/disallowed;",
        "- receipts were created for each request.",
        "",
        "## Watch item",
        "",
        "The first test had a label/order issue: request files were processed alphabetically, so the request named OVERWRITE_BLOCK created the file first, and the request named WRITE became the overwrite-blocked request.",
        "",
        "This does not invalidate the child-shell behavior proof, but it does prove dependent bridge tests must use ordered request names or separate phases.",
        "",
        "## Rule",
        "",
        "Future bridge expansions must add child limbs, not raw shell.",
        "",
        "Every new child limb must state:",
        "- trigger;",
        "- allowed root;",
        "- blocked paths/actions;",
        "- overwrite/delete rule;",
        "- proof output;",
        "- receipt output;",
        "- false-success guard;",
        "- rollback or cleanup path;",
        "- promotion boundary.",
        "",
        "## Boundary",
        "",
        "This support rule does not install doctrine and does not expand Local Hard Bridge V1 permissions."
    ) | Set-Content -LiteralPath $Rule -Encoding UTF8

    @(
        "# Child Shell Actuator Card",
        "",
        "Date: 2026-05-21",
        "Lane: HOUSE_WORK / WORK_SHED / GEAR_RACK",
        "Status: REUSABLE CARD / SUPPORT ONLY",
        "",
        "## Fast card",
        "",
        "Do not expose raw PowerShell.",
        "",
        "Expose child actions only.",
        "",
        "## Shape",
        "",
        "CHAT REQUEST -> POLICY -> CHILD ACTION -> POWERSHELL FUNCTION -> RESPONSE -> RECEIPT",
        "",
        "## Child action checklist",
        "",
        "- named action;",
        "- allowed root;",
        "- no path traversal;",
        "- no overwrite unless explicitly designed and previewed;",
        "- no delete unless separately authorized and backed up;",
        "- no arbitrary shell;",
        "- no house write in V1;",
        "- response hash;",
        "- receipt hash;",
        "- false-success guard.",
        "",
        "## First proof",
        "",
        "First live test at stamp $Stamp:",
        "",
        "- front door pass: $($Front.Hash)",
        "- write/create pass response: $($Overwrite.Hash)",
        "- overwrite block response: $($Write.Hash)",
        "- raw shell block response: $($Shell.Hash)",
        "- created target SHA256: $TargetHash",
        "",
        "## Watch",
        "",
        "Dependent request tests must use ordered request names or separate runs because the bridge processes request files by filename."
    ) | Set-Content -LiteralPath $Card -Encoding UTF8

    @(
        "# Child Shell First Live Test Disposition",
        "",
        "Date: 2026-05-21",
        "Lane: HOUSE_WORK / WORK_SHED / SORTING_BENCH",
        "Status: PASS WITH WATCH / SUPPORT EVIDENCE",
        "",
        "## Sorting formula",
        "",
        "OBJECT: Child Shell / Sub-PowerShell actuator.",
        "",
        "INTENT: Prove the bridge can act safely through child actions and refuse unsafe ones.",
        "",
        "MODE: LIVE TEST / TOOL PROOF.",
        "",
        "PLACE: Local Hard Bridge V1 in 123; save support rule to Mr.Kleen after proof.",
        "",
        "AUTHORITY: User direction, bridge policy, responses, receipts, and git front-door readback.",
        "",
        "PROOF: Allowed action, blocked overwrite, blocked raw shell, clean house front door.",
        "",
        "DISPOSITION: Save as support rule and card. Do not expand permissions.",
        "",
        "## Evidence",
        "",
        "Bridge root:",
        $BridgeRoot,
        "",
        "Runner SHA256:",
        $RunOnceHash,
        "",
        "Policy SHA256:",
        $PolicyHash,
        "",
        "Front door response:",
        $Front.Path,
        "SHA256:",
        $Front.Hash,
        "",
        "Write/create response:",
        $Overwrite.Path,
        "SHA256:",
        $Overwrite.Hash,
        "",
        "Overwrite-block response:",
        $Write.Path,
        "SHA256:",
        $Write.Hash,
        "",
        "Raw-shell-block response:",
        $Shell.Path,
        "SHA256:",
        $Shell.Hash,
        "",
        "Created target:",
        $TargetFile,
        "SHA256:",
        $TargetHash,
        "",
        "## Verdict",
        "",
        "PASS WITH WATCH.",
        "",
        "Functional proof passed:",
        "- house_front_door returned branch main, matching HEAD and origin/main, and clean true;",
        "- child write action created one file inside WORKSPACE;",
        "- second write to same file was blocked;",
        "- raw shell was blocked;",
        "- receipts existed.",
        "",
        "Watch issue:",
        "The test request labels were inverted by lexicographic processing. The request named OVERWRITE_BLOCK ran before the request named WRITE. Future dependent tests need ordered IDs such as 01, 02, 03, 04 or separate phases.",
        "",
        "## Boundary",
        "",
        "No doctrine, ACTIVE_GUIDES, CURRENT_TRUTH_INDEX, runtime, automation, dashboard, network service, bridge permission expansion, house write, git commit, or git push was performed by the bridge test."
    ) | Set-Content -LiteralPath $Disposition -Encoding UTF8

    @(
        "# TODO - Child Shell Actuator Next Tests",
        "",
        "Date: 2026-05-21",
        "Lane: HOUSE_WORK / TODO",
        "Status: OPEN / NEXT TESTS",
        "",
        "## Purpose",
        "",
        "Continue proving Child Shell / Sub-PowerShell as the safe Local Hard Bridge action surface.",
        "",
        "## Next test 1 - Ordered dependent request test",
        "",
        "Use request IDs ordered as 01, 02, 03, 04 so dependent create-then-overwrite-block tests run in intended order.",
        "",
        "Expected:",
        "- 01 front door passes;",
        "- 02 write_new_text creates;",
        "- 03 write_new_text to same path blocks overwrite;",
        "- 04 shell blocks.",
        "",
        "## Next test 2 - Path traversal block",
        "",
        "Attempt write_new_text to a target using .. traversal.",
        "",
        "Expected: blocked before write.",
        "",
        "## Next test 3 - Extension block",
        "",
        "Attempt write_new_text to .ps1 or .cmd inside WORKSPACE.",
        "",
        "Expected: blocked by extension guard.",
        "",
        "## Next test 4 - House read-only boundary",
        "",
        "Read and hash a house file, then verify no house status change.",
        "",
        "Expected: house remains clean.",
        "",
        "## Blocked",
        "",
        "- no arbitrary shell;",
        "- no delete;",
        "- no overwrite;",
        "- no house write;",
        "- no git commit/push from bridge;",
        "- no network service;",
        "- no permission expansion without new proof."
    ) | Set-Content -LiteralPath $Todo -Encoding UTF8

    Add-Content -LiteralPath $StatusFile -Encoding UTF8 -Value @(
        "",
        "---",
        "",
        "## Child Shell Actuator Live Test",
        "",
        "Status: PASS WITH WATCH / SUPPORT RULE SAVED",
        "Date: 2026-05-21",
        "Base before save: main @ $ShortBefore",
        "",
        "Meaning:",
        "The Local Hard Bridge should expose a Child Shell / Sub-PowerShell actuator, not raw PowerShell. The child shell allows named safe functions only and returns responses/receipts.",
        "",
        "Proof:",
        "- house_front_door returned clean git state;",
        "- a new file was written inside bridge WORKSPACE;",
        "- a second write to the same target was blocked;",
        "- raw shell action was blocked;",
        "- receipts were created.",
        "",
        "Watch:",
        "The first test had request-name order inversion. Future dependent tests need ordered IDs or separate phases.",
        "",
        "Boundary:",
        "No doctrine, ACTIVE_GUIDES, CURRENT_TRUTH_INDEX, bridge permission expansion, house write, runtime, dashboard, automation, network service, git commit/push from bridge."
    )

    @(
        "# ACTIVE ANCHOR",
        "",
        "Recorded base before this save:",
        "main @ $ShortBefore",
        "",
        "Current active ball:",
        "Child Shell / Sub-PowerShell actuator first live test passed with watch and was saved as support evidence.",
        "",
        "Next allowed move:",
        "Run an ordered Child Shell dependent request test or a path-traversal/extension-block test before any bridge permission expansion.",
        "",
        "Blocked moves:",
        "- Do not expose raw PowerShell.",
        "- Do not add arbitrary shell.",
        "- Do not add delete, overwrite, house write, git commit, git push, runtime, dashboard, automation, or network service.",
        "- Do not promote Child Shell to doctrine yet.",
        "- Do not rewrite ACTIVE_GUIDES.",
        "- Do not rewrite CURRENT_TRUTH_INDEX.",
        "- Do not ignore the request-order watch item."
    ) | Set-Content -LiteralPath $AnchorFile -Encoding UTF8

    $HashRule = (Get-FileHash -LiteralPath $Rule -Algorithm SHA256).Hash
    $HashCard = (Get-FileHash -LiteralPath $Card -Algorithm SHA256).Hash
    $HashDisposition = (Get-FileHash -LiteralPath $Disposition -Algorithm SHA256).Hash
    $HashTodo = (Get-FileHash -LiteralPath $Todo -Algorithm SHA256).Hash
    $HashStatus = (Get-FileHash -LiteralPath $StatusFile -Algorithm SHA256).Hash
    $HashAnchor = (Get-FileHash -LiteralPath $AnchorFile -Algorithm SHA256).Hash

    @(
        "CHILD SHELL ACTUATOR FIRST LIVE TEST RECEIPT",
        "Date: " + (Get-Date -Format o),
        "",
        "Base before save:",
        $HeadBefore,
        "",
        "Verdict:",
        "PASS WITH WATCH / SUPPORT RULE SAVED",
        "",
        "Saved files:",
        $Rule,
        "SHA256:",
        $HashRule,
        "",
        $Card,
        "SHA256:",
        $HashCard,
        "",
        $Disposition,
        "SHA256:",
        $HashDisposition,
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
        "Bridge evidence:",
        "Bridge root: $BridgeRoot",
        "Run once SHA256: $RunOnceHash",
        "Policy SHA256: $PolicyHash",
        "",
        "Front door response: $($Front.Path)",
        "Front door response SHA256: $($Front.Hash)",
        "Front door receipt: $($FrontReceipt.Path)",
        "Front door receipt SHA256: $($FrontReceipt.Hash)",
        "",
        "Write/create response: $($Overwrite.Path)",
        "Write/create response SHA256: $($Overwrite.Hash)",
        "Write/create receipt: $($OverwriteReceipt.Path)",
        "Write/create receipt SHA256: $($OverwriteReceipt.Hash)",
        "",
        "Overwrite-block response: $($Write.Path)",
        "Overwrite-block response SHA256: $($Write.Hash)",
        "Overwrite-block receipt: $($WriteReceipt.Path)",
        "Overwrite-block receipt SHA256: $($WriteReceipt.Hash)",
        "",
        "Raw-shell-block response: $($Shell.Path)",
        "Raw-shell-block response SHA256: $($Shell.Hash)",
        "Raw-shell-block receipt: $($ShellReceipt.Path)",
        "Raw-shell-block receipt SHA256: $($ShellReceipt.Hash)",
        "",
        "Created target: $TargetFile",
        "Created target SHA256: $TargetHash",
        "",
        "Watch:",
        "Request labels were inverted by lexicographic processing; future dependent tests need ordered IDs or separate phases.",
        "",
        "Boundary:",
        "No doctrine, no ACTIVE_GUIDES rewrite, no CURRENT_TRUTH_INDEX rewrite, no bridge permission expansion, no house write, no git commit/push from bridge, no runtime, no dashboard, no automation, no network service."
    ) | Set-Content -LiteralPath $Receipt -Encoding UTF8

    $HashReceipt = (Get-FileHash -LiteralPath $Receipt -Algorithm SHA256).Hash

    git add -- $Rule $Card $Disposition $Todo $StatusFile $AnchorFile
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

    git commit -m "Record child shell actuator live test"
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
    Write-Host "CHILD SHELL ACTUATOR LIVE TEST SAVE COMPLETE"
    Write-Host "Verdict: PASS WITH WATCH / SUPPORT RULE SAVED"
    Write-Host "Rule: $Rule"
    Write-Host "Rule SHA256: $HashRule"
    Write-Host "Card: $Card"
    Write-Host "Card SHA256: $HashCard"
    Write-Host "Disposition: $Disposition"
    Write-Host "Disposition SHA256: $HashDisposition"
    Write-Host "TODO: $Todo"
    Write-Host "TODO SHA256: $HashTodo"
    Write-Host "Receipt: $Receipt"
    Write-Host "Receipt SHA256: $HashReceipt"
    Write-Host "Bridge runner SHA256: $RunOnceHash"
    Write-Host "Policy SHA256: $PolicyHash"
    Write-Host "Target file SHA256: $TargetHash"
    Write-Host "Commit: $ShortAfter"
    Write-Host "HEAD: $HeadAfter"
    Write-Host "origin/main: $OriginAfter"
    if ($StatusAfter.Count -gt 0) {
        Write-Host "Repo status after: NOT CLEAN"
        $StatusAfter | ForEach-Object { Write-Host $_ }
    } else {
        Write-Host "Repo status after: clean"
    }
    Write-Host "Next: run ordered Child Shell dependent request test, path traversal block test, or extension block test before any bridge permission expansion."
    Write-Host "Boundary: no doctrine/ACTIVE_GUIDES/CURRENT_TRUTH_INDEX/bridge permission expansion/house write/runtime/dashboard/automation/network service."
    Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX" -ForegroundColor Green
}