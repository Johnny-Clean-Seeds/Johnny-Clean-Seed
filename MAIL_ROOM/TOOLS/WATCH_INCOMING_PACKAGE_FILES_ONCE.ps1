param(
    [int]$InitialTimeoutSeconds = 300,
    [int]$IdleAfterFirstSeconds = 15,
    [int]$StableMilliseconds = 900
)

$ErrorActionPreference = "Stop"

$MailRoot = "$env:USERPROFILE\Desktop\123\MAIL_ROOM"
$Incoming = Join-Path $MailRoot "INCOMING_PACKAGES"
$Processor = Join-Path $MailRoot "TOOLS\PROCESS_NEXT_PACKAGE_FILE.ps1"

if (-not (Test-Path -LiteralPath $Processor)) {
    throw "Missing processor: $Processor"
}

New-Item -ItemType Directory -Force -Path $Incoming | Out-Null

function Get-MailCandidate {
    Get-ChildItem -LiteralPath $Incoming -File -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -notmatch '\.tmp$|\.partial$' } |
        Sort-Object LastWriteTimeUtc |
        Select-Object -First 1
}

function Wait-FileStable([string]$Path, [int]$Milliseconds) {
    $A = Get-Item -LiteralPath $Path
    Start-Sleep -Milliseconds $Milliseconds
    $B = Get-Item -LiteralPath $Path
    return (($A.Length -eq $B.Length) -and ($A.LastWriteTimeUtc -eq $B.LastWriteTimeUtc))
}

Write-Host "MAIL_ROOM UNIVERSAL WATCHER V0D"
Write-Host "Inbox:"
Write-Host $Incoming
Write-Host "Rule: any stable file is mail. PACKAGE_V0 gets package mode; all others get RAW_DROP mode."
Write-Host "InitialTimeoutSeconds: $InitialTimeoutSeconds"
Write-Host "IdleAfterFirstSeconds: $IdleAfterFirstSeconds"
Write-Host ""

$Start = Get-Date
$LastDelivery = $null
$DeliveredCount = 0

while ($true) {
    $Item = Get-MailCandidate

    if ($Item) {
        if (-not (Wait-FileStable -Path $Item.FullName -Milliseconds $StableMilliseconds)) {
            Write-Host "File still being written, waiting..."
            Start-Sleep -Milliseconds 750
            continue
        }

        Write-Host ""
        Write-Host "MAIL FILE FOUND:"
        Write-Host $Item.FullName

        & $Processor -PackagePath $Item.FullName

        $DeliveredCount++
        $LastDelivery = Get-Date

        Write-Host ""
        Write-Host "Processed mail count: $DeliveredCount"
        Write-Host "Waiting briefly for more mail..."
        continue
    }

    if ($DeliveredCount -gt 0) {
        $IdleSeconds = ((Get-Date) - $LastDelivery).TotalSeconds
        if ($IdleSeconds -ge $IdleAfterFirstSeconds) {
            Write-Host ""
            Write-Host "NO MORE MAIL / STOPPING"
            Write-Host "Processed mail count: $DeliveredCount"
            exit 0
        }
    } else {
        $Elapsed = ((Get-Date) - $Start).TotalSeconds
        if ($Elapsed -ge $InitialTimeoutSeconds) {
            throw "Timeout waiting for first file in INCOMING_PACKAGES."
        }
    }

    Start-Sleep -Milliseconds 750
}
