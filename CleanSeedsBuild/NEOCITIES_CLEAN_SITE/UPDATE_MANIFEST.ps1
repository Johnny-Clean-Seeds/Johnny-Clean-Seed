$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$Data = Join-Path $Root 'data'
$Out = Join-Path $Root 'scripts\manifest.js'
function Get-Rel([string]$base,[string]$file){
  $u1 = [Uri]((Resolve-Path -LiteralPath $base).Path.TrimEnd('\') + '\')
  $u2 = [Uri]((Resolve-Path -LiteralPath $file).Path)
  [Uri]::UnescapeDataString($u1.MakeRelativeUri($u2).ToString())
}
$items = @()
if (Test-Path -LiteralPath $Data -PathType Container) {
  Get-ChildItem -LiteralPath $Data -Recurse -File | Sort-Object FullName | ForEach-Object {
    $rel = Get-Rel $Data $_.FullName
    $hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $_.FullName).Hash
    $items += [pscustomobject]@{ path = $rel; url = ('data/' + $rel); size = $_.Length; modifiedUtc = $_.LastWriteTimeUtc.ToString('o'); sha256 = $hash }
  }
}
$manifest = [pscustomobject]@{ generatedUtc = (Get-Date).ToUniversalTime().ToString('o'); files = $items }
'window.SITE_MANIFEST = ' + ($manifest | ConvertTo-Json -Depth 6) + ';' | Set-Content -LiteralPath $Out -Encoding UTF8
Write-Host "Updated manifest: $Out"
Write-Host "Files: $($items.Count)"
