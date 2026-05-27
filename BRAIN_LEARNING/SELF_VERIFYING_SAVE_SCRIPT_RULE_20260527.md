# Self-Verifying Save Script Rule

Date: 20260527

## Status

Living process rule.

Not doctrine.
Not a new boss.
Not a new gate.

## Rule

Every local/Git save script must verify itself before it prints completion.

The user should not need to run a separate manual verifier just to know whether the save worked.

## Required shape

A save script must run:

1. preflight verifier;
2. action;
3. postflight verifier;
4. copy-back only if postflight passes.

## Required preflight

Before saving, prove:

- exact repo path;
- .git exists;
- source object exists when relevant;
- source hash captured when relevant;
- repo status is clean or dirty blocker is explicitly classified;
- target files are known.

## Required postflight

Before saying complete, prove:

- expected files exist;
- git add succeeded;
- commit succeeded;
- latest commit message matches expected save;
- push succeeded;
- HEAD matches origin branch;
- final git status is clean.

## Delivery surface rule

Prefer a saved .ps1 file over a giant pasted terminal block when the script is large enough that paste/parsing becomes the risk surface.

The verifier must live inside the script success path. A separate user-run verifier is not the normal proof path.

## Blocked

Blocked:

- printing SAVE COMPLETE without proof;
- relying on the user to run a separate verifier;
- assuming git native errors stop PowerShell automatically;
- giant pasted scripts when a file-run path is cleaner;
- completion language after parser failure;
- copy-back text that is only the printed code, not execution proof.

## Short form

No external trust. The script proves itself before it speaks.
