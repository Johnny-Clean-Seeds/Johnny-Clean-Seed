$ErrorActionPreference = "Stop"

$MailRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
$Pickup = Join-Path $MailRoot "TOOLS\PICKUP_TO_MAIL_ROOM.ps1"

if (-not (Test-Path -LiteralPath $Pickup)) {
    throw "Missing pickup helper: $Pickup"
}

$ChosenPath = $null

try {
    Add-Type -AssemblyName System.Windows.Forms
    $Dialog = New-Object System.Windows.Forms.OpenFileDialog
    $Dialog.Title = "Choose file to send to MAIL_ROOM"
    $Dialog.InitialDirectory = [Environment]::GetFolderPath("Desktop")
    $Dialog.Filter = "All files (*.*)|*.*"
    $Dialog.Multiselect = $false

    if ($Dialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $ChosenPath = $Dialog.FileName
    }
}
catch {
    Write-Host "File picker unavailable. Paste or drag the file path here."
    $ChosenPath = Read-Host "File path"
}

if (-not $ChosenPath) {
    throw "No file selected."
}

$ChosenPath = $ChosenPath.Trim().Trim('"')

if (-not (Test-Path -LiteralPath $ChosenPath -PathType Leaf)) {
    throw "Selected file does not exist: $ChosenPath"
}

Write-Host "Sending file to MAIL_ROOM:"
Write-Host $ChosenPath
Write-Host ""

& $Pickup -Path $ChosenPath -RunWatcher
