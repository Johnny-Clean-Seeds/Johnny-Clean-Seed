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

New-Item -ItemType Directory -Path $ReceiptDir -Force | Out-Null

$Rows = @()
foreach ($Name in $Expected.Keys) {
    $Path = Join-Path $Current $Name
    $Exists = Test-Path -LiteralPath $Path
    $Hash = ""
    $Match = $false
    if ($Exists) {
        $Hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash
        $Match = ($Hash -eq $Expected[$Name])
    }
    $Rows += [pscustomobject]@{
        File = $Name
        ExistsInCurrent = $Exists
        HashMatchesExpected = $Match
        SHA256 = $Hash
    }
}

$OldCurrent = @(Get-ChildItem -LiteralPath $Current -File -Force -ErrorAction SilentlyContinue | Where-Object {
    $_.Name -eq "MANIFEST.md" -or $_.Name -match "^(00|01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16)_"
})

$RootKeep = @("CURRENT","READY_TO_DROP_IN_CHAT","desktop.ini")
$UnexpectedRoot = @(Get-ChildItem -LiteralPath $Root -Force -ErrorAction SilentlyContinue | Where-Object { $_.Name -notin $RootKeep })

$BadHash = @($Rows | Where-Object { -not $_.HashMatchesExpected })
$Pass = ($OldCurrent.Count -eq 0 -and $UnexpectedRoot.Count -eq 0 -and $BadHash.Count -eq 0)

$Receipt = Join-Path $ReceiptDir "CHAT_SOFT_SUIT_CURRENT_AUTHORITY_VERIFY_$Stamp.txt"

@(
"CHAT SOFT SUIT CURRENT AUTHORITY VERIFY",
"Timestamp: $Stamp",
"Root: $Root",
"Current: $Current",
"Ready: $Ready",
"",
"Active current check:",
($Rows | Format-Table -Auto | Out-String).TrimEnd(),
"",
"Old scaffold files remaining in CURRENT root: $($OldCurrent.Count)",
($OldCurrent | Select-Object Name,FullName | Format-Table -Auto | Out-String).TrimEnd(),
"",
"Unexpected root items remaining: $($UnexpectedRoot.Count)",
($UnexpectedRoot | Select-Object Name,FullName | Format-Table -Auto | Out-String).TrimEnd(),
"",
"Boundary: read-only verification of CURRENT; no CURRENT write; no Git; no public export; no doctrine promotion.",
"Verdict: $(if($Pass){"PASS / CURRENT IS USER-MOVED AND VERIFIED CURRENT"}else{"REVIEW / CURRENT IS NOT VERIFIED CURRENT"})"
) | Set-Content -LiteralPath $Receipt -Encoding UTF8

Get-Content -LiteralPath $Receipt -Raw
