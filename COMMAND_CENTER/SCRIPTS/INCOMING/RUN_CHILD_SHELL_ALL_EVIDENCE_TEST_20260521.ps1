& {
    $ErrorActionPreference = "Stop"

    $Bridge = "$env:USERPROFILE\Desktop\123\TOOLS\LOCAL_HARD_BRIDGE_V1"
    $Requests = Join-Path $Bridge "HUB\REQUESTS"
    $Responses = Join-Path $Bridge "HUB\RESPONSES"
    $Receipts = Join-Path $Bridge "HUB\RECEIPTS"
    $Outbox = Join-Path $Bridge "HUB\OUTBOX_TO_CHAT"
    $Workspace = Join-Path $Bridge "WORKSPACE"
    $RunOnce = Join-Path $Bridge "TOOLS\RUN_BRIDGE_ONCE.ps1"
    $Policy = Join-Path $Bridge "CONFIG\POLICY.json"
    $Stamp = Get-Date -Format "yyyyMMdd_HHmmss"

    function Add-Line {
        param(
            [System.Collections.Generic.List[string]]$Lines,
            [string]$Text = ""
        )
        $Lines.Add($Text) | Out-Null
    }

    function Write-JsonFile {
        param(
            [string]$Path,
            [object]$Obj
        )
        $Obj | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $Path -Encoding UTF8
    }

    function Read-Response {
        param([string]$Id)

        $Path = Join-Path $Responses ($Id + "_RESPONSE.json")

        if (-not (Test-Path -LiteralPath $Path)) {
            return [pscustomobject]@{
                Id = $Id
                Path = $Path
                Exists = $false
                Hash = ""
                Json = $null
                Raw = ""
            }
        }

        $Raw = Get-Content -LiteralPath $Path -Raw
        $Json = $Raw | ConvertFrom-Json

        return [pscustomobject]@{
            Id = $Id
            Path = $Path
            Exists = $true
            Hash = (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
            Json = $Json
            Raw = $Raw
        }
    }

    function Read-Receipt {
        param([string]$Id)

        $Path = Join-Path $Receipts ($Id + "_RECEIPT.txt")

        if (-not (Test-Path -LiteralPath $Path)) {
            return [pscustomobject]@{
                Id = $Id
                Path = $Path
                Exists = $false
                Hash = ""
                Text = ""
            }
        }

        $Text = Get-Content -LiteralPath $Path -Raw

        return [pscustomobject]@{
            Id = $Id
            Path = $Path
            Exists = $true
            Hash = (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
            Text = $Text
        }
    }

    function Verdict-Line {
        param(
            [string]$Name,
            [bool]$Passed,
            [string]$Detail
        )

        if ($Passed) {
            return "PASS | $Name | $Detail"
        }

        return "FAIL | $Name | $Detail"
    }

    Write-Host "POINT OF WORK READBACK"
    Write-Host "Task: Run full Child Shell evidence test only."
    Write-Host "Boundary: local-only bridge test. No Mr.Kleen save. No doctrine. No bridge permission expansion. No house write. No git commit/push."
    Write-Host ""

    if (-not (Test-Path -LiteralPath $RunOnce)) {
        throw "STOP. RUN_BRIDGE_ONCE.ps1 missing: $RunOnce"
    }

    if (-not (Test-Path -LiteralPath $Policy)) {
        throw "STOP. POLICY.json missing: $Policy"
    }

    New-Item -ItemType Directory -Force -Path $Requests, $Responses, $Receipts, $Outbox, $Workspace | Out-Null

    $ExistingRequests = @(Get-ChildItem -LiteralPath $Requests -File -Filter "*.json" -ErrorAction SilentlyContinue)

    if ($ExistingRequests.Count -gt 0) {
        Write-Host "Existing request files found in bridge request queue:"
        $ExistingRequests | ForEach-Object { Write-Host $_.FullName }
        throw "STOP. Request queue must be empty before the ordered all-evidence test. Move or process existing requests first."
    }

    $Target = "CHILD_SHELL_EVIDENCE\ordered_child_shell_$Stamp.md"
    $TraversalTarget = "..\CHILD_SHELL_SHOULD_NOT_WRITE_$Stamp.md"
    $BlockedExtTarget = "CHILD_SHELL_EVIDENCE\blocked_script_$Stamp.ps1"

    $Reqs = @(
        [ordered]@{
            id = "REQ_CHILD_EVIDENCE_${Stamp}_01_FRONT_DOOR"
            action = "house_front_door"
        },
        [ordered]@{
            id = "REQ_CHILD_EVIDENCE_${Stamp}_02_WRITE_NEW_TEXT"
            action = "write_new_text"
            target = $Target
            content = "Ordered Child Shell evidence test. This file was written through write_new_text only."
        },
        [ordered]@{
            id = "REQ_CHILD_EVIDENCE_${Stamp}_03_OVERWRITE_BLOCK"
            action = "write_new_text"
            target = $Target
            content = "This must not overwrite the previous file."
        },
        [ordered]@{
            id = "REQ_CHILD_EVIDENCE_${Stamp}_04_RAW_SHELL_BLOCK"
            action = "shell"
            command = "Write-Host should-not-run"
        },
        [ordered]@{
            id = "REQ_CHILD_EVIDENCE_${Stamp}_05_PATH_TRAVERSAL_BLOCK"
            action = "write_new_text"
            target = $TraversalTarget
            content = "This must not write outside WORKSPACE."
        },
        [ordered]@{
            id = "REQ_CHILD_EVIDENCE_${Stamp}_06_BLOCKED_EXTENSION"
            action = "write_new_text"
            target = $BlockedExtTarget
            content = "Write-Host 'This ps1 file must not be created'"
        },
        [ordered]@{
            id = "REQ_CHILD_EVIDENCE_${Stamp}_07_HOUSE_READ_ANCHOR"
            action = "house_read_text"
            target = "ACTIVE_ANCHOR.txt"
        },
        [ordered]@{
            id = "REQ_CHILD_EVIDENCE_${Stamp}_08_HOUSE_HASH_ANCHOR"
            action = "house_hash"
            target = "ACTIVE_ANCHOR.txt"
        },
        [ordered]@{
            id = "REQ_CHILD_EVIDENCE_${Stamp}_09_FINAL_FRONT_DOOR"
            action = "house_front_door"
        }
    )

    foreach ($Req in $Reqs) {
        $Path = Join-Path $Requests ($Req.id + ".json")
        Write-JsonFile -Path $Path -Obj $Req
    }

    & $RunOnce -BridgeRoot $Bridge

    $Results = @{}
    $ReceiptResults = @{}

    foreach ($Req in $Reqs) {
        $Results[$Req.id] = Read-Response $Req.id
        $ReceiptResults[$Req.id] = Read-Receipt $Req.id
    }

    $Front1 = $Results[$Reqs[0].id].Json
    $Write = $Results[$Reqs[1].id].Json
    $Overwrite = $Results[$Reqs[2].id].Json
    $Shell = $Results[$Reqs[3].id].Json
    $Traversal = $Results[$Reqs[4].id].Json
    $BlockedExt = $Results[$Reqs[5].id].Json
    $HouseRead = $Results[$Reqs[6].id].Json
    $HouseHash = $Results[$Reqs[7].id].Json
    $Front2 = $Results[$Reqs[8].id].Json

    $TargetFull = Join-Path $Workspace $Target
    $BlockedExtFull = Join-Path $Workspace $BlockedExtTarget
    $TraversalFull = [System.IO.Path]::GetFullPath((Join-Path $Workspace $TraversalTarget))

    $TargetExists = Test-Path -LiteralPath $TargetFull
    $BlockedExtExists = Test-Path -LiteralPath $BlockedExtFull
    $TraversalExists = Test-Path -LiteralPath $TraversalFull

    $TargetHash = ""
    if ($TargetExists) {
        $TargetHash = (Get-FileHash -LiteralPath $TargetFull -Algorithm SHA256).Hash
    }

    $RunOnceHash = (Get-FileHash -LiteralPath $RunOnce -Algorithm SHA256).Hash
    $PolicyHash = (Get-FileHash -LiteralPath $Policy -Algorithm SHA256).Hash

    $Front1Pass = ($null -ne $Front1 -and $Front1.ok -eq $true -and $Front1.clean -eq $true -and $Front1.head -eq $Front1.origin_main)
    $WritePass = ($null -ne $Write -and $Write.ok -eq $true -and $TargetExists)
    $OverwritePass = ($null -ne $Overwrite -and $Overwrite.ok -eq $false -and "$($Overwrite.error)" -match "Overwrite|already exists|blocked")
    $ShellPass = ($null -ne $Shell -and $Shell.ok -eq $false -and "$($Shell.error)" -match "Blocked|unknown|disallowed")
    $TraversalPass = ($null -ne $Traversal -and $Traversal.ok -eq $false -and -not $TraversalExists)
    $BlockedExtPass = ($null -ne $BlockedExt -and $BlockedExt.ok -eq $false -and -not $BlockedExtExists)
    $HouseReadPass = ($null -ne $HouseRead -and $HouseRead.ok -eq $true -and "$($HouseRead.sha256)".Length -gt 0)
    $HouseHashPass = ($null -ne $HouseHash -and $HouseHash.ok -eq $true -and "$($HouseHash.sha256)".Length -gt 0)
    $Front2Pass = ($null -ne $Front2 -and $Front2.ok -eq $true -and $Front2.clean -eq $true -and $Front2.head -eq $Front2.origin_main)

    $Checks = New-Object System.Collections.Generic.List[string]
    $Checks.Add((Verdict-Line "initial front door clean/head-origin match" $Front1Pass "clean=$($Front1.clean) head=$($Front1.head) origin=$($Front1.origin_main)")) | Out-Null
    $Checks.Add((Verdict-Line "ordered write_new_text inside workspace" $WritePass "ok=$($Write.ok) target=$($Write.target) targetExists=$TargetExists targetHash=$TargetHash")) | Out-Null
    $Checks.Add((Verdict-Line "overwrite blocked" $OverwritePass "ok=$($Overwrite.ok) error=$($Overwrite.error)")) | Out-Null
    $Checks.Add((Verdict-Line "raw shell blocked" $ShellPass "ok=$($Shell.ok) error=$($Shell.error)")) | Out-Null
    $Checks.Add((Verdict-Line "path traversal blocked" $TraversalPass "ok=$($Traversal.ok) error=$($Traversal.error) traversalExists=$TraversalExists")) | Out-Null
    $Checks.Add((Verdict-Line "blocked extension write" $BlockedExtPass "ok=$($BlockedExt.ok) error=$($BlockedExt.error) blockedExtExists=$BlockedExtExists")) | Out-Null
    $Checks.Add((Verdict-Line "house read-only anchor" $HouseReadPass "ok=$($HouseRead.ok) sha256=$($HouseRead.sha256)")) | Out-Null
    $Checks.Add((Verdict-Line "house hash anchor" $HouseHashPass "ok=$($HouseHash.ok) sha256=$($HouseHash.sha256)")) | Out-Null
    $Checks.Add((Verdict-Line "final front door clean/head-origin match" $Front2Pass "clean=$($Front2.clean) head=$($Front2.head) origin=$($Front2.origin_main)")) | Out-Null

    $AllPass = $Front1Pass -and $WritePass -and $OverwritePass -and $ShellPass -and $TraversalPass -and $BlockedExtPass -and $HouseReadPass -and $HouseHashPass -and $Front2Pass

    if ($AllPass) {
        $Verdict = "PASS"
    } else {
        $Verdict = "FAIL / REVIEW REQUIRED"
    }

    $Report = Join-Path $Outbox "CHILD_SHELL_ALL_EVIDENCE_TEST_READBACK_$Stamp.txt"

    $Lines = New-Object System.Collections.Generic.List[string]
    Add-Line $Lines "CHILD SHELL ALL EVIDENCE TEST READBACK"
    Add-Line $Lines "Date: $(Get-Date -Format o)"
    Add-Line $Lines "Bridge: $Bridge"
    Add-Line $Lines "RunOnce: $RunOnce"
    Add-Line $Lines "RunOnce SHA256: $RunOnceHash"
    Add-Line $Lines "Policy: $Policy"
    Add-Line $Lines "Policy SHA256: $PolicyHash"
    Add-Line $Lines "Verdict: $Verdict"
    Add-Line $Lines ""
    Add-Line $Lines "PACKET ORDER"
    Add-Line $Lines "01_FORMULA: AI request -> policy gate -> child action -> local function -> response + receipt"
    Add-Line $Lines "02_ALLOWED_PROOF: ordered write_new_text created one file inside WORKSPACE"
    Add-Line $Lines "03_HARDSTOP_PROOF: overwrite, raw shell, path traversal, and blocked extension tests"
    Add-Line $Lines "04_READ_ONLY_PROOF: house read/hash without house write"
    Add-Line $Lines "05_STATE_PROOF: front door clean before and after"
    Add-Line $Lines "06_PACKING_NOTE: redact private local paths before external project packet"
    Add-Line $Lines ""
    Add-Line $Lines "CHECKS"
    foreach ($Check in $Checks) {
        Add-Line $Lines $Check
    }
    Add-Line $Lines ""
    Add-Line $Lines "CREATED TARGET"
    Add-Line $Lines "Target relative: $Target"
    Add-Line $Lines "Target full: $TargetFull"
    Add-Line $Lines "Target exists: $TargetExists"
    Add-Line $Lines "Target SHA256: $TargetHash"
    Add-Line $Lines ""
    Add-Line $Lines "BLOCKED TARGETS"
    Add-Line $Lines "Traversal relative: $TraversalTarget"
    Add-Line $Lines "Traversal resolved path: $TraversalFull"
    Add-Line $Lines "Traversal exists: $TraversalExists"
    Add-Line $Lines "Blocked extension relative: $BlockedExtTarget"
    Add-Line $Lines "Blocked extension full: $BlockedExtFull"
    Add-Line $Lines "Blocked extension exists: $BlockedExtExists"
    Add-Line $Lines ""
    Add-Line $Lines "PUBLIC-PACKET CLEANUP NOTE"
    Add-Line $Lines "For any outside-facing concept/proof packet, keep the formula, test verdicts, hashes, and safety implications. Redact direct user paths, private repo names if desired, and internal house doctrine not needed for the public concept."
    Add-Line $Lines ""

    foreach ($Req in $Reqs) {
        $R = $Results[$Req.id]
        $Rc = $ReceiptResults[$Req.id]

        Add-Line $Lines "===== RESPONSE $($Req.id) ====="
        Add-Line $Lines "Path: $($R.Path)"
        Add-Line $Lines "Exists: $($R.Exists)"
        Add-Line $Lines "SHA256: $($R.Hash)"
        Add-Line $Lines $R.Raw
        Add-Line $Lines "===== RECEIPT $($Req.id) ====="
        Add-Line $Lines "Path: $($Rc.Path)"
        Add-Line $Lines "Exists: $($Rc.Exists)"
        Add-Line $Lines "SHA256: $($Rc.Hash)"
        Add-Line $Lines $Rc.Text
        Add-Line $Lines ""
    }

    $Lines | Set-Content -LiteralPath $Report -Encoding UTF8
    $ReportHash = (Get-FileHash -LiteralPath $Report -Algorithm SHA256).Hash

    Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX" -ForegroundColor Green
    Write-Host "CHILD SHELL ALL EVIDENCE TEST COMPLETE"
    Write-Host "Verdict: $Verdict"
    Write-Host "Bridge: $Bridge"
    Write-Host "RunOnce SHA256: $RunOnceHash"
    Write-Host "Policy SHA256: $PolicyHash"
    Write-Host "Initial front door: clean=$($Front1.clean) head=$($Front1.head) origin=$($Front1.origin_main)"
    Write-Host "Write new text: ok=$($Write.ok) target=$($Write.target) sha256=$($Write.sha256)"
    Write-Host "Overwrite block: ok=$($Overwrite.ok) error=$($Overwrite.error)"
    Write-Host "Raw shell block: ok=$($Shell.ok) error=$($Shell.error)"
    Write-Host "Path traversal block: ok=$($Traversal.ok) error=$($Traversal.error) exists=$TraversalExists"
    Write-Host "Blocked extension: ok=$($BlockedExt.ok) error=$($BlockedExt.error) exists=$BlockedExtExists"
    Write-Host "House read anchor: ok=$($HouseRead.ok) sha256=$($HouseRead.sha256)"
    Write-Host "House hash anchor: ok=$($HouseHash.ok) sha256=$($HouseHash.sha256)"
    Write-Host "Final front door: clean=$($Front2.clean) head=$($Front2.head) origin=$($Front2.origin_main)"
    Write-Host "Created target: $TargetFull"
    Write-Host "Created target SHA256: $TargetHash"
    Write-Host "Evidence report: $Report"
    Write-Host "Evidence report SHA256: $ReportHash"
    Write-Host "Checks:"
    foreach ($Check in $Checks) {
        Write-Host $Check
    }
    Write-Host "Boundary: local-only bridge; no arbitrary shell; no delete; no overwrite; no path traversal; no blocked extension write; no house write; no git commit/push; no network service."
    Write-Host "Packet note: evidence is ordered for later concept/formula/proof packing; redact private local paths before outside-facing use."
    Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX" -ForegroundColor Green

    if (-not $AllPass) {
        throw "STOP. One or more Child Shell all-evidence checks failed. Review the green block and evidence report before saving or packing."
    }
}