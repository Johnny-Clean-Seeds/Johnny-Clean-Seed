# CHECK_INTAKE_GATE_KEY_HASH_JOIN_V1_1_20260530.ps1
# Route wrapper for the V1 Intake Gate key/hash audit after report-writer binding repair.
# Boundary: read/report only. No Git writes. No commit. No push. No delete. No move. No doctrine.

[CmdletBinding()]
param([switch]$Strict, [int]$MaxTopFindings = 120)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Target = Join-Path $PSScriptRoot "CHECK_INTAKE_GATE_KEY_HASH_JOIN_V1_20260530.ps1"
if (!(Test-Path -LiteralPath $Target)) {
    throw "Missing Intake Gate audit target: $Target"
}

$InvokeArgs = @{ MaxTopFindings = $MaxTopFindings }
if ($Strict) { $InvokeArgs.Strict = $true }

& $Target @InvokeArgs
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
