& {
    $ErrorActionPreference = "Stop"

    $Root = "C:\Users\13527\Desktop\Jxhnny_Kleen_C3dz"
    $Unit123 = "$env:USERPROFILE\Desktop\123"
    $RunStamp = Get-Date -Format "yyyyMMdd_HHmmss"

    Set-Location $Root

    Write-Host "POINT OF WORK READBACK"
    Write-Host "Task: Save Tool Surface Passport / Link Map rule and first tool poolrun TODO."
    Write-Host "Boundary: tool/support-surface rule only. No doctrine, no ACTIVE_GUIDES, no CURRENT_TRUTH_INDEX, no runtime, no automation, no dashboard."
    Write-Host "Delivery rule: temporary helper self-cleans from 123 after successful proof."
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
        throw "STOP. Mr.Kleen must be clean before this save."
    }

    $HeadBefore = (git rev-parse HEAD).Trim()
    $ShortBefore = (git rev-parse --short HEAD).Trim()

    $Rule = "BRAIN_LEARNING\TOOL_SURFACE_PASSPORT_AND_LINK_MAP_RULE_20260521.md"
    $Failure = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\TOOL_SUPPORT_SURFACE_HAUNTING_FAILURE_CAPTURE_20260521.md"
    $Todo = "HOUSE_WORK\TODO\TOOL_PASSPORT_POOLRUN_AND_TEMPLATE_TODO_20260521.md"
    $StatusFile = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"
    $AnchorFile = "ACTIVE_ANCHOR.txt"
    $Receipt = "PROOF_HISTORY\TOOL_SURFACE_PASSPORT_RULE_RECEIPT_20260521.txt"

    foreach ($Existing in @($Rule, $Failure, $Todo, $Receipt)) {
        if (Test-Path -LiteralPath $Existing) {
            throw "STOP. Target file already exists; not overwriting: $Existing"
        }
    }

    foreach ($Path in @(
        (Split-Path -Parent $Rule),
        (Split-Path -Parent $Failure),
        (Split-Path -Parent $Todo),
        (Split-Path -Parent $Receipt)
    )) {
        New-Item -ItemType Directory -Force -Path $Path | Out-Null
    }

    @(
        '# Tool Surface Passport And Link Map Rule',
        '',
        'Date: 2026-05-21',
        'Lane: BRAIN_LEARNING',
        'Status: ACTIVE BEHAVIOR RULE / TOOL-SURFACE CUSTODY',
        'Base before save: ' + $ShortBefore,
        '',
        '## Rule',
        '',
        'Tools must work properly because tools are where rules become action.',
        '',
        'A tool is not safe because it works once.',
        '',
        'A tool is safe only when its trigger, home, lane, authority boundary, allowed touch, blocked touch, proof, neighbors, replacement or overlap state, cleanup/archive rule, stale condition, and decay condition are known.',
        '',
        '## What counts as a tool or support surface',
        '',
        'This rule covers:',
        '',
        '- PowerShell helpers;',
        '- generated scripts;',
        '- checkers;',
        '- batch runners;',
        '- mule handoff packets;',
        '- mule return packets;',
        '- prompts;',
        '- templates;',
        '- receipts;',
        '- TODO support files;',
        '- status/support files;',
        '- source packets;',
        '- downloadable artifacts;',
        '- event ledgers;',
        '- link maps;',
        '- soft suits;',
        '- any support surface that shapes action.',
        '',
        '## Tool Passport',
        '',
        'High-impact, reusable, durable, or house-touching tools need a passport before reuse, promotion, or broad trust.',
        '',
        'TOOL NAME:',
        'HOME:',
        'TYPE:',
        'TRIGGER:',
        'INPUTS:',
        'OUTPUTS:',
        'ALLOWED TOUCH:',
        'BLOCKED TOUCH:',
        'AUTHORITY BOUNDARY:',
        'PROOF NEEDED:',
        'SELF-CLEAN / ARCHIVE RULE:',
        'REPLACES:',
        'OVERLAPS:',
        'NEIGHBORS:',
        'STALE CONDITION:',
        'DECAY CONDITION:',
        'OWNER / JUDGE:',
        'LAST PROVED USE:',
        'EVENT TRACE HOOK:',
        'NEXT TEST:',
        '',
        '## Tool link map requirement',
        '',
        'A tool or support surface becomes haunted when it floats without links.',
        '',
        'Important tools must link to:',
        '',
        '- trigger;',
        '- home lane;',
        '- parent rule or concept;',
        '- sibling tools;',
        '- neighbor lanes;',
        '- proof receipt;',
        '- replacement or overlap relation;',
        '- stale state;',
        '- decay condition;',
        '- authority boundary;',
        '- event trace hook.',
        '',
        '## Tool nerve triggers',
        '',
        'Fire this rule when any of these appear:',
        '',
        '- tool has no trigger;',
        '- tool has no home;',
        '- tool has no proof;',
        '- tool touches too much;',
        '- tool leaves loose files;',
        '- tool overlaps another tool;',
        '- tool silently replaces another tool;',
        '- tool is reused outside original lane;',
        '- tool becomes authority;',
        '- tool has no stale/decay rule;',
        '- tool failed and no repair template exists;',
        '- generated helper breaks from syntax, quoting, path, or shell behavior;',
        '- support file starts steering without authority.',
        '',
        '## Immediate behavior',
        '',
        'If a tool is one-time and temporary, default is self-clean after successful proof.',
        '',
        'If a tool is useful and should be kept, route it into the correct house lane as a tool or tool-candidate with receipt/proof.',
        '',
        'If a tool is unsafe, stale, overlapping, or unproved, park, block, repair, or decay it. Do not keep reusing it because it worked once.',
        '',
        '## PowerShell helper safety minimum',
        '',
        'Generated PowerShell helpers for house-touching work must avoid known failure patterns.',
        '',
        'Minimum standards:',
        '',
        '- do not use giant paste blocks for large save work;',
        '- use file-based helper or small staged commands;',
        '- avoid Markdown backticks inside PowerShell strings;',
        '- avoid fragile here-strings unless truly needed;',
        '- prefer simple line arrays for generated text;',
        '- verify .git, branch, clean status before write;',
        '- stop on dirty state;',
        '- prove commit, push, HEAD equals origin/main, and clean status;',
        '- print a copy-back proof block;',
        '- self-clean if temporary and outside Mr.Kleen;',
        '- do not claim saved until proof is returned.',
        '',
        '## No Tool King',
        '',
        'No tool, helper, checker, prompt, mule packet, receipt, TODO, status file, source packet, event ledger, or link map becomes command authority by existing.',
        '',
        'Tools support the house. They do not rule the house.',
        '',
        '## Boundary',
        '',
        'This rule does not install doctrine.',
        'This rule does not rewrite ACTIVE_GUIDES.',
        'This rule does not rewrite CURRENT_TRUTH_INDEX.',
        'This rule does not create runtime, automation, dashboard, or permanent alarm feed.',
        '',
        '## Core sentence',
        '',
        'A tool is not safe because it works once. A tool is safe when its trigger, lane, proof, neighbors, cleanup, stale state, decay, and authority boundary are known.'
    ) | Set-Content -LiteralPath $Rule -Encoding UTF8

    @(
        '# Tool / Support Surface Haunting Failure Capture',
        '',
        'Date: 2026-05-21',
        'Lane: HOUSE_WORK / WORK_SHED / SORTING_BENCH',
        'Status: FAILURE CAPTURE / TOOL-SURFACE REPAIR',
        'Base before save: ' + $ShortBefore,
        '',
        '## What happened',
        '',
        'Recent work exposed that tools and support surfaces can fail even when the concept behind them is correct.',
        '',
        'Examples:',
        '',
        '- a temporary Desktop helper was left behind after proof;',
        '- a giant PowerShell paste entered continuation prompt;',
        '- a generated helper broke because Markdown backticks escaped PowerShell quotes;',
        '- a known file-based helper fix was found but not applied strongly enough at first;',
        '- mule handoffs needed active vs old separation;',
        '- support packets risk becoming command if not linked to trigger/lane/proof/boundary.',
        '',
        '## User correction',
        '',
        'The user judged that the tool issue is huge and said the tools NEED to work properly.',
        '',
        '## Root class',
        '',
        'TOOL-SURFACE CUSTODY FAILURE + LINK-MAP UNDERBUILD + FOUND-FIX APPLICATION GAP',
        '',
        '## Deeper problem',
        '',
        'Tools are where rules become action.',
        '',
        'If a tool lacks trigger, home, proof, authority boundary, cleanup, stale state, decay, and neighbor links, it can become haunted.',
        '',
        'A haunted tool may work once, then later be reused wrong, duplicated, bypassed, over-trusted, left loose, or treated as authority.',
        '',
        '## Corrected behavior',
        '',
        'High-impact and reusable tools need passports and link maps.',
        '',
        'One-time helpers must self-clean, route into the house, or be explicitly kept.',
        '',
        'Generated helpers need safer construction standards.',
        '',
        'The first poolrun should trace tool triggers, fires, dead nerves, late fires, misfires, cleanup, proof, stale state, and link-map gaps.',
        '',
        '## Boundary',
        '',
        'This capture does not install doctrine, runtime, dashboard, automation, ACTIVE_GUIDES, or CURRENT_TRUTH_INDEX changes.'
    ) | Set-Content -LiteralPath $Failure -Encoding UTF8

    @(
        '# TODO - Tool Passport Poolrun And Helper Template',
        '',
        'Date: 2026-05-21',
        'Lane: HOUSE_WORK / TODO',
        'Status: OPEN / HIGH PRIORITY / TOOL-SURFACE CUSTODY',
        'Base before save: ' + $ShortBefore,
        '',
        '## Mission',
        '',
        'Run a small controlled tool poolrun and design a reusable safer helper template.',
        '',
        'The goal is to discover which tools really fire correctly, which are haunted, which overlap, which should decay, and which need passports before reuse.',
        '',
        '## First poolrun targets',
        '',
        'Inspect these support surfaces first:',
        '',
        '1. PowerShell save helpers;',
        '2. temporary Desktop and 123 helpers;',
        '3. mule handoff packets;',
        '4. mule return packets;',
        '5. HNS Mesh packets;',
        '6. Rule Nervous System packets;',
        '7. checkers and batch runners;',
        '8. receipts used as proof surfaces;',
        '9. TODO/status/anchor support files;',
        '10. source packets that could start steering.',
        '',
        '## Tool poolrun event fields',
        '',
        'TOOL:',
        'TRIGGER EXPECTED:',
        'TRIGGER ACTUAL:',
        'FIRED:',
        'DID NOT FIRE:',
        'LATE FIRE:',
        'MISFIRE:',
        'OVERFIRE:',
        'INPUTS:',
        'OUTPUTS:',
        'ALLOWED TOUCH:',
        'BLOCKED TOUCH:',
        'PROOF:',
        'CLEANUP / ARCHIVE:',
        'LINK MAP:',
        'STALE CONDITION:',
        'DECAY CONDITION:',
        'FIX CANDIDATE:',
        'SAVE/LOCK NEEDED:',
        '',
        '## Helper template candidate',
        '',
        'Build a safer local helper template later with:',
        '',
        '- point-of-work readback;',
        '- .git/root/branch/clean checks;',
        '- no Markdown backticks inside PowerShell strings;',
        '- simple line arrays;',
        '- exact expected file paths;',
        '- staged-file verification;',
        '- receipt hash;',
        '- commit/push/fetch proof;',
        '- HEAD equals origin/main check;',
        '- final clean status;',
        '- copy-back proof block;',
        '- self-clean if temporary and outside Mr.Kleen;',
        '- no broad writes without explicit selected scope.',
        '',
        '## Blocked moves',
        '',
        'No dashboard.',
        'No runtime.',
        'No automation.',
        'No ACTIVE_GUIDES rewrite.',
        'No CURRENT_TRUTH_INDEX rewrite.',
        'No giant checker suite by default.',
        'No treating tool passport as authority.',
        '',
        '## Pass condition',
        '',
        'PASS when the first tool poolrun identifies tool trigger/fire behavior, haunted tools, overlap/replacement issues, cleanup gaps, and safe helper-template requirements without installing runtime/dashboard/automation.'
    ) | Set-Content -LiteralPath $Todo -Encoding UTF8

    Add-Content -LiteralPath $StatusFile -Encoding UTF8 -Value @(
        '',
        '---',
        '',
        '## Tool Surface Passport And Link Map Rule',
        '',
        'Status: ACTIVE BEHAVIOR RULE SAVED / TOOL POOLRUN TODO OPEN',
        'Date: 2026-05-21',
        'Base before save: ' + $ShortBefore,
        '',
        'Rule:',
        $Rule,
        '',
        'Failure capture:',
        $Failure,
        '',
        'TODO:',
        $Todo,
        '',
        'Meaning:',
        'Tools, helper scripts, checkers, prompts, mule packets, support files, source packets, and other support surfaces need trigger, lane, proof, neighbor links, replacement/overlap, cleanup/archive, stale state, decay, and authority boundary to avoid becoming haunted.',
        '',
        'Next:',
        'Run a small controlled tool poolrun later. Do not build dashboard/runtime/automation.',
        '',
        'Boundary:',
        'No doctrine, no ACTIVE_GUIDES rewrite, no CURRENT_TRUTH_INDEX rewrite, no runtime, no automation, no dashboard.'
    )

    @(
        '# ACTIVE ANCHOR',
        '',
        'Recorded base before this save:',
        'main @ ' + $ShortBefore,
        '',
        'Current active ball:',
        'Tool Surface Passport / Link Map rule saved; mule still working HNS Mesh; next safe work is tool poolrun or mule return intake when available.',
        '',
        'Next allowed move:',
        'Do not send new mule work by inertia. If tool work continues, run a small controlled tool poolrun or build a safer helper template candidate. If mule returns, intake/disposition mule output first.',
        '',
        'Blocked moves:',
        '- Do not install doctrine.',
        '- Do not rewrite ACTIVE_GUIDES.',
        '- Do not rewrite CURRENT_TRUTH_INDEX.',
        '- Do not build runtime, dashboard, automation, or permanent alarm feed.',
        '- Do not treat tool passports as authority.',
        '- Do not treat tools as safe because they worked once.',
        '- Do not leave temporary helpers loose.',
        '- Keep No Tool King.'
    ) | Set-Content -LiteralPath $AnchorFile -Encoding UTF8

    $RuleHash = (Get-FileHash -LiteralPath $Rule -Algorithm SHA256).Hash
    $FailureHash = (Get-FileHash -LiteralPath $Failure -Algorithm SHA256).Hash
    $TodoHash = (Get-FileHash -LiteralPath $Todo -Algorithm SHA256).Hash
    $StatusHash = (Get-FileHash -LiteralPath $StatusFile -Algorithm SHA256).Hash
    $AnchorHash = (Get-FileHash -LiteralPath $AnchorFile -Algorithm SHA256).Hash

    $ReceiptLines = @(
        'TOOL SURFACE PASSPORT RULE RECEIPT',
        'Date: ' + (Get-Date -Format o),
        '',
        'Base before save:',
        $HeadBefore,
        '',
        'Verdict:',
        'PASS AS TOOL-SURFACE CUSTODY RULE / TOOL POOLRUN TODO OPEN',
        '',
        'Rule:',
        $Rule,
        'SHA256:',
        $RuleHash,
        '',
        'Failure capture:',
        $Failure,
        'SHA256:',
        $FailureHash,
        '',
        'TODO:',
        $Todo,
        'SHA256:',
        $TodoHash,
        '',
        'Updated status:',
        $StatusFile,
        'SHA256:',
        $StatusHash,
        '',
        'Updated anchor:',
        $AnchorFile,
        'SHA256:',
        $AnchorHash,
        '',
        'Locked behavior:',
        'Tools and support surfaces need passports/link maps when high-impact, reusable, durable, or house-touching. One-time helpers must self-clean, route into the house, or be explicitly kept.',
        '',
        'Boundary:',
        'No doctrine rewrite.',
        'No ACTIVE_GUIDES rewrite.',
        'No CURRENT_TRUTH_INDEX rewrite.',
        'No runtime.',
        'No automation.',
        'No dashboard.',
        'No permanent alarm feed.',
        'No Tool King.',
        '',
        'Next:',
        'Run a small controlled tool poolrun later or intake mule return first if it arrives.'
    )

    $ReceiptLines | Set-Content -LiteralPath $Receipt -Encoding UTF8
    $ReceiptHash = (Get-FileHash -LiteralPath $Receipt -Algorithm SHA256).Hash

    $PathsToAdd = @($Rule, $Failure, $Todo, $StatusFile, $AnchorFile)
    git add -- @PathsToAdd
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

    git commit -m "Add tool surface passport rule"
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

    $CleanupMessages = @()
    $Helpers = @(Get-ChildItem -LiteralPath $Unit123 -File -Filter "RUN_TOOL_SURFACE_PASSPORT_RULE_SAVE*.ps1" -ErrorAction SilentlyContinue)
    foreach ($Helper in $Helpers) {
        try {
            Remove-Item -LiteralPath $Helper.FullName -Force
            $CleanupMessages += "REMOVED TEMP HELPER: $($Helper.FullName)"
        }
        catch {
            $CleanupMessages += "FAILED TEMP HELPER CLEANUP: $($Helper.FullName) :: $($_.Exception.Message)"
        }
    }

    if ($CleanupMessages.Count -eq 0) {
        $CleanupMessages += "NO TEMP HELPERS FOUND FOR CLEANUP"
    }

    Write-Host ""
    Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX" -ForegroundColor Green
    Write-Host "TOOL SURFACE PASSPORT RULE SAVE COMPLETE"
    Write-Host "Verdict: PASS AS TOOL-SURFACE CUSTODY RULE / TOOL POOLRUN TODO OPEN"
    Write-Host "Rule: $Rule"
    Write-Host "Rule SHA256: $RuleHash"
    Write-Host "Failure capture: $Failure"
    Write-Host "Failure capture SHA256: $FailureHash"
    Write-Host "TODO: $Todo"
    Write-Host "TODO SHA256: $TodoHash"
    Write-Host "Receipt: $Receipt"
    Write-Host "Receipt SHA256: $ReceiptHash"
    foreach ($Line in $CleanupMessages) {
        Write-Host "Temporary helper cleanup: $Line"
    }
    Write-Host "Commit: $ShortAfter"
    Write-Host "HEAD: $HeadAfter"
    Write-Host "origin/main: $OriginAfter"

    if ($StatusAfter.Count -gt 0) {
        Write-Host "Repo status after: NOT CLEAN"
        $StatusAfter | ForEach-Object { Write-Host $_ }
    } else {
        Write-Host "Repo status after: clean"
    }

    Write-Host "Next: tool poolrun or mule return intake. Boundary: no doctrine/ACTIVE_GUIDES/CURRENT_TRUTH_INDEX/runtime/automation/dashboard. No Tool King."
    Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX" -ForegroundColor Green
}