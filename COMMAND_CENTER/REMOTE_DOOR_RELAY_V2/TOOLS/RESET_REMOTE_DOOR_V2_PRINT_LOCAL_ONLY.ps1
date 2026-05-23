[CmdletBinding()]
param(
    [int]$CurrentMinutes = 120,
    [int]$NextMinutes = 120,
    [switch]$DryRun,
    [switch]$RotateSecret,
    [string]$V2Root = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = "Stop"

if ($CurrentMinutes -lt -1440 -or $CurrentMinutes -gt 10080) {
    throw "CurrentMinutes must be between -1440 and 10080."
}
if ($NextMinutes -lt 5 -or $NextMinutes -gt 10080) {
    throw "NextMinutes must be between 5 and 10080."
}

$Vault = Join-Path $V2Root "PRINT_VAULT_LOCAL_ONLY"
$CheckpointDir = Join-Path $Vault "PRINT_CHECKPOINTS"
$RecoveryDir = Join-Path $Vault "RECOVERY_LOCAL_ONLY"
$CurrentPath = Join-Path $Vault "CURRENT_PRINT.json"
$NextPath = Join-Path $Vault "NEXT_PRINT.json"
$LedgerPath = Join-Path $Vault "PRINT_LEDGER.jsonl"
$SecretPath = Join-Path $Vault "LOCAL_SECRET.key"
$StatePath = Join-Path $V2Root "RUNS\current_server_state.json"
$TokenStatePath = Join-Path $V2Root "TOKENS_LOCAL_ONLY\token_state.json"

New-Item -ItemType Directory -Force -Path $Vault, $CheckpointDir, $RecoveryDir | Out-Null

function ConvertTo-Hex {
    param([byte[]]$Bytes)
    return -join ($Bytes | ForEach-Object { $_.ToString("X2") })
}

function New-RandomBytes {
    param([int]$Length)
    $Bytes = New-Object byte[] $Length
    $Rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
    try {
        $Rng.GetBytes($Bytes)
    }
    finally {
        $Rng.Dispose()
    }
    return $Bytes
}

function ConvertFrom-Hex {
    param([string]$Hex)
    if ($Hex -notmatch '^[A-Fa-f0-9]+$' -or ($Hex.Length % 2) -ne 0) {
        throw "Invalid hex value."
    }
    $Bytes = New-Object byte[] ($Hex.Length / 2)
    for ($i = 0; $i -lt $Bytes.Length; $i++) {
        $Bytes[$i] = [Convert]::ToByte($Hex.Substring($i * 2, 2), 16)
    }
    return $Bytes
}

function Get-Sha256Text {
    param([string]$Text)
    $Sha = [System.Security.Cryptography.SHA256]::Create()
    try {
        return (ConvertTo-Hex -Bytes $Sha.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($Text)))
    }
    finally {
        $Sha.Dispose()
    }
}

function Get-Sha256File {
    param([string]$Path)
    $Sha = [System.Security.Cryptography.SHA256]::Create()
    $Stream = [System.IO.File]::OpenRead($Path)
    try {
        return (ConvertTo-Hex -Bytes $Sha.ComputeHash($Stream))
    }
    finally {
        $Stream.Dispose()
        $Sha.Dispose()
    }
}

function Move-Atomic {
    param(
        [string]$TempPath,
        [string]$TargetPath
    )
    if (Test-Path -LiteralPath $TargetPath) {
        $BackupName = "ATOMIC_REPLACE_BACKUP_{0}_{1}" -f (Get-Date -Format "yyyyMMdd_HHmmss_fffffff"), ([System.IO.Path]::GetFileName($TargetPath))
        $BackupPath = Join-Path $RecoveryDir $BackupName
        [System.IO.File]::Replace($TempPath, $TargetPath, $BackupPath, $false)
    }
    else {
        [System.IO.File]::Move($TempPath, $TargetPath)
    }
}

function Write-JsonAtomic {
    param(
        [string]$Path,
        [object]$Payload
    )
    $Temp = "$Path.tmp.$([Guid]::NewGuid().ToString('N'))"
    $Payload | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $Temp -Encoding UTF8
    $ReadBack = Get-Content -LiteralPath $Temp -Raw | ConvertFrom-Json
    if (-not $ReadBack.schema) {
        throw "JSON temp verification failed for $Path"
    }
    Move-Atomic -TempPath $Temp -TargetPath $Path
}

function Write-TextAtomic {
    param(
        [string]$Path,
        [string]$Text
    )
    $Temp = "$Path.tmp.$([Guid]::NewGuid().ToString('N'))"
    Set-Content -LiteralPath $Temp -Value $Text -Encoding UTF8
    $ReadBack = (Get-Content -LiteralPath $Temp -Raw).Trim()
    if ($ReadBack -ne $Text) {
        throw "Text temp verification failed for $Path"
    }
    Move-Atomic -TempPath $Temp -TargetPath $Path
}

function Get-RunId {
    foreach ($Path in @($StatePath, $TokenStatePath)) {
        if (Test-Path -LiteralPath $Path) {
            try {
                $State = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
                if ($State.run_id) { return [string]$State.run_id }
            }
            catch {
            }
        }
    }
    return "REMOTE_DOOR_RELAY_V2E_{0}" -f (Get-Date -Format "yyyyMMdd_HHmmss")
}

function Get-PrintValue {
    param(
        [byte[]]$SecretBytes,
        [object]$Record
    )
    $Material = "{0}|{1}|{2}|{3}|{4}" -f $Record.run_id, $Record.action, $Record.expires_at_utc, $Record.random_material, $Record.print_id
    $Hmac = [System.Security.Cryptography.HMACSHA256]::new($SecretBytes)
    try {
        return (ConvertTo-Hex -Bytes $Hmac.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($Material)))
    }
    finally {
        $Hmac.Dispose()
    }
}

