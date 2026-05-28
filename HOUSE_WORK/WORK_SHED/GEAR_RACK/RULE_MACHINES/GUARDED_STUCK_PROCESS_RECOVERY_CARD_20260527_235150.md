# Guarded Stuck Process Recovery Card

## Purpose

Teach future helpers, Codex, and GPTs how to recover from a stuck PowerShell helper without killing real progress.

## Rule

Do not kill a process just because it is quiet.

Only consider recovery when there is evidence of a true stuck condition.

## Stuck Evidence Checklist

A process may be treated as stuck only when most of these are true:

- The same target script has been running longer than expected for its normal job.
- The shell does not return to prompt.
- The user reports the machine is choking, frozen, or unusable.
- Ctrl+C fails or does not return control.
- A process check shows a parent/child chain still running the same target.
- No new report, receipt, or output file has changed recently.
- The target is known to be heavy, broad, recursive, or hashing too much.

## Do Not Kill When

Do not self-correct when:

- The process is still printing batch checkpoints.
- A report file is growing normally.
- The script is doing a known save, commit, push, or install step.
- The target has not been identified by exact script name.
- The process might be unrelated to the stuck target.
- Git status or file writes are in progress and not understood.

## Safe Recovery Ladder

Use the lowest force first.

1. Wait for a clear checkpoint or prompt.
2. Try Ctrl+C once.
3. Open a second PowerShell window if the first is frozen.
4. List PowerShell processes and identify the exact stuck target by CommandLine.
5. Kill only the child target process first when possible.
6. Kill the runner parent only if the child does not stop.
7. Never kill the main interactive shell unless the user chooses to close it.
8. After recovery, verify the target is gone.
9. Check Git status from the repo folder.
10. Replace the heavy helper with a tiny fixed-target helper.

## Process Identification Pattern

The target process must match the exact stuck script name in CommandLine.

Example condition:

Name contains pwsh or powershell.

CommandLine contains the exact target script name.

## Weak PC Rule

On weak PCs, avoid broad recovery scans.

Prefer tiny checks:

- process list filtered by target name
- newest report check
- Git status short
- fixed list hash receipt
- batch size 5 to 10

## Current Lesson Learned

GET_LOCAL_HASH_RECEIPT_V1.ps1 appeared to choke because it likely hashed too much.

Replacement direction:

Use tiny fixed-target hash receipts only.

Hash only:

- Code Gate V1.3
- Code Gate V1.4
- newest runner reports
- newest extraction or handoff reports

Do not hash the whole house unless explicitly needed.

## Boundary

This is a candidate operating rule.

It does not grant permission to kill processes automatically.

It requires target identification and user-visible confirmation unless the machine is unusable.

No Git writes.

No doctrine rewrite.

No active guide rewrite.

No current truth rewrite.
