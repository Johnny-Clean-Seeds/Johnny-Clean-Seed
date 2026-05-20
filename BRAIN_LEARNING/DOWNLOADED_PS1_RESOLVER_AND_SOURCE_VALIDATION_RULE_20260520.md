# Downloaded ps1 Resolver and Source Validation Rule

Date: 2026-05-20

## Status

ACTIVE DELIVERY-SAFETY PATCH / SUPPORT RULE.

## Trigger

Repeated downloaded-script runs failed for two different delivery reasons:

1. The run command assumed the script was at Downloads with an exact filename.
2. Browser-renamed files such as "(1)" were not accepted until a resolver was used.
3. Source validation inside the save script used brittle exact-text or narrow regex checks on existing source files.
4. Those checks stopped safe scripts even when the source concept was present.

## Rule

For downloaded ps1 scripts:

- do not rely only on a hardcoded Downloads exact filename;
- resolve the newest matching script from expected locations before parser-checking;
- accept browser-renamed copies such as "(1)";
- print the found path before running;
- parser-check the resolved file;
- run only the resolved file.

For source validation inside save scripts:

- source files should be checked for existence, readability, nonempty content, NUL bytes, replacement characters, and obvious placeholders;
- broad concept checks are allowed only when necessary;
- brittle exact phrase checks are not allowed on old/source files;
- exact phrase checks should be reserved for artifacts the current script creates or patches;
- if a preflight check fails before writes, treat it as no repo damage and diagnose the check instead of rerunning blindly.

## Standard Resolver Shape

Use this pattern and change only the file stem:

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force; $name="FILE_STEM*.ps1"; $roots=@("$env:USERPROFILE\Downloads","$env:USERPROFILE\Desktop","$env:USERPROFILE\OneDrive\Desktop") | Where-Object { Test-Path $_ }; $p=Get-ChildItem -Path $roots -Filter $name -File -Recurse -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1; if(-not $p){throw "Script file not found. Download FILE_STEM.ps1, then run this again."}; Write-Host "FOUND SCRIPT:" $p.FullName; $t=$null; $e=$null; [System.Management.Automation.Language.Parser]::ParseFile($p.FullName,[ref]$t,[ref]$e) | Out-Null; if($e.Count){$e | Format-List | Out-String | Write-Host; throw "Parser errors in downloaded script"}; & $p.FullName

## Boundary

This is not automation.

This is not a promoted tool.

This does not rewrite active guides.

This does not rewrite CURRENT_TRUTH_INDEX.
