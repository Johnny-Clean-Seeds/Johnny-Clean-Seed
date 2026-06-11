# Helper Script Generation Base Layer Guard Checklist V1

Date: 2026-05-30
RunId: 20260530_092451
WorkKey: HELPER-GENERATOR-BASE-LAYER-GUARD-20260530
Status: CHECKLIST / SCRIPT-GENERATION SUPPORT / NOT DOCTRINE

## Before generating a helper

- Confirm this is a local-evidence task, not a judgment-only task.
- Name the active object.
- Name the source report or file.
- Name the output report.
- Name blocked lanes.
- Name whether Code Gate is required.

## PowerShell base-layer checklist

- Use `New-StringList` or equivalent mutable list for report lines.
- Add report lines through a safe helper that accepts empty state.
- Avoid `$Matches`, `$Pid`, `$Args`, `$Input`, `$Error`, and other automatic/reserved names.
- Avoid markdown backtick fences inside double-quoted strings.
- Use tilde fences or single-quoted here-strings for literal report blocks.
- Precompute command output before `-split`, `-replace`, or comparison operators.
- Do not mix Sort-Object calculated hashtables and property switches in fragile one-liners.
- Keep parser/test paths aligned with direct paths.
- Write content before manifest.
- Write manifest before receipt.
- Stage exact files only and verify the staged set.

## Failure response

- Parser FAIL: target does not run.
- Runtime FAIL below task layer: freeze upper task and diagnose helper layer.
- Third adjacent lower-layer failure: stop one-off repairs and inspect generator pattern.
- Dirty-state failure: prove clean status before any save claim.
- Command-surface mash: clear prompt, do not rerun old bad commands.

## Close labels

- CLEAN_CLOSE
- BLOCKED_WITH_RETURN_POINT
- CHOKE_STOP
- CHOKE_CAUSED_END
- USER_STOP

`CHOKE_CAUSED_END` is never PASS.
