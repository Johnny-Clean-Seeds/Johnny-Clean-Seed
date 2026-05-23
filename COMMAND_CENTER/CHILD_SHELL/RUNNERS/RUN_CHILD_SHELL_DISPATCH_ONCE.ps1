$ErrorActionPreference = "Stop"

$Root123 = "$env:USERPROFILE\Desktop\123"
$CC = Join-Path $Root123 "COMMAND_CENTER"
$ChildRoot = Join-Path $CC "CHILD_SHELL"
$Inbox = Join-Path $ChildRoot "INBOX"
$Rejected = Join-Path $ChildRoot "REJECTED"
$Runners = Join-Path $ChildRoot "RUNNERS"
$Level1Runner = Join-Path $Runners "RUN_CHILD_SHELL_LEVEL1_ONCE.ps1"
$Level2Runner = Join-Path $Runners "RUN_CHILD_SHELL_LEVEL2_APPROVED_HELPER_ONCE.ps1"
$Level3Runner = Join-Path $Runners "RUN_CHILD_SHELL_LEVEL3_APPROVED_HOUSE_SAVE_ONCE.ps1"

$Jobs = @(Get-ChildItem -LiteralPath $Inbox -File -Filter "*.childjob.json" -ErrorAction SilentlyContinue | Sort-Object Name)
if ($Jobs.Count -eq 0) {
    Write-Host "CHILD SHELL DISPATCH: NO JOB FOUND"
    return
}

$JobFile = $Jobs[0]
try {
    $Job = Get-Content -LiteralPath $JobFile.FullName -Raw | ConvertFrom-Json
}
catch {
    $RejectNote = Join-Path $Rejected "$($JobFile.BaseName).dispatch.rejected.txt"
    Set-Content -LiteralPath $RejectNote -Value "Dispatch rejected malformed JSON: $($_.Exception.Message)" -Encoding UTF8
    Move-Item -LiteralPath $JobFile.FullName -Destination (Join-Path $Rejected $JobFile.Name) -Force
    throw "STOP. Dispatch rejected malformed JSON."
}

$Action = [string]$Job.allowed_action

if ($Action -eq "read_command_center_status") {
    & $Level1Runner
}
elseif ($Action -eq "run_approved_helper") {
    & $Level2Runner
}
elseif ($Action -eq "run_approved_house_save_package") {
    & $Level3Runner
}
else {
    $JobId = [string]$Job.job_id
    if ([string]::IsNullOrWhiteSpace($JobId)) { $JobId = $JobFile.BaseName }
    $RejectNote = Join-Path $Rejected "$JobId.dispatch.rejected.txt"
    Set-Content -LiteralPath $RejectNote -Value "Dispatch rejected blocked action: $Action" -Encoding UTF8
    Move-Item -LiteralPath $JobFile.FullName -Destination (Join-Path $Rejected $JobFile.Name) -Force
    throw "STOP. Dispatch rejected blocked action: $Action"
}
