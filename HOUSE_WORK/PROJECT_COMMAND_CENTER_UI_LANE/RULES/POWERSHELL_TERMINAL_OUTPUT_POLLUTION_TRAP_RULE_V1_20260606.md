# PowerShell Terminal Output Pollution Trap Rule V1

Date: 2026-06-06
Status: ACTIVE_HELPER_RULE
Scope: Command Center UI Lane and future helper PowerShell work

## Rule

Helpers must distinguish commands from terminal output.

Never paste prior terminal output back into PowerShell.

Do not run lines that begin with PS C:\, PS D:\, >>, RelativePath, SourcePath, ProposedTargetPath, ExpectedSHA256, SourceExists, HashMatches, TargetExists, TargetInsideUiLane, Extension, Count, True, False, HEAD, commit hashes, git log output, table output, or previous error output.

## Recovery

If PowerShell shows >> unexpectedly, press Ctrl+C once and wait for a clean PS prompt.

Then run one small status check:

git --no-pager -C "C:\Users\13527\Desktop\123\Jxhnny_Kl33N_Seedz" status -sb

Expected clean result:

## main...origin/main

## Interpretation

Red errors caused by replayed output are TERMINAL_OUTPUT_POLLUTION_SUSPECTED.

They do not automatically prove repo failure, file failure, install failure, or broken code.

## Output Design

Use count-only summaries first.

Only print bad rows when bad rows exist.

Do not use huge Format-List dumps unless explicitly requested.

## Related Incident

The UI lane copy-plan check successfully reached COPY_PLAN_VERIFY_PASS_TARGET_ALREADY_EXISTS with 57 planned rows verified before output pollution occurred.

## DoesNotProve

This rule does not prove the UI is launched.
This rule does not authorize install execution.
This rule does not authorize watcher startup, automation, cleanup, delete, commit, push, or doctrine promotion.
