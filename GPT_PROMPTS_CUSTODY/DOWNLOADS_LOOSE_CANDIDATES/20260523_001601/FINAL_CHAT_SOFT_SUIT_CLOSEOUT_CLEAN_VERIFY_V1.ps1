$ErrorActionPreference = "Stop"

$Root = Join-Path $env:USERPROFILE "Desktop\GPT_Prompts"
$Current = Join-Path $Root "CURRENT"
$Ready = Join-Path $Root "READY_TO_DROP_IN_CHAT"
$Custody = Join-Path $env:USERPROFILE "Desktop\123\GPT_PROMPTS_CUSTODY"
$ReceiptDir = Join-Path $Custody "RECEIPTS"
$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"

$Expected = @{
    "CHAT_SOFT_SUIT_MAP.md" = "EB9215434C3773CC7F8ED40481C036055CDC30CCE7DEF328E32293FDF27A3F4F"
    "CHAT_SOFT_SUIT_IDEA_LEDGER.md" = "ABCE510EBB2A39FBDC42A89D6E7DB60435F7DFB2E993ECF5BDDEF3D11B50DE23"
}

if (!(Test-Path -LiteralPath $Root)) { throw "Missing GPT_Prompts root: $Root" }
if (!(Test-Path -LiteralPath $Current)) { throw "Missing CURRENT: $Current" }

New-Item -ItemType Directory -Path $ReceiptDir -Force | Out-Null

$ActiveRows = @()
$BadActive = @()

foreach ($Name in $Expected.Keys) {
    $Path = Join-Path $Current $Name
    $Exists = Test-Path -LiteralPath $Path
    $Hash = ""
    $Match = $false

    if ($Exists) {
        $Hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash
        $Match = ($Hash -eq $Expected[$Name])
    }

    $Row = [pscustomobject]@{
        File = $Name
        ExistsInCurrent = $Exists
        HashMatchesExpected = $Match
        SHA256 = $Hash
    }
    $ActiveRows += $Row
    if (!$Match) { $BadActive += $Row }
}

if ($BadActive.Count -gt 0) {
    $Receipt = Join-Path $ReceiptDir "CHAT_SOFT_SUIT_FINAL_CLOSEOUT_BLOCKED_$Stamp.txt"
    @(
        "CHAT SOFT SUIT FINAL CLOSEOUT - BLOCKED",
        "Timestamp: $Stamp",
        "Reason: active CURRENT files do not match expected corrected hashes. No cleanup was performed.",
        "",
        ($ActiveRows | Format-Table -Auto | Out-String).TrimEnd(),
        "",
        "Boundary: read/verify only after mismatch; no CURRENT write; no custody move.",
        "Verdict: BLOCKED / CURRENT IS NOT THE EXPECTED CORRECTED MAIL"
    ) | Set-Content -LiteralPath $Receipt -Encoding UTF8
    Get-Content -LiteralPath $Receipt -Raw
    exit 1
}

$RootKeep = @("CURRENT","READY_TO_DROP_IN_CHAT","desktop.ini")
$MovedRoot = @()
$MovedCurrentDebris = @()
$MovedReadyConsumed = @()

# 1. Clean front-door/root clutter to custody.
$RootClutter = @(Get-ChildItem -LiteralPath $Root -Force -ErrorAction SilentlyContinue | Where-Object { $_.Name -notin $RootKeep })
if ($RootClutter.Count -gt 0) {
    $Dest = Join-Path $Custody "FRONT_DOOR_CLEANOUTS\FINAL_CLOSEOUT_ROOT_$Stamp"
    New-Item -ItemType Directory -Path $Dest -Force | Out-Null
    foreach ($Item in $RootClutter) {
        Move-Item -LiteralPath $Item.FullName -Destination $Dest -Force
        $MovedRoot += $Item.Name
    }
}

# 2. Clean old scaffold/helper debris out of CURRENT without touching active map/ledger.
$CurrentDebris = @(Get-ChildItem -LiteralPath $Current -File -Force -ErrorAction SilentlyContinue | Where-Object {
    $_.Name -eq "MANIFEST.md" -or
    $_.Name -match "^(00|01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16)_" -or
    $_.Name -like "*.ps1" -or
    ($_.Name -notin @("CHAT_SOFT_SUIT_MAP.md","CHAT_SOFT_SUIT_IDEA_LEDGER.md") -and $_.Name -notlike "desktop.ini")
})
if ($CurrentDebris.Count -gt 0) {
    $Dest = Join-Path $Custody "CURRENT_DEBRIS_CLEANOUTS\FINAL_CLOSEOUT_CURRENT_DEBRIS_$Stamp"
    New-Item -ItemType Directory -Path $Dest -Force | Out-Null
    foreach ($Item in $CurrentDebris) {
        Move-Item -LiteralPath $Item.FullName -Destination $Dest -Force
        $MovedCurrentDebris += $Item.Name
    }
}

