# PowerShell False-Pass Awareness Power Play

Date: 2026-05-19.
State: failure capture / power play.
Authority: Work Shed learning capture.
Starting base: main @ e21d1bf.

## Failure

A delivery-format preference was wrongly escalated into a repo/git save.

The generated interactive PowerShell block was pasted while the shell was standing outside Mr.Kleen.

The repo guard failed, git commands failed with exit code 128, required variables were unset, and later pasted lines still printed fake success text including Saved clean and CUSTODY PASS.

## Root Causes

- wrong lane selection,
- delivery preference treated as house save,
- giant interactive paste trusted as execution unit,
- guard failure did not stop later pasted lines,
- final success output was not gated by audited facts,
- failure was not captured immediately until user challenged it.

## Damage

Outside-repo junk was created under the user profile and then cleaned.

Mr.Kleen remained clean at main @ e21d1bf after cleanup proof.

## Power Play

Any future guard failure, wrong directory, git nonzero, unset required variable, PowerShell continuation prompt, or success-after-error output triggers:

FOG / CUSTODY FAIL: STOP

Required response:

- stop forward work,
- do not print success,
- do not create more files,
- capture visible evidence,
- inspect location and repo state,
- clean contamination first if needed,
- restart shell/session if paste state may be dirty,
- resume only after state is known.

## Transfer

This does not apply only to PowerShell.

The same awareness pattern must apply across chat, prompts, repo, web, memory, cleanup, proof, outside-review intake, and design decisions.

## Boundary

No doctrine install.
No active guide rewrite.
No runtime automation.
No tool implementation.
