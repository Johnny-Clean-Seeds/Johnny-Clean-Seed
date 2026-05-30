# Key/Ledger/Map Driver CWD Route Learning Event

Date: 2026-05-30
RunId: 20260530_010525
WorkKey: KEY_2E6F99ED9EFE
Status: ACTOR-OWNED LEARNING EVENT / FILE-LEVEL SAVE

## Trigger

LOCK_SAVE_KEY_LEDGER_MAP_DRIVER_V1.ps1 failed at runtime:

git rev-parse HEAD failed because Git was not running inside the repo.

## Actor-owned failure

The generated script accepted a Cwd parameter in its Git helper, but it did not actually make the native git command run in that directory.

The function looked like it had repo custody, but Git still ran from the caller's current terminal location.

## Repair rule

For generated PowerShell save scripts:

- do not rely on a decorative Cwd parameter;
- use git -C <RepoRoot> or Push-Location / Pop-Location with finally;
- verify git rev-parse --is-inside-work-tree;
- verify the repo path before first Git call;
- include the exact repo path in Git failure text;
- do not write files until the repo route is proven.

## Connection to Key/Ledger/Map Driver

This failure proves the driver concept.

Keys and maps must drive the tool, not decorate the plan.
