# Handoff Assistant Safe Save Method Card

Date: 2026-05-20

## Read This First For Mr.Kleen Save Work

Use this method for long save scripts and multi-file Mr.Kleen changes.

## Safe Save Flow

Code Cabinet -> downloadable ps1 when long -> one run command -> parser/lint check -> execute -> receipt -> commit -> push -> fetch -> HEAD equals origin/main -> status clean.

## Run Command For Downloaded ps1

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force; $p="$env:USERPROFILE\Downloads\FILE.ps1"; $t=$null; $e=$null; [System.Management.Automation.Language.Parser]::ParseFile($p,[ref]$t,[ref]$e) | Out-Null; if($e.Count){$e | Format-List | Out-String | Write-Host; throw "Parser errors in downloaded script"}; & $p

## Hard Bans

Do not put prose inside PowerShell copy material.

Do not let Markdown fence text enter PowerShell.

Do not rerun blindly after a failed partial save.

Do not trust printed PASS after any earlier error.

Do not claim saved without final HEAD equals origin/main and status clean.

## Recovery Rule

If a script stops before commit:

1. fetch origin main;
2. confirm HEAD equals origin/main;
3. inspect git status;
4. allow only expected dirty paths;
5. verify required files and markers;
6. write receipt;
7. commit;
8. push;
9. fetch;
10. confirm HEAD equals origin/main;
11. confirm status clean.

## Boundary

This is a handoff/save method card.

It is not doctrine.

It is not an active guide.

It is not CURRENT_TRUTH_INDEX.

It is not automation or runtime.

---

## 2026-05-20 - Resolver Run Command Patch

For downloaded ps1 files, use a resolver command:

- search expected locations;
- accept browser-renamed copies;
- print FOUND SCRIPT path;
- parser-check the resolved path;
- run the resolved path.

Do not use hardcoded Downloads exact-path commands as the only route.
