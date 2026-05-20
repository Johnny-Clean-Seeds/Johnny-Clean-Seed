$ErrorActionPreference = "Stop"
$PacketRoot = Split-Path -Parent $PSScriptRoot
$RepoFile = Join-Path $PacketRoot "REPO_ROOT.txt"
if (-not (Test-Path -LiteralPath $RepoFile)) { throw "REPO_ROOT.txt missing" }
$Repo = (Get-Content -LiteralPath $RepoFile -Raw -Encoding UTF8).Trim()
if (-not (Test-Path -LiteralPath $Repo)) { throw "Repo path missing: $Repo" }
Push-Location $Repo
try {
    & (Join-Path $PacketRoot "STALE_CHECKER_001.ps1")
}
finally {
    Pop-Location
}
