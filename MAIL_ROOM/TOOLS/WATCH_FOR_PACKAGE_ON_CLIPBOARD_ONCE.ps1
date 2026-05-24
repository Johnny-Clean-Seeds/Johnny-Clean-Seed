param(
    [int]$TimeoutSeconds = 300
)

$ErrorActionPreference = "Stop"

$MailRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
$Receiver = Join-Path $MailRoot "TOOLS\RECEIVE_PACKAGE_FROM_CLIPBOARD.ps1"

if (-not (Test-Path -LiteralPath $Receiver)) {
    throw "Missing receiver: $Receiver"
}

$Start = Get-Date
$LastHash = $null

Write-Host "MAIL_ROOM WATCHER V0"
Write-Host "Waiting for PACKAGE_V0 on clipboard..."
Write-Host "TimeoutSeconds: $TimeoutSeconds"

while (((Get-Date) - $Start).TotalSeconds -lt $TimeoutSeconds) {
    Start-Sleep -Milliseconds 750

    $Clip = Get-Clipboard -Raw -ErrorAction SilentlyContinue
    if (-not $Clip) { continue }
    if ($Clip -notmatch "PACKAGE_V0") { continue }

    $Hash = [System.BitConverter]::ToString(
        [System.Security.Cryptography.SHA256]::HashData(
            [System.Text.Encoding]::UTF8.GetBytes($Clip)
        )
    ).Replace("-","")

    if ($Hash -eq $LastHash) { continue }
    $LastHash = $Hash

    Write-Host "PACKAGE_V0 detected. Delivering..."
    & $Receiver
    Write-Host "MAIL_ROOM WATCHER DELIVERED PACKAGE."
    exit 0
}

throw "Timeout waiting for PACKAGE_V0 on clipboard."