function New-PrintRecord {
    param(
        [string]$Slot,
        [int]$Minutes,
        [string]$RunId,
        [byte[]]$SecretBytes
    )
    $Now = [DateTimeOffset]::UtcNow
    $Expiry = $Now.AddMinutes($Minutes)
    $Record = [ordered]@{
        schema = "remote_door_relay_v2e_print"
        slot = $Slot
        run_id = $RunId
        print_id = "PRINT-{0}-{1}" -f (Get-Date -Format "yyyyMMdd-HHmmss"), (ConvertTo-Hex -Bytes (New-RandomBytes -Length 4))
        action = "read_command_center_status"
        issued_at_utc = $Now.ToString("o")
        expires_at_utc = $Expiry.ToString("o")
        random_material = (ConvertTo-Hex -Bytes (New-RandomBytes -Length 32))
        print_algorithm = "HMAC-SHA256(local_secret, run_id|action|expiry|random_material|print_id)"
    }
    $PrintValue = Get-PrintValue -SecretBytes $SecretBytes -Record $Record
    $Record.print_sha256 = Get-Sha256Text -Text $PrintValue
    return $Record
}

$OldCurrentHash = $null
$OldNextHash = $null
if (Test-Path -LiteralPath $CurrentPath) {
    try { $OldCurrentHash = (Get-Content -LiteralPath $CurrentPath -Raw | ConvertFrom-Json).print_sha256 } catch {}
}
if (Test-Path -LiteralPath $NextPath) {
    try { $OldNextHash = (Get-Content -LiteralPath $NextPath -Raw | ConvertFrom-Json).print_sha256 } catch {}
}

$SecretHex = $null
$SecretAction = "PRESERVED"
if (-not $RotateSecret -and (Test-Path -LiteralPath $SecretPath)) {
    $Candidate = (Get-Content -LiteralPath $SecretPath -Raw).Trim()
    if ($Candidate -match '^[A-Fa-f0-9]{64}$') {
        $SecretHex = $Candidate.ToUpperInvariant()
    }
}
if (-not $SecretHex) {
    $SecretHex = ConvertTo-Hex -Bytes (New-RandomBytes -Length 32)
    $SecretAction = if ($RotateSecret) { "ROTATED" } else { "CREATED" }
}
$SecretBytes = ConvertFrom-Hex -Hex $SecretHex
$RunId = Get-RunId
$Current = New-PrintRecord -Slot "CURRENT_PRINT" -Minutes $CurrentMinutes -RunId $RunId -SecretBytes $SecretBytes
$Next = New-PrintRecord -Slot "NEXT_PRINT" -Minutes $NextMinutes -RunId $RunId -SecretBytes $SecretBytes
$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$ReceiptPath = Join-Path $RecoveryDir "RESET_REMOTE_DOOR_V2_PRINT_$Stamp.json"

$Receipt = [ordered]@{
    schema = "remote_door_relay_v2e_print_local_reset_receipt"
    verdict = if ($DryRun) { "DRY_RUN_PASS / LOCAL ONLY PRINT RESET VERIFIED" } else { "PASS / LOCAL ONLY PRINT RESET WRITTEN" }
    dry_run = [bool]$DryRun
    run_id = $RunId
    time_utc = [DateTimeOffset]::UtcNow.ToString("o")
    vault_path = $Vault
    current_print_hash = $Current.print_sha256
    next_print_hash = $Next.print_sha256
    old_current_print_hash = $OldCurrentHash
    old_next_print_hash = $OldNextHash
    secret_action = $SecretAction
    current_expires_at_utc = $Current.expires_at_utc
    next_expires_at_utc = $Next.expires_at_utc
    ledger_path = $LedgerPath
    recovery_receipt_path = $ReceiptPath
    local_only = $true
    blocked = @(
        "not callable through Remote Door",
        "no git",
        "no doctrine rewrite",
        "no proof receipt delete",
        "no Mr.Kleen touch"
    )
}

if (-not $DryRun) {
    if ($SecretAction -ne "PRESERVED") {
        Write-TextAtomic -Path $SecretPath -Text $SecretHex
    }
    Write-JsonAtomic -Path $CurrentPath -Payload $Current
    Write-JsonAtomic -Path $NextPath -Payload $Next
    $LedgerEntry = [ordered]@{
        schema = "remote_door_relay_v2e_print_ledger_entry"
        event = "LOCAL_ONLY_RESET_RESEED"
        time_utc = [DateTimeOffset]::UtcNow.ToString("o")
        run_id = $RunId
        current_print_hash = $Current.print_sha256
        next_print_hash = $Next.print_sha256
        old_current_print_hash = $OldCurrentHash
        old_next_print_hash = $OldNextHash
        receipt_path = $ReceiptPath
    }
    ($LedgerEntry | ConvertTo-Json -Compress -Depth 8) | Add-Content -LiteralPath $LedgerPath -Encoding UTF8
}

Write-JsonAtomic -Path $ReceiptPath -Payload $Receipt
$ReceiptSha = Get-Sha256File -Path $ReceiptPath

[ordered]@{
    verdict = $Receipt.verdict
    dry_run = [bool]$DryRun
    run_id = $RunId
    vault_path = $Vault
    current_print_hash = $Current.print_sha256
    next_print_hash = $Next.print_sha256
    current_expires_at_utc = $Current.expires_at_utc
    next_expires_at_utc = $Next.expires_at_utc
    ledger_path = $LedgerPath
    recovery_receipt_path = $ReceiptPath
    recovery_receipt_sha256 = $ReceiptSha
    note = "Raw prints and local secret were not printed."
} | ConvertTo-Json -Depth 6
