# Code Gate Warning Response Layer Card

## Status

Candidate operating card.

This card teaches future helpers, GPTs, and local scripts how to respond when Code Gate warnings appear.

It does not modify Code Gate.

It does not promote warnings into doctrine.

It gives warnings a response path so they do not become confusing noise.

## Purpose

Code Gate warnings are not all equal.

Some warnings are expected and allowed.

Some warnings are noisy shape issues.

Some warnings are blocker-adjacent and need review before the next script.

Some warnings mean the helper should stop and ask for a narrower route.

Every warning should get a named response.

## Core Rule

A warning must be classified before the next action.

Do not treat every warning as failure.

Do not ignore warnings just because the final verdict says PASS WITH WATCH.

Code Gate PASS is not job PASS.

If the helper cannot fully classify the warning, it should still attempt the nearest safe response and route the uncertainty to a review lane soon.

## Warning Response Matrix

### Local file write command

Meaning:

The target writes local files, reports, receipts, cards, or ledgers.

Default response:

EXPECTED_ALLOWED_REPORT_WRITE when the target is a read/report/card helper and clearly says what it wrote.

Required checks:

- Output names the written files.
- Boundary says no Git, no delete, no move, no doctrine rewrite, no active guide rewrite, no current truth rewrite.
- Files are written to an expected lane such as READ_REPORTS, PROOF_HISTORY, BRAIN_LEARNING, GEAR_RACK, RECEIPTS, or a named local tools folder.
- Git status is checked if the write occurred inside the repo.

Escalate when:

- The script writes outside expected lanes.
- The script writes many files without naming them.
- The script writes into root with no route.
- The script changes ACTIVE_GUIDES, CURRENT_TRUTH_INDEX, doctrine, or source files.

Next action:

- If expected: continue.
- If unclear: make a small read/report of changed files.
- If dangerous: stop and do not run more scripts.

### Git write command allowed

Meaning:

The target contains Git write commands and was explicitly allowed.

Default response:

REQUIRES_EXPLICIT_SAVE_OR_REPO_PERMISSION.

Required checks:

- The user intended a save route.
- -AllowGitWrites was used.
- Target only stages intended paths.
- Commit message is narrow.
- Final git status is clean or expected.
- Push is either skipped by default or explicitly requested.

Escalate when:

- Unexpected repo changes exist before staging.
- Script uses broad git add .
- Script uses reset, clean, checkout, rm, stash, rebase, or force push.
- V1.4 wrapper does not forward allow switches.

Next action:

- If save succeeded: record commit hash.
- If blocked: read the blocker before changing anything.
- If wrapper bug: run direct V1.3 or repair wrapper through a carded route.

### Git write command blocked

Meaning:

The target contains Git write commands but permission was not active.

Default response:

STOP_AND_READ_BLOCKER.

Required checks:

- Did user intend a save?
- Was -AllowGitWrites omitted?
- Was the wrapper expected to forward the flag?
- Is this a script that should be split into read phase and save phase?

Next action:

- Do not edit the script blindly.
- Read the Code Gate report blocker lines.
- If the user intended save and script is narrow, rerun with the correct allow switch.
- If V1.4 failed to forward, use V1.3 directly or repair V1.4 through proof.

### Return array wrapper

Meaning:

PowerShell shape may create type/shape confusion, especially with single items.

Default response:

EXPECTED_BUT_NOISY_PATTERN_SHAPE.

Preferred shape:

Use explicit arrays for collections.

Use ArrayList or list accumulation when needed.

Return deliberately.

Required checks:

- Did it cause a runtime error?
- Did the output shape change Count behavior?
- Did a single object become scalar unexpectedly?

Escalate when:

- Error says property Count cannot be found.
- A loop or judgment count depends on Count.
- A selection can return one item or no item.

Next action:

- If no failure: continue with watch.
- If runtime issue: patch to force array shape.

### Inline if subexpression

Meaning:

A dense inline expression may hide parser or shape problems.

Default response:

BLOCKER_ADJACENT_REVIEW.

