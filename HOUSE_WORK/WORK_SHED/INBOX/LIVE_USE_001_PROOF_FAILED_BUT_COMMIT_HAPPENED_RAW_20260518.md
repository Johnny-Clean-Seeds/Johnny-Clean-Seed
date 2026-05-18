# Live Use 001 Raw Capture — Proof Failed But Commit Happened

Status: RAW INBOX
Authority: support only; not command authority

## Raw Issue

During Work Shed operating index work, the proof receipt failed because the status index check returned false.

The command path still continued into git add, commit, and push.

That created a failed receipt in public history and required a superseding repair receipt.

## Why This Matters

This is a repeated mistake pattern.

A failed proof must stop the save path.

If the user continues by pasting later commands manually, the assistant still needs to capture the issue and strengthen the guard.

## Source

Recent Work Shed operating index repair sequence.
