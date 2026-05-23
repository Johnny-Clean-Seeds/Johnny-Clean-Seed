param(
    [switch]$Execute
)

$ErrorActionPreference = "Stop"

$Name = "SAVE_AND_RUN_PORCH_MOVE_DROPPER_RULE_20260522.ps1"
$SearchRoots = @(
    "$env:USERPROFILE\Desktop\123",
    "$env:USERPROFILE\Downloads",
    "$env:USERPROFILE\Desktop"
)

$Found = Get-ChildItem $SearchRoots -Filter $Name -File -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1

if (-not $Found) {
    throw "Main porch dropper script not found: $Name"
}

$Target = "$env:USERPROFILE\Desktop\123\$Name"
Copy-Item -LiteralPath $Found.FullName -Destination $Target -Force
Unblock-File -LiteralPath $Target -ErrorAction SilentlyContinue

if ($Execute) {
    pwsh -NoProfile -ExecutionPolicy Bypass -File $Target -Execute -SkipGitSave
} else {
    pwsh -NoProfile -ExecutionPolicy Bypass -File $Target -PlanOnly -SkipGitSave
}