Preferred shape:

Precompute variables before function calls.

Avoid dense inline conditional expressions in argument lists.

Required checks:

- Did Code Gate flag parser risk?
- Is the expression inside Add-Check or another dense call?
- Is there a colon after a variable reference?

Escalate when:

- Parser error appears.
- A variable reference with colon fails.
- The expression is in a save or process-control script.

Next action:

- Rewrite to precomputed variables before rerun.

### Dense Add-Check call

Meaning:

A compact check call may be hard to parse, debug, or trust.

Default response:

EXPECTED_BUT_NOISY_PATTERN_SHAPE or BLOCKER_ADJACENT_REVIEW depending on risk.

Preferred shape:

Set Ok, Verdict, Reason, and Evidence variables first.

Then call Add-Check with named parameters.

Next action:

- If read/report only and passed: continue with watch.
- If parser-adjacent or save/process-control script: refactor before running again.

### Network command blocked

Meaning:

The target tries to contact the network.

Default response:

STOP_AND_REQUIRE_EXPLICIT_NETWORK_PERMISSION.

Required checks:

- Is network access truly needed?
- Is the URL/domain known?
- Is the purpose read-only?
- Is any credential/token involved?

Next action:

- Do not rerun with -AllowNetwork until the user explicitly approves.
- Prefer local evidence first.

### Delete or move warning/blocker

Meaning:

The target can delete, move, rename, or relocate files.

Default response:

STOP_AND_REQUIRE_CUSTODY_PLAN.

Required checks:

- Exact source.
- Exact destination.
- Receipt path.
- No delete unless explicitly approved.
- Move-not-copy rule understood.
- Backup or hash proof when needed.

Next action:

- For route/porch cleanup, create a custody plan before action.
- For delete, stop unless the user explicitly approves.

### Parser error

Meaning:

The target did not parse.

Default response:

HARD_BLOCK.

Rule:

Parser fail means never run.

Next action:

- Read line and column.
- Patch parser shape only.
- Rerun Code Gate.
- Do not infer that the target's job ran.

### Target nonzero or runtime error

Meaning:

The target started but failed or returned nonzero.

Default response:

RUNTIME_REVIEW.

Required checks:

- Did output still produce a report?
- Was failure expected?
- Is there partial evidence?
- Is the failure from a known PowerShell shape problem?

Next action:

- Do not continue as if job passed.
- Read the target output.
- Create a narrow patch only after identifying the failure.

## Unknown Warning Rule

When a warning cannot be fully classified:

1. do not continue to broader work;
2. label it UNCLASSIFIED_REVIEW;
3. preserve the report path;
4. make the smallest useful next check;
5. route it to a warning evidence ledger soon.

Unknown does not mean panic.

Unknown means slow down, name it, and keep it from silently becoming live authority.

## Soon-Reach Rule

If a helper cannot solve or classify a warning immediately, it should still reach toward a safe next lane soon.

Allowed near-term reaches:

- latest Code Gate report read;
- warning title summary;
- blocker-line read;
- changed-file status;
- Git status short;
- receipt existence check;
- narrow patch planning card.

Blocked reaches:

- broad whole-house scan;
- direct save after unclear warning;
- process kill without stuck evidence;
- code reuse after warning;
- doctrine or active guide edit;
- deleting or moving files to make warnings disappear.

## Output Requirement For Future Warning Helpers

A warning helper should output:

- warning title;
- likely classification;
- confidence;
- why it thinks so;
- required checks;
- next safe action;
- stop condition;
- report path.

## Weak-PC Boundary

No broad scans by default.

Use recent reports only.

Prefer newest 5 to 10 reports.

Use small fixed target lists.

Avoid full repo hashing.

Avoid walking old legacy sheds unless explicitly selected.

## Final Gate Verdict

READY FOR NARROW LIVE USE AS A WARNING RESPONSE CARD.

Not doctrine.

Not a Code Gate policy change.

Not a replacement for user approval.

This card makes warning response explicit and safer.
