param(
    [switch]$ExecuteRootClean
)

$ErrorActionPreference = "Stop"

$Name = "SAVE_PORCH_DROP_EVENT_TRIGGER_AND_PACKAGE_RULE_20260522.ps1"
$Tool = "C:\Users\13527\Desktop\123\PORCH_WATCHER\TOOLS\$Name"

if (-not (Test-Path -LiteralPath $Tool)) {
    $Found = Get-ChildItem "$env:USERPROFILE\Downloads","$env:USERPROFILE\Desktop","$env:USERPROFILE\Desktop\123","C:\Users\13527\Desktop\123\PORCH_WATCHER\TOOLS" -Filter $Name -File -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1

    if (-not $Found) {
        throw "Main porch event script not found: $Name"
    }

    Move-Item -LiteralPath $Found.FullName -Destination $Tool -Force
}

Unblock-File -LiteralPath $Tool -ErrorAction SilentlyContinue

if ($ExecuteRootClean) {
    pwsh -NoProfile -ExecutionPolicy Bypass -File $Tool -ExecuteRootClean -SkipGitSave
} else {
    pwsh -NoProfile -ExecutionPolicy Bypass -File $Tool -SkipGitSave
}
