& {
    $ErrorActionPreference = "Stop"

    $Root = "C:\Users\13527\Desktop\Jxhnny_Kleen_C3dz"
    $Unit123 = "$env:USERPROFILE\Desktop\123"
    $RunStamp = Get-Date -Format "yyyyMMdd_HHmmss"

    Set-Location $Root

    Write-Host "POINT OF WORK READBACK"
    Write-Host "Task: Save 123 outside-storage rule, save adopt/adapt found-fix rule, and place HNS Mesh V2 files into a clean mule active handoff room."
    Write-Host "Boundary: 123 is support/storage, not authority. Mule supports, not commands. No doctrine/runtime/dashboard/automation."
    Write-Host ""

    if (-not (Test-Path ".git")) {
        throw "STOP. Not in Mr.Kleen brain home."
    }

    if ((git branch --show-current).Trim() -ne "main") {
        throw "STOP. Wrong branch. Expected main."
    }

    if (-not (Test-Path -LiteralPath $Unit123)) {
        throw "STOP. 123 outside storage unit not found: $Unit123"
    }

    $StatusBefore = @(git status --short)
    if ($StatusBefore.Count -gt 0) {
        Write-Host "Dirty state before save:"
        $StatusBefore | ForEach-Object { Write-Host $_ }
        throw "STOP. Mr.Kleen must be clean before this handoff save."
    }

    $HeadBefore = (git rev-parse HEAD).Trim()
    $ShortBefore = (git rev-parse --short HEAD).Trim()

    $Rule123 = "BRAIN_LEARNING\ASSISTANT_123_OUTSIDE_STORAGE_UNIT_RULE_20260520.md"
    $RuleAdopt = "BRAIN_LEARNING\ADOPT_ADAPT_FOUND_FIX_LIVE_APPLICATION_RULE_20260520.md"
    $Failure = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\FOUND_FIX_NOT_APPLIED_TO_LIVE_LANE_FAILURE_20260520.md"
    $StatusFile = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"
    $AnchorFile = "ACTIVE_ANCHOR.txt"
    $Receipt = "PROOF_HISTORY\123_STORAGE_HNS_MULE_HANDOFF_AND_ADOPT_ADAPT_RULE_RECEIPT_20260520.txt"

    $ActiveHandoffRoot = "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\ACTIVE_HANDOFFS"
    $ArchiveRoot = "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\HANDOFF_ARCHIVE"
    $ReturnRoot = "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\RETURNS"
    $JobName = "HNS_MESH_V2_REVISION_HANDOFF_20260520_$RunStamp"
    $JobFolder = Join-Path $ActiveHandoffRoot $JobName
    $Pointer = Join-Path $ActiveHandoffRoot "CURRENT_ACTIVE_HANDOFF_POINTER.md"
    $ReadFirst = Join-Path $JobFolder "READ_FIRST_FOR_MULE_HNS_MESH_V2_20260520.md"

    foreach ($Existing in @($Rule123, $RuleAdopt, $Failure, $Receipt)) {
        if (Test-Path -LiteralPath $Existing) {
            throw "STOP. Target file already exists; not overwriting: $Existing"
        }
    }

    foreach ($Path in @(
        (Split-Path -Parent $Rule123),
        (Split-Path -Parent $RuleAdopt),
        (Split-Path -Parent $Failure),
        (Split-Path -Parent $Receipt),
        $ActiveHandoffRoot,
        $ArchiveRoot,
        $ReturnRoot
    )) {
        New-Item -ItemType Directory -Force -Path $Path | Out-Null
    }

    $RequiredNames = @(
        "CORRECTED_HNS_MESH_REPAIR_STATEMENT_20260520.md",
        "MULE_HANDOFF_HNS_MESH_REVISE_V2_20260520.md",
        "MULE_WORKSHOP_ACTIVE_HANDOFF_AND_STORAGE_RULE_20260520.md"
    )

    $OptionalNames = @(
        "HOUSE_NERVOUS_SYSTEM_ALARM_DEBUGGER_MESH_RESEARCH_PACKET_20260520.md"
    )

    $TempExtract = $null
    $FoundZip = ""

    try {
        $ZipHit = Get-ChildItem -LiteralPath $Unit123 -Recurse -File -Filter "HNS_MESH_MULE_REPAIR_PACKET_20260520.zip" -ErrorAction SilentlyContinue |
            Sort-Object LastWriteTime -Descending |
            Select-Object -First 1

        if ($ZipHit) {
            $FoundZip = $ZipHit.FullName
            $TempExtract = Join-Path $env:TEMP "HNS_MESH_MULE_REPAIR_PACKET_EXTRACT_$RunStamp"
            New-Item -ItemType Directory -Force -Path $TempExtract | Out-Null
            Expand-Archive -LiteralPath $FoundZip -DestinationPath $TempExtract -Force
        }

        function Find-SourceFile {
            param([string]$Name)

            $Hit = Get-ChildItem -LiteralPath $Unit123 -Recurse -File -Filter $Name -ErrorAction SilentlyContinue |
                Sort-Object LastWriteTime -Descending |
                Select-Object -First 1

            if (-not $Hit -and $TempExtract -and (Test-Path -LiteralPath $TempExtract)) {
                $Hit = Get-ChildItem -LiteralPath $TempExtract -Recurse -File -Filter $Name -ErrorAction SilentlyContinue |
                    Sort-Object LastWriteTime -Descending |
                    Select-Object -First 1
            }

            if ($Hit) {
                return $Hit.FullName
            }

            return $null
        }

        $ResolvedRequired = @{}
        foreach ($Name in $RequiredNames) {
            $Found = Find-SourceFile -Name $Name
            if (-not $Found) {
                throw "STOP. Required handoff file not found in 123 or packet zip: $Name. Put the zip/files in Desktop\123, then rerun this helper."
            }
            $ResolvedRequired[$Name] = $Found
        }

        $ResolvedOptional = @{}
        foreach ($Name in $OptionalNames) {
            $Found = Find-SourceFile -Name $Name
            if ($Found) {
                $ResolvedOptional[$Name] = $Found
            }
        }

        $ArchivedOld = "NO"
        $ArchiveBucket = ""

        $ExistingActive = @(Get-ChildItem -LiteralPath $ActiveHandoffRoot -Force -ErrorAction SilentlyContinue)
        if ($ExistingActive.Count -gt 0) {
            $ArchiveBucket = Join-Path $ArchiveRoot "ARCHIVED_BEFORE_HNS_MESH_V2_$RunStamp"
            New-Item -ItemType Directory -Force -Path $ArchiveBucket | Out-Null

            foreach ($Item in $ExistingActive) {
                Move-Item -LiteralPath $Item.FullName -Destination $ArchiveBucket -Force
            }

            $ArchivedOld = "YES"
        }

        New-Item -ItemType Directory -Force -Path $JobFolder | Out-Null

        foreach ($Name in $RequiredNames) {
            Copy-Item -LiteralPath $ResolvedRequired[$Name] -Destination (Join-Path $JobFolder $Name) -Force
        }

        foreach ($Name in $OptionalNames) {
            if ($ResolvedOptional.ContainsKey($Name)) {
                Copy-Item -LiteralPath $ResolvedOptional[$Name] -Destination (Join-Path $JobFolder $Name) -Force
            }
        }

        if (-not $ResolvedOptional.ContainsKey("HOUSE_NERVOUS_SYSTEM_ALARM_DEBUGGER_MESH_RESEARCH_PACKET_20260520.md")) {
            $MissingNote = Join-Path $JobFolder "MISSING_EXPECTED_SOURCE_NOTE_20260520.md"
            @(
                "# Missing Expected Source Note",
                "",
                "Date: 2026-05-20",
                "Status: SOURCE GAP NOTE",
                "",
                "The mule handoff expects the prior research packet:",
                "",
                "`HOUSE_NERVOUS_SYSTEM_ALARM_DEBUGGER_MESH_RESEARCH_PACKET_20260520.md`",
                "",
                "That file was not found in Desktop\123 or inside the detected repair packet zip during this handoff placement.",
                "",
                "The mule must report this gap if it needs the prior research packet to complete the full V2 revision."
            ) | Set-Content -LiteralPath $MissingNote -Encoding UTF8
        }

        @(
            "# READ FIRST - Mule HNS Mesh V2 Revision",
            "",
            "Date: 2026-05-20",
            "Active handoff folder:",
            $JobFolder,
            "",
            "Mule must read this file first, then read:",
            "",
            "1. MULE_HANDOFF_HNS_MESH_REVISE_V2_20260520.md",
            "2. CORRECTED_HNS_MESH_REPAIR_STATEMENT_20260520.md",
            "3. MULE_WORKSHOP_ACTIVE_HANDOFF_AND_STORAGE_RULE_20260520.md",
            "4. HOUSE_NERVOUS_SYSTEM_ALARM_DEBUGGER_MESH_RESEARCH_PACKET_20260520.md if present.",
            "",
            "Mission:",
            "Revise the House Nervous System / Alarm-Debugger Mesh into a proper V2 source-pattern candidate using MTER, link map, source-to-claim map, rejection ledger, delta, and tiny nerve test shape.",
            "",
            "Return lane:",
            "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\RETURNS\HNS_MESH_V2_REVISION_RETURN_20260520",
            "",
            "Workshop rule:",
            "Keep current handoff files in ACTIVE_HANDOFFS. Move old handoffs to HANDOFF_ARCHIVE or STORAGE_SHED. Keep current vs old, input vs output, source vs authority, and active vs archived clean.",
            "",
            "Boundary:",
            "Mule supports. Mule does not command Mr.Kleen. No doctrine, runtime, dashboard, ACTIVE_GUIDES rewrite, or CURRENT_TRUTH_INDEX rewrite."
        ) | Set-Content -LiteralPath $ReadFirst -Encoding UTF8

        @(
            "# 123 Outside Storage Unit Rule",
            "",
            "Date: 2026-05-20",
            "Lane: BRAIN_LEARNING",
            "Status: ACTIVE BEHAVIOR RULE / FILE INTAKE HYGIENE",
            "Base before save: $ShortBefore",
            "",
            "## Rule",
            "",
            "`C:\Users\13527\Desktop\123` is the assistant's outside storage unit.",
            "",
            "The user may drop files there for the assistant to find, sort, copy, or route into Mr.Kleen.",
            "",
            "123 is an outside shed/storage unit across the bridge. It is support/storage, not Mr.Kleen authority, doctrine, proof, or active truth by itself.",
            "",
            "## Working meaning",
            "",
            "When the user says files are in 123, search 123 first.",
            "",
            "Preserve custody:",
            "",
            "- source location;",
            "- file names;",
            "- copied destination;",
            "- active vs archived;",
            "- source vs authority;",
            "- input vs output;",
            "- support vs command.",
            "",
            "## Allowed behavior",
            "",
            "The assistant may suggest/build subrooms inside 123 when useful, but 123 must not become messy, authoritative, or confused with Mr.Kleen.",
            "",
            "Useful files from 123 should be copied or routed into the correct Mr.Kleen lane with proof when selected.",
            "",
            "## Boundary",
            "",
            "123 is not doctrine.",
            "123 is not proof by itself.",
            "123 is not CURRENT_TRUTH_INDEX.",
            "123 is not ACTIVE_GUIDES.",
            "123 is not a parking excuse for loose helpers.",
            "",
            "## Default",
            "",
            "Find in 123 -> classify -> copy/route into Mr.Kleen lane -> receipt/proof if saved -> leave 123 organized."
        ) | Set-Content -LiteralPath $Rule123 -Encoding UTF8

        @(
            "# Adopt / Adapt Found Fix Live Application Rule",
            "",
            "Date: 2026-05-20",
            "Lane: BRAIN_LEARNING",
            "Status: ACTIVE BEHAVIOR RULE / RULE-APPLICATION REPAIR",
            "Base before save: $ShortBefore",
            "",
            "## Rule",
            "",
            "When a failure exposes a working fix, the assistant must apply that fix to the current active lane if it fits.",
            "",
            "Do not merely name the fix, explain the fix, or save the fix for later while continuing through the same failing pattern.",
            "",
            "Pattern:",
            "",
            "failure exposes fix",
            "-> adopt/adapt the fix into the live workflow",
            "-> continue through the safer route",
            "-> capture as rule/nerve if recurring or high-impact",
            "-> prove the repair",
            "",
            "## Example",
            "",
            "If a giant PowerShell paste fails because PowerShell enters continuation prompt, do not send another giant pasted script for the same lane.",
            "",
            "Adopt the known fix immediately:",
            "",
            "- switch to file-based helper;",
            "- make helper self-clean after successful proof if temporary;",
            "- or split into smaller staged commands.",
            "",
            "## Failure class",
            "",
            "Found fix but not applied = rule-application failure.",
            "",
            "This is not just a tool failure. It is a failure to transfer a learned working pattern into the current live route.",
            "",
            "## Boundary",
            "",
            "The fix must still respect authority, proof, lane placement, user command, and No Rule King.",
            "",
            "Adopt/adapt does not mean universal install. It means apply the proven repair where it respectfully fits."
        ) | Set-Content -LiteralPath $RuleAdopt -Encoding UTF8

        @(
            "# Found Fix Not Applied To Live Lane - Failure Capture",
            "",
            "Date: 2026-05-20",
            "Lane: HOUSE_WORK / WORK_SHED / SORTING_BENCH",
            "Status: FAILURE CAPTURE / RULE-APPLICATION REPAIR",
            "Base before save: $ShortBefore",
            "",
            "## What happened",
            "",
            "A large PowerShell paste entered continuation prompt and had to be cancelled.",
            "",
            "The safer fix was known: stop using giant pasted blocks for this lane and switch to a file-based helper or smaller staged commands.",
            "",
            "The assistant recognized the fix but did not immediately apply it cleanly to the active workflow.",
            "",
            "## User correction",
            "",
            "The user identified this as an adapt/adopt failure: the fix was found, but not applied because no live rule forced the transfer.",
            "",
            "## Root failure",
            "",
            "The issue was not only a PowerShell paste issue.",
            "",
            "Root class:",
            "REVISE-METHOD NON-FIRE + FOUND-FIX ADOPTION FAILURE + LIVE-LANE TRANSFER FAILURE",
            "",
            "## Correct behavior",
            "",
            "When a fix is discovered and fits the active route, adopt/adapt it immediately into the current workflow.",
            "",
            "For this lane, the repair is:",
            "",
            "- no more giant PowerShell paste blocks for this task;",
            "- use a file-based helper;",
            "- make temporary helper self-clean after successful proof;",
            "- preserve proof and return a clean copy-back block.",
            "",
            "## Boundary",
            "",
            "No doctrine rewrite.",
            "No ACTIVE_GUIDES rewrite.",
            "No CURRENT_TRUTH_INDEX rewrite.",
            "No runtime.",
            "No automation.",
            "No dashboard."
        ) | Set-Content -LiteralPath $Failure -Encoding UTF8

        @(
            "# Current Active Mule Handoff Pointer",
            "",
            "Date: 2026-05-20",
            "Status: ACTIVE",
            "",
            "Current active handoff:",
            $JobFolder,
            "",
            "Read first:",
            $ReadFirst,
            "",
            "Mission:",
            "HNS Mesh V2 revision using MTER, link map, source-to-claim map, rejection ledger, delta, and tiny nerve test template.",
            "",
            "Return lane:",
            "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\RETURNS\HNS_MESH_V2_REVISION_RETURN_20260520",
            "",
            "Archived old active handoffs:",
            $ArchivedOld,
            "",
            "Archive bucket:",
            $ArchiveBucket,
            "",
            "Boundary:",
            "Mule supports. Mule is not authority."
        ) | Set-Content -LiteralPath $Pointer -Encoding UTF8

        Add-Content -LiteralPath $StatusFile -Encoding UTF8 -Value @(
            "",
            "---",
            "",
            "## 123 Outside Storage Unit + HNS Mesh Mule Handoff + Adopt/Adapt Repair",
            "",
            "Status: RULES SAVED / ACTIVE MULE HANDOFF PLACED",
            "Date: 2026-05-20",
            "Base before save: $ShortBefore",
            "",
            "123 outside storage unit:",
            $Unit123,
            "",
            "123 rule:",
            $Rule123,
            "",
            "Adopt/adapt rule:",
            $RuleAdopt,
            "",
            "Failure capture:",
            $Failure,
            "",
            "Active mule handoff:",
            $JobFolder,
            "",
            "Read-first file:",
            $ReadFirst,
            "",
            "Pointer:",
            $Pointer,
            "",
            "Archived old active handoffs:",
            $ArchivedOld,
            "",
            "Archive bucket:",
            $ArchiveBucket,
            "",
            "Meaning:",
            "123 is the assistant's outside storage unit for user-dropped files. It is support/storage, not authority. HNS Mesh repair packet files were copied into a clean mule active handoff room. The found-fix adoption failure was captured as an active behavior rule.",
            "",
            "Boundary:",
            "No doctrine, no ACTIVE_GUIDES rewrite, no CURRENT_TRUTH_INDEX rewrite, no runtime, no automation, no dashboard, no mule-as-authority."
        )

        @(
            "# ACTIVE ANCHOR",
            "",
            "Recorded base before this save:",
            "main @ $ShortBefore",
            "",
            "Current active ball:",
            "HNS Mesh V2 mule revision handoff from 123 outside storage unit, plus adopt/adapt found-fix repair.",
            "",
            "Current active handoff:",
            $JobFolder,
            "",
            "Read-first file:",
            $ReadFirst,
            "",
            "Next allowed move:",
            "Mule reads active handoff first, completes V2 revision packet, returns outputs to the named RETURNS lane. House must read/disposition mule output before adoption.",
            "",
            "Blocked moves:",
            "- Do not treat 123 as authority.",
            "- Do not treat mule output as command.",
            "- Do not install HNS Mesh as doctrine.",
            "- Do not rewrite ACTIVE_GUIDES.",
            "- Do not rewrite CURRENT_TRUTH_INDEX.",
            "- Do not build runtime, dashboard, automation, or permanent alarm feed from this handoff.",
            "- Do not leave old handoffs mixed with current handoffs.",
            "- Do not continue using a known-failing route after a better fix is found.",
            "- Keep No Alarm King."
        ) | Set-Content -LiteralPath $AnchorFile -Encoding UTF8

        $Rule123Hash = (Get-FileHash -LiteralPath $Rule123 -Algorithm SHA256).Hash
        $RuleAdoptHash = (Get-FileHash -LiteralPath $RuleAdopt -Algorithm SHA256).Hash
        $FailureHash = (Get-FileHash -LiteralPath $Failure -Algorithm SHA256).Hash
        $PointerHash = (Get-FileHash -LiteralPath $Pointer -Algorithm SHA256).Hash
        $ReadFirstHash = (Get-FileHash -LiteralPath $ReadFirst -Algorithm SHA256).Hash
        $StatusHash = (Get-FileHash -LiteralPath $StatusFile -Algorithm SHA256).Hash
        $AnchorHash = (Get-FileHash -LiteralPath $AnchorFile -Algorithm SHA256).Hash

        $CopiedFiles = @(Get-ChildItem -LiteralPath $JobFolder -File | Sort-Object Name)
        $CopiedLines = @()
        foreach ($File in $CopiedFiles) {
            $Hash = (Get-FileHash -LiteralPath $File.FullName -Algorithm SHA256).Hash
            $Rel = Resolve-Path -LiteralPath $File.FullName -Relative
            $CopiedLines += "$Rel"
            $CopiedLines += "SHA256: $Hash"
        }

        $ReceiptLines = @(
            "123 STORAGE + HNS MESH MULE HANDOFF + ADOPT/ADAPT RULE RECEIPT",
            "Date: $(Get-Date -Format o)",
            "",
            "Base before save:",
            $HeadBefore,
            "",
            "Verdict:",
            "PASS AS STORAGE-UNIT RULE + ACTIVE MULE HANDOFF PLACEMENT + ADOPT/ADAPT RULE REPAIR",
            "",
            "123 outside storage unit:",
            $Unit123,
            "",
            "Found zip:",
            "$FoundZip",
            "",
            "123 rule:",
            $Rule123,
            "SHA256:",
            $Rule123Hash,
            "",
            "Adopt/adapt rule:",
            $RuleAdopt,
            "SHA256:",
            $RuleAdoptHash,
            "",
            "Failure capture:",
            $Failure,
            "SHA256:",
            $FailureHash,
            "",
            "Active handoff folder:",
            $JobFolder,
            "",
            "Read-first file:",
            $ReadFirst,
            "SHA256:",
            $ReadFirstHash,
            "",
            "Pointer:",
            $Pointer,
            "SHA256:",
            $PointerHash,
            "",
            "Archived old active handoffs:",
            $ArchivedOld,
            "",
            "Archive bucket:",
            $ArchiveBucket,
            "",
            "Copied handoff files:"
        )

        $ReceiptLines += $CopiedLines

        $ReceiptLines += @(
            "",
            "Updated status:",
            $StatusFile,
            "SHA256:",
            $StatusHash,
            "",
            "Updated anchor:",
            $AnchorFile,
            "SHA256:",
            $AnchorHash,
            "",
            "Locked behavior:",
            "When a failure exposes a working fix, the assistant must adopt/adapt it into the live workflow if it fits.",
            "",
            "Boundary:",
            "123 is support/storage, not authority.",
            "Mule supports, not commands.",
            "No doctrine rewrite.",
            "No ACTIVE_GUIDES rewrite.",
            "No CURRENT_TRUTH_INDEX rewrite.",
            "No runtime.",
            "No automation.",
            "No dashboard.",
            "No permanent alarm feed.",
            "",
            "Next:",
            "Mule reads the active handoff pointer and read-first file, then returns V2 revision outputs to the named RETURNS lane."
        )

        $ReceiptLines | Set-Content -LiteralPath $Receipt -Encoding UTF8
        $ReceiptHash = (Get-FileHash -LiteralPath $Receipt -Algorithm SHA256).Hash

        git add -- $Rule123 $RuleAdopt $Failure $StatusFile $AnchorFile $ActiveHandoffRoot $ArchiveRoot
        if ($LASTEXITCODE -ne 0) {
            throw "STOP. git add failed."
        }

        git add -f -- $Receipt
        if ($LASTEXITCODE -ne 0) {
            throw "STOP. git add -f receipt failed."
        }

        $Unstaged = @(git diff --name-only)
        if ($Unstaged.Count -gt 0) {
            Write-Host "Unstaged changes remain:"
            $Unstaged | ForEach-Object { Write-Host $_ }
            throw "STOP. Unstaged changes remain."
        }

        git commit -m "Add 123 storage and HNS mule handoff"
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

        $SelfCleanup = "SKIPPED: PSCommandPath unavailable"
        if ($PSCommandPath -and (Test-Path -LiteralPath $PSCommandPath)) {
            try {
                $SelfPath = $PSCommandPath
                if (-not $SelfPath.StartsWith($Root, [System.StringComparison]::OrdinalIgnoreCase)) {
                    Remove-Item -LiteralPath $SelfPath -Force
                    $SelfCleanup = "REMOVED TEMP HELPER: $SelfPath"
                } else {
                    $SelfCleanup = "SKIPPED: helper is inside Mr.Kleen path"
                }
            }
            catch {
                $SelfCleanup = "FAILED TEMP HELPER CLEANUP: $($_.Exception.Message)"
            }
        }

        Write-Host ""
        Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX" -ForegroundColor Green
        Write-Host "123 STORAGE + HNS MESH MULE HANDOFF + ADOPT/ADAPT RULE SAVE COMPLETE"
        Write-Host "Verdict: PASS AS STORAGE-UNIT RULE + ACTIVE MULE HANDOFF PLACEMENT + ADOPT/ADAPT RULE REPAIR"
        Write-Host "123 rule: $Rule123"
        Write-Host "123 rule SHA256: $Rule123Hash"
        Write-Host "Adopt/adapt rule: $RuleAdopt"
        Write-Host "Adopt/adapt rule SHA256: $RuleAdoptHash"
        Write-Host "Failure capture: $Failure"
        Write-Host "Failure capture SHA256: $FailureHash"
        Write-Host "Active handoff folder: $JobFolder"
        Write-Host "Read-first file: $ReadFirst"
        Write-Host "Read-first SHA256: $ReadFirstHash"
        Write-Host "Pointer: $Pointer"
        Write-Host "Pointer SHA256: $PointerHash"
        Write-Host "Receipt: $Receipt"
        Write-Host "Receipt SHA256: $ReceiptHash"
        Write-Host "Archived old active handoffs: $ArchivedOld"
        Write-Host "Archive bucket: $ArchiveBucket"
        Write-Host "Temporary helper cleanup: $SelfCleanup"
        Write-Host "Commit: $ShortAfter"
        Write-Host "HEAD: $HeadAfter"
        Write-Host "origin/main: $OriginAfter"

        if ($StatusAfter.Count -gt 0) {
            Write-Host "Repo status after: NOT CLEAN"
            $StatusAfter | ForEach-Object { Write-Host $_ }
        } else {
            Write-Host "Repo status after: clean"
        }

        Write-Host "MULE KICKOFF: Read HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\ACTIVE_HANDOFFS\CURRENT_ACTIVE_HANDOFF_POINTER.md first, then READ_FIRST in the active HNS Mesh V2 handoff folder. Return outputs only to the named RETURNS lane. Keep old handoffs archived and current handoffs clean."
        Write-Host "Boundary: 123 is support/storage, not authority; mule supports, not commands; no doctrine/runtime/dashboard/automation."
        Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX" -ForegroundColor Green
    }
    finally {
        if ($TempExtract -and (Test-Path -LiteralPath $TempExtract)) {
            Remove-Item -LiteralPath $TempExtract -Recurse -Force
        }
    }
}
