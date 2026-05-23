# Root 123 Porch Cleanup Report

Date: 2026-05-23

## Before

Loose files at `C:\Users\13527\Desktop\123`:

- `BROAD_COMMAND_RECURSIVE_TRIGGER_LIST_20260523.md`
- `SAVE_BROAD_COMMAND_TRIGGER_LIST_TO_GIT_V1.ps1`
- `SAVE_BROAD_COMMAND_TRIGGER_LIST_TO_GIT_V1_1.ps1`
- `SAVE_BROAD_COMMAND_TRIGGER_LIST_TO_GIT_V1_2.ps1`

Root directories:

- `COMMAND_CENTER`
- `Jxhnny_Kl33N_Seedz`

## Actions

Moved broad command source copy to:

`RULE_INTAKE\PROCESSED_ROOT_123_BROAD_COMMAND_20260523\BROAD_COMMAND_RECURSIVE_TRIGGER_LIST_20260523.md`

Moved dropped save runners to:

`TOOLS\PORCH_DROPPED_HELPER_SCRIPTS_20260523\BROAD_COMMAND_TRIGGER_LIST_SAVE_RUNNERS_20260523`

## After

Root `C:\Users\13527\Desktop\123` contains only:

- `COMMAND_CENTER`
- `Jxhnny_Kl33N_Seedz`

## Live Issues Found

1. The first cleanup command attempted to use `$home`, which PowerShell treats as the reserved `$HOME` variable. This reproduced the reserved-variable failure family in live work.
2. This PowerShell version did not accept `New-Item -LiteralPath`; directory creation needed `New-Item -Path`, while file moves still used `Move-Item -LiteralPath`.
3. The moved runners are historical, not current execution scripts.
4. V1 and V1.1 point to the old home path.
5. All runner versions reference Work Shed paths, while shed lanes remain excluded by house boundary.

## Porch Verdict

PASS WITH GUARDRAILS.

The loose root files were moved into custody, no delete was performed, and the root porch is clean except for the two expected directories.

