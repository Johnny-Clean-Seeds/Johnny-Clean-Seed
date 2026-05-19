# PowerShell Output Gap And Partial Paste Rule

Date: 2026-05-19.
State: active formatting / output-handling rule.
Authority: operating behavior rule, not doctrine install.
Starting base: main @ fb7fad0.

## Rule

Simple visual gaps help readability.

Blank line spacing is not a proof boundary.

Repeated PowerShell prompts after a finished command are not evidence of failure.

Do not use COPY BLOCK START / END marker text as the normal output separator.

## Pasteable Code

Only pasteable PowerShell belongs in PowerShell code blocks.

Explanatory text stays outside the code block.

Do not use large marker phrases to tell the user where proof starts or ends.

## Final Output Shape

Use compact, plainly labeled result lines:

- Saved clean: YES
- Custody status: CUSTODY PASS
- Current Mr.Kleen position: main @ hash
- Commit: hash message
- Remote origin/main: full hash
- Final git status: clean

Then use one visual gap before:

- Files changed:

Then use one visual gap before:

- Verdict:
- Next move:

## Partial Paste Handling

When the user pastes partial-looking output, do not immediately call it incomplete proof if it may simply be a split paste.

Wait for the remaining lines or ask for the rest only if needed.

Do not interrupt the user's reporting flow unless a real stop signal appears.

## Real Stop Signals

Interrupt only for actual stop conditions such as:

- PowerShell continuation prompt,
- wrong root,
- missing .git,
- failed guard,
- git nonzero,
- dangerous next action,
- success-after-error,
- evidence mismatch that affects the current claim.

## Why This Matters

The earlier repeated prompt lines helped the eye see separation, but relying on blank lines as proof boundaries caused confusion.

The right fix is readable output plus evidence-based judgment.

## Boundary

No doctrine install.
No active guide rewrite.
No runtime automation.
No new save tool.
No proof standard replacement.
