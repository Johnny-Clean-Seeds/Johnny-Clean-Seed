param(
    [Parameter(Mandatory=$true)][string]$CommandCenterPath,
    [Parameter(Mandatory=$true)][string]$JobId,
    [Parameter(Mandatory=$true)][string]$OutputPath
)

$ErrorActionPreference = "Stop"

$AllowedFiles = @(
    "README_START_HERE.md",
    "CURRENT_CONTEXT_CART.md",
    "NEXT_ON_THE_PLATE.md",
    "BLOCKED_MOVES.md",
    "ROOM_INDEX.md"
)

$Lines = New-Object System.Collections.Generic.List[string]
$Lines.Add("LEVEL2 APPROVED HELPER OUTPUT")
$Lines.Add("Helper: read_child_shell_status_summary")
$Lines.Add("Job ID: $JobId")
$Lines.Add("Date: $(Get-Date -Format o)")
$Lines.Add("Command Center: $CommandCenterPath")
$Lines.Add("")
$Lines.Add("Allowed read files:")

foreach ($Name in $AllowedFiles) {
    $Path = Join-Path $CommandCenterPath $Name
    if (Test-Path -LiteralPath $Path) {
        $Hash = (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
        $Raw = Get-Content -LiteralPath $Path -Raw
        $Length = $Raw.Length
        $Preview = $Raw
        if ($Preview.Length -gt 600) {
            $Preview = $Preview.Substring(0, 600) + "`n[TRUNCATED BY LEVEL2 HELPER]"
        }
        $Lines.Add("----- $Name -----")
        $Lines.Add("Path: $Path")
        $Lines.Add("SHA256: $Hash")
        $Lines.Add("Length: $Length")
        $Lines.Add("Preview:")
        $Lines.Add($Preview)
        $Lines.Add("")
    }
    else {
        $Lines.Add("----- $Name -----")
        $Lines.Add("Path: $Path")
        $Lines.Add("MISSING")
        $Lines.Add("")
    }
}

$Parent = Split-Path -Parent $OutputPath
if ($Parent -and -not (Test-Path -LiteralPath $Parent)) {
    New-Item -ItemType Directory -Force -Path $Parent | Out-Null
}

Set-Content -LiteralPath $OutputPath -Value ($Lines -join "`n") -Encoding UTF8
