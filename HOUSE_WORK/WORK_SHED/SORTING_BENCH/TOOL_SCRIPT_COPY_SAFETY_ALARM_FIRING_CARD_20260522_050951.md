# Tool / Script / Copy Safety Alarm Firing Card

Date: 20260522_050951

Base:

7c8e0a10c3c94074fb17bd2bba8659defd9d483e

## Alarm group

Tool / Script / Copy Safety

## Primary alarm

Large local scripts should be delivered as .ps1 artifacts with short launcher commands unless the user asks for full visible code.

## Triggers

This card should fire when:

1. A script is long enough to fill the screen.
2. A save/recovery route requires many lines.
3. A script is base-bound and may go stale.
4. A command block could accidentally include markdown fences.
5. Git operations are used inside PowerShell.
6. PROOF_HISTORY or ignored paths must be committed.
7. A dirty repo or wrong base could cause partial state.
8. The user reports screen drag, flicker, or paste burden.
9. A local helper script should reuse a known filing-cabinet skeleton.
10. A previous execution failure shows a repeatable script pattern.

## Required behavior

When this alarm fires, the assistant should:

1. Prefer .ps1 file artifact plus short launcher.
2. Keep the launcher short and pasteable.
3. Avoid long visible code blocks.
4. Use git.exe explicitly in PowerShell scripts.
5. Remove or avoid risky function names that shadow external commands.
6. Include strict expected-base checks.
7. Include clean-status checks before writing.
8. Include diff checks before commit.
9. Force-add intentional ignored proof receipts.
10. Verify final local/remote HEAD match.
11. Verify final status clean.
12. Warn if a previously generated script is stale.

## Severity

WATCH in discussion.

WARNING when creating scripts.

BLOCKER when the script mutates Mr.Kleen, commits, pushes, repairs, deletes, moves, or rewrites tracked house files.

## Proof that it fired

Proof may include:

1. A downloadable script instead of a long chat block.
2. A short launcher only.
3. A script self-check line count and SHA256.
4. A safe stop on base mismatch.
5. A final save receipt and clean Git proof.
6. User-visible reduction of copy/paste burden.

## Current verdict

PASS WITH GUARDRAILS / THIRD REPAIR TARGET SELECTED / NO PROMOTION
