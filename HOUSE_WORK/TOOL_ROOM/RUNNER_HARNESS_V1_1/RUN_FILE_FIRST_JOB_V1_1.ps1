param(
  [Parameter(Mandatory=$true)][string]$JobScript,
  [Parameter(Mandatory=$true)][string]$JobName,
  [Parameter(Mandatory=$true)][string]$OutputRoot,
  [int]$TimeoutSeconds = 60,
  [string[]]$JobArgs = @()
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Hash-Maybe {
  param([string]$Path)
  if (Test-Path -LiteralPath $Path -PathType Leaf) {
    return (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash
  }
  return ""
}

function Write-Json {
  param([object]$Object, [string]$Path)
  $Object | ConvertTo-Json -Depth 14 | Set-Content -Encoding UTF8 -LiteralPath $Path
}

if (-not (Test-Path -LiteralPath $JobScript -PathType Leaf)) {
  throw "JOB_SCRIPT_NOT_FOUND: $JobScript"
}

$SafeName = ($JobName -replace '[^A-Za-z0-9_.-]', '_')
$RunId = "${SafeName}_" + (Get-Date -Format "yyyyMMdd_HHmmss")
$RunDir = Join-Path $OutputRoot $RunId
New-Item -ItemType Directory -Force -Path $RunDir | Out-Null

$ParentStarted = Join-Path $RunDir "PARENT_STARTED_$RunId.json"
$ParentReceipt = Join-Path $RunDir "PARENT_RECEIPT_$RunId.json"
$ChildStarted = Join-Path $RunDir "CHILD_STARTED_$RunId.json"
$ChildComplete = Join-Path $RunDir "CHILD_COMPLETE_$RunId.json"
$ChildFailed = Join-Path $RunDir "CHILD_FAILED_$RunId.json"
$ChildStdOut = Join-Path $RunDir "CHILD_STDOUT_$RunId.txt"
$ChildStdErr = Join-Path $RunDir "CHILD_STDERR_$RunId.txt"

$StartedUtc = (Get-Date).ToUniversalTime().ToString("o")

Write-Json -Path $ParentStarted -Object ([pscustomobject]@{
  Status = "STARTED"
  RunId = $RunId
  JobName = $JobName
  StartedUtc = $StartedUtc
  ParentPid = $PID
  RequiresKeyboardInput = $false
  ProofType = "FILE_FIRST_PARENT_STARTED"
})

$PwshCmd = Get-Command pwsh -ErrorAction Stop

$Args = @(
  "-NoLogo",
  "-NoProfile",
  "-NonInteractive",
  "-ExecutionPolicy", "Bypass",
  "-File", $JobScript,
  "-RunId", $RunId,
  "-RunDir", $RunDir
) + $JobArgs

$Child = Start-Process `
  -FilePath $PwshCmd.Source `
  -ArgumentList $Args `
  -WorkingDirectory $RunDir `
  -RedirectStandardOutput $ChildStdOut `
  -RedirectStandardError $ChildStdErr `
  -WindowStyle Hidden `
  -PassThru

$Exited = $Child.WaitForExit($TimeoutSeconds * 1000)

$Killed = $false
if (-not $Exited) {
  try { $Child.Kill(); $Killed = $true } catch {}
  try { $Child.WaitForExit() } catch {}
}

$ExitCode = if ($Exited) { $Child.ExitCode } else { $null }

$ChildStartedExists = Test-Path -LiteralPath $ChildStarted -PathType Leaf
$ChildCompleteExists = Test-Path -LiteralPath $ChildComplete -PathType Leaf
$ChildFailedExists = Test-Path -LiteralPath $ChildFailed -PathType Leaf

$Verdict = "FAIL"
$FailureReason = ""

if (-not $Exited) {
  $Verdict = "HUNG"
  $FailureReason = "CHILD_TIMEOUT"
} elseif ($ExitCode -ne 0) {
  $Verdict = "FAIL"
  $FailureReason = "CHILD_EXIT_CODE_$ExitCode"
} elseif (-not $ChildCompleteExists) {
  $Verdict = "FAIL"
  $FailureReason = "NO_CHILD_COMPLETE_SENTINEL"
} else {
  $ChildJson = Get-Content -Raw -LiteralPath $ChildComplete | ConvertFrom-Json
  if ($ChildJson.Status -eq "COMPLETE" -and $ChildJson.RequiresKeyboardInput -eq $false) {
    $Verdict = "PASS"
    $FailureReason = ""
  } else {
    $Verdict = "FAIL"
    $FailureReason = "BAD_CHILD_COMPLETE_SENTINEL"
  }
}

$FinishedUtc = (Get-Date).ToUniversalTime().ToString("o")

$Receipt = [pscustomobject]@{
  Status = $Verdict
  RunId = $RunId
  JobName = $JobName
  StartedUtc = $StartedUtc
  FinishedUtc = $FinishedUtc
  RunDir = $RunDir
  ParentPid = $PID
  ChildPid = $Child.Id
  ChildExited = $Exited
  ChildKilled = $Killed
  ChildExitCode = $ExitCode
  TimeoutSeconds = $TimeoutSeconds
  FailureReason = $FailureReason
  RequiresKeyboardInput = $false
  ProofType = "RUNNER_HARNESS_V1_1_FILE_FIRST_PARENT_CHILD"
  JobScript = $JobScript
  JobScriptSHA256 = Hash-Maybe $JobScript
  ChildStarted = $ChildStarted
  ChildStartedExists = $ChildStartedExists
  ChildStartedSHA256 = Hash-Maybe $ChildStarted
  ChildComplete = $ChildComplete
  ChildCompleteExists = $ChildCompleteExists
  ChildCompleteSHA256 = Hash-Maybe $ChildComplete
  ChildFailed = $ChildFailed
  ChildFailedExists = $ChildFailedExists
  ChildFailedSHA256 = Hash-Maybe $ChildFailed
  ChildStdOut = $ChildStdOut
  ChildStdOutSHA256 = Hash-Maybe $ChildStdOut
  ChildStdErr = $ChildStdErr
  ChildStdErrSHA256 = Hash-Maybe $ChildStdErr
  Boundary = "File-first runner only. No watcher. No service. No commit. No delete. No move."
}

Write-Json -Path $ParentReceipt -Object $Receipt

$Receipt
