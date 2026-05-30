param(
    [Parameter(Mandatory=$true)][string]$CommandCenterPath,
    [Parameter(Mandatory=$true)][string]$JobId,
    [Parameter(Mandatory=$true)][string]$OutputPath
)

$ErrorActionPreference = "Stop"

$AllowedFiles = @(
    "README_START_HERE.md",
    "CURRENT_CONTEXT_CART.md",
    "NEXT_ON_THE_PLATE.md",
    "BLOCKED_MOVES.md",
    "ROOM_INDEX.md"
)

$Lines = New-Object System.Collections.Generic.List[string]
$Lines.Add("LEVEL2 APPROVED HELPER OUTPUT")
$Lines.Add("Helper: read_child_shell_status_summary")
$Lines.Add("Job ID: $JobId")
$Lines.Add("Date: $(Get-Date -Format o)")
$Lines.Add("Command Center: $CommandCenterPath")
$Lines.Add("")
$Lines.Add("Allowed read files:")

foreach ($Name in $AllowedFiles) {
    $Path = Join-Path $CommandCenterPath $Name
    if (Test-Path -LiteralPath $Path) {
        $Hash = (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
        $Raw = Get-Content -LiteralPath $Path -Raw
        $Length = $Raw.Length
        $Preview = $Raw
        if ($Preview.Length -gt 600) {
            $Preview = $Preview.Substring(0, 600) + "`n[TRUNCATED BY LEVEL2 HELPER]"
        }
        $Lines.Add("----- $Name -----")
        $Lines.Add("Path: $Path")
        $Lines.Add("SHA256: $Hash")
        $Lines.Add("Length: $Length")
        $Lines.Add("Preview:")
        $Lines.Add($Preview)
        $Lines.Add("")
    }
    else {
        $Lines.Add("----- $Name -----")
        $Lines.Add("Path: $Path")
        $Lines.Add("MISSING")
        $Lines.Add("")
    }
}

$Parent = Split-Path -Parent $OutputPath
if ($Parent -and -not (Test-Path -LiteralPath $Parent)) {
    New-Item -ItemType Directory -Force -Path $Parent | Out-Null
}

Set-Content -LiteralPath $OutputPath -Value ($Lines -join "`n") -Encoding UTF8

<!-- LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_REPAIR:D51D7E9684BC04D5 -->
## Living Object Registry V2 — First-Wave Bounded Repair Note

Status: SELECTED_FIRST_WAVE_REPAIR / NOT_DOCTRINE
WorkKey: LIVING-OBJECT-REGISTRY-V2-FIRST-WAVE-BOUNDED-REPAIR-20260530-V1
RunId: 20260530_150214

Object path: COMMAND_CENTER/CHILD_SHELL/HELPERS/HELPER_READ_CHILD_SHELL_STATUS_SUMMARY_LEVEL2.ps1
Species: HELPER_OBJECT
Owner room: UNKNOWN_OWNER_ROOM
Authority class: HELPER_SUPPORT_NOT_JUDGE
Repair field: ReturnPath
Failure family: ROOM WITHOUT RETURN
Suggested stitch: RETURN STITCH
Repair reason: Helper object should return with verdict/next condition.

Registry key tags:
- LIVING_OBJECT_REGISTRY_V2
- FIRST_WAVE_REPAIR
- HELPER_OBJECT
- ReturnPath

Ledger home: HOUSE_WORK/TODO/LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_BOUNDED_REPAIR_TICKETS_20260530.md
Map / route home: HOUSE_WORK/WORK_SHED/INDEXES/LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_REPAIR_ROUTE_INDEX_20260530.md
Proof pointer: PROOF_HISTORY/LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_BOUNDED_REPAIR_RECEIPT_20260530.txt
Return path: HOUSE_WORK/TODO/LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_BOUNDED_REPAIR_TICKETS_20260530.md
Currentness: CURRENT_SUPPORT_REPAIR_NOTE
Disposition: KEEP_WITH_OBJECT_UNTIL_REAUDIT

Allowed action:
- Repair only this named audit gap by adding contract/route/proof/return metadata.

Forbidden actions:
- Do not promote this object to doctrine.
- Do not treat this block as proof of full cleanliness.
- Do not repair unrelated gaps from this block.
- Do not delete or move this object.

Boundary:
- selected ticket path only
- no doctrine
- no ACTIVE_GUIDES
- no CURRENT_TRUTH_INDEX
- no broad refactor
- no delete
- no move
- no automation

## Helper assay fields

Task: Repair selected first-wave registry gap only.
Route tested: selected repair ticket -> target object -> route index -> receipt -> return TODO.
Source: first-wave selected repair plan.
Target: COMMAND_CENTER/CHILD_SHELL/HELPERS/HELPER_READ_CHILD_SHELL_STATUS_SUMMARY_LEVEL2.ps1
Relation: bounded registry repair / selected named gap.
Toolbelt: Living Object Contract; Helper Control Shell; Route Court; Policy Gate.
Proof/source pointer: PROOF_HISTORY/LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_BOUNDED_REPAIR_RECEIPT_20260530.txt
Return path: HOUSE_WORK/TODO/LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_BOUNDED_REPAIR_TICKETS_20260530.md
Verdict: HELPER_CONTRACT_REPAIRED_PENDING_REAUDIT
<!-- /LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_REPAIR:ReturnPath -->

<!-- LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_REPAIR:C3D1127617B40540 -->
## Living Object Registry V2 — First-Wave Bounded Repair Note

Status: SELECTED_FIRST_WAVE_REPAIR / NOT_DOCTRINE
WorkKey: LIVING-OBJECT-REGISTRY-V2-FIRST-WAVE-BOUNDED-REPAIR-20260530-V1
RunId: 20260530_150214

Object path: COMMAND_CENTER/CHILD_SHELL/HELPERS/HELPER_READ_CHILD_SHELL_STATUS_SUMMARY_LEVEL2.ps1
Species: HELPER_OBJECT
Owner room: UNKNOWN_OWNER_ROOM
Authority class: HELPER_SUPPORT_NOT_JUDGE
Repair field: RouteEvidence
Failure family: HELPER WITHOUT ASSAY
Suggested stitch: HELPER STITCH
Repair reason: Helper object should include route evidence fields.

Registry key tags:
- LIVING_OBJECT_REGISTRY_V2
- FIRST_WAVE_REPAIR
- HELPER_OBJECT
- RouteEvidence

Ledger home: HOUSE_WORK/TODO/LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_BOUNDED_REPAIR_TICKETS_20260530.md
Map / route home: HOUSE_WORK/WORK_SHED/INDEXES/LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_REPAIR_ROUTE_INDEX_20260530.md
Proof pointer: PROOF_HISTORY/LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_BOUNDED_REPAIR_RECEIPT_20260530.txt
Return path: HOUSE_WORK/TODO/LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_BOUNDED_REPAIR_TICKETS_20260530.md
Currentness: CURRENT_SUPPORT_REPAIR_NOTE
Disposition: KEEP_WITH_OBJECT_UNTIL_REAUDIT

Allowed action:
- Repair only this named audit gap by adding contract/route/proof/return metadata.

Forbidden actions:
- Do not promote this object to doctrine.
- Do not treat this block as proof of full cleanliness.
- Do not repair unrelated gaps from this block.
- Do not delete or move this object.

Boundary:
- selected ticket path only
- no doctrine
- no ACTIVE_GUIDES
- no CURRENT_TRUTH_INDEX
- no broad refactor
- no delete
- no move
- no automation

## Helper assay fields

Task: Repair selected first-wave registry gap only.
Route tested: selected repair ticket -> target object -> route index -> receipt -> return TODO.
Source: first-wave selected repair plan.
Target: COMMAND_CENTER/CHILD_SHELL/HELPERS/HELPER_READ_CHILD_SHELL_STATUS_SUMMARY_LEVEL2.ps1
Relation: bounded registry repair / selected named gap.
Toolbelt: Living Object Contract; Helper Control Shell; Route Court; Policy Gate.
Proof/source pointer: PROOF_HISTORY/LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_BOUNDED_REPAIR_RECEIPT_20260530.txt
Return path: HOUSE_WORK/TODO/LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_BOUNDED_REPAIR_TICKETS_20260530.md
Verdict: HELPER_CONTRACT_REPAIRED_PENDING_REAUDIT
<!-- /LIVING_OBJECT_REGISTRY_V2_FIRST_WAVE_REPAIR:RouteEvidence -->