# 3. If READY has identical copies of already-current active files, consume them to custody.
if (Test-Path -LiteralPath $Ready) {
    $Dest = Join-Path $Custody "READY_CONSUMED_AFTER_CURRENT_VERIFY\READY_CONSUMED_$Stamp"
    $NeedDest = $false

    foreach ($Name in $Expected.Keys) {
        $ReadyPath = Join-Path $Ready $Name
        $CurrentPath = Join-Path $Current $Name
        if ((Test-Path -LiteralPath $ReadyPath) -and (Test-Path -LiteralPath $CurrentPath)) {
            $ReadyHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ReadyPath).Hash
            $CurrentHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $CurrentPath).Hash
            if ($ReadyHash -eq $CurrentHash -and $CurrentHash -eq $Expected[$Name]) {
                if (!$NeedDest) {
                    New-Item -ItemType Directory -Path $Dest -Force | Out-Null
                    $NeedDest = $true
                }
                Move-Item -LiteralPath $ReadyPath -Destination $Dest -Force
                $MovedReadyConsumed += $Name
            }
        }
    }
}

# 4. Final verification.
$FinalActiveRows = @()
foreach ($Name in $Expected.Keys) {
    $Path = Join-Path $Current $Name
    $Exists = Test-Path -LiteralPath $Path
    $Hash = ""
    $Match = $false
    if ($Exists) {
        $Hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash
        $Match = ($Hash -eq $Expected[$Name])
    }
    $FinalActiveRows += [pscustomobject]@{
        File = $Name
        ExistsInCurrent = $Exists
        HashMatchesExpected = $Match
        SHA256 = $Hash
    }
}

$UnexpectedRoot = @(Get-ChildItem -LiteralPath $Root -Force -ErrorAction SilentlyContinue | Where-Object { $_.Name -notin $RootKeep })

$OldCurrent = @(Get-ChildItem -LiteralPath $Current -File -Force -ErrorAction SilentlyContinue | Where-Object {
    $_.Name -eq "MANIFEST.md" -or
    $_.Name -match "^(00|01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16)_" -or
    $_.Name -like "*.ps1"
})

$ReadyWaiting = @()
if (Test-Path -LiteralPath $Ready) {
    $ReadyWaiting = @(Get-ChildItem -LiteralPath $Ready -File -Force -ErrorAction SilentlyContinue | Where-Object {
        $_.Name -in @("CHAT_SOFT_SUIT_MAP.md","CHAT_SOFT_SUIT_IDEA_LEDGER.md")
    })
}

$BadFinal = @($FinalActiveRows | Where-Object { -not $_.HashMatchesExpected })
$Pass = ($BadFinal.Count -eq 0 -and $UnexpectedRoot.Count -eq 0 -and $OldCurrent.Count -eq 0 -and $ReadyWaiting.Count -eq 0)

$Receipt = Join-Path $ReceiptDir "CHAT_SOFT_SUIT_FINAL_CLOSEOUT_CLEAN_VERIFY_$Stamp.txt"

@(
"CHAT SOFT SUIT FINAL CLOSEOUT CLEAN VERIFY",
"Timestamp: $Stamp",
"Root: $Root",
"Current: $Current",
"Ready: $Ready",
"",
"Active CURRENT expected hashes:",
($FinalActiveRows | Format-Table -Auto | Out-String).TrimEnd(),
"",
"Moved root/front-door clutter count: $($MovedRoot.Count)",
($MovedRoot -join [Environment]::NewLine),
"",
"Moved CURRENT debris count: $($MovedCurrentDebris.Count)",
($MovedCurrentDebris -join [Environment]::NewLine),
"",
"Consumed READY duplicate active files count: $($MovedReadyConsumed.Count)",
($MovedReadyConsumed -join [Environment]::NewLine),
"",
"Unexpected root items remaining: $($UnexpectedRoot.Count)",
($UnexpectedRoot | Select-Object Name,FullName | Format-Table -Auto | Out-String).TrimEnd(),
"",
"Old scaffold/helper files remaining in CURRENT root: $($OldCurrent.Count)",
($OldCurrent | Select-Object Name,FullName | Format-Table -Auto | Out-String).TrimEnd(),
"",
"Active files still waiting in READY: $($ReadyWaiting.Count)",
($ReadyWaiting | Select-Object Name,FullName | Format-Table -Auto | Out-String).TrimEnd(),
"",
"Boundary: local-only; no Git; no public export; no doctrine promotion; no active CURRENT map/ledger write; clutter moved to custody only.",
"Verdict: $(if($Pass){"PASS / CHAT SOFT SUIT CLOSED CLEAN"}else{"REVIEW / CHAT SOFT SUIT STILL HAS LOOSE EDGES"})"
) | Set-Content -LiteralPath $Receipt -Encoding UTF8

Get-Content -LiteralPath $Receipt -Raw
