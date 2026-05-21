# File-First Artifact With Launcher Balance Rule — 20260521

## Status

ACTIVE PROVISIONAL RULE / SAVED AFTER OVERCORRECTION REPAIR

## Original Error

Sending duplicate artifacts for one file, such as a .ps1 plus a wrapper .zip, creates unnecessary bloat and confusion.

## Overcorrection

Stopping the launcher command created the opposite failure because the user still needed the exact command to run the downloaded artifact.

## Balanced Rule

One File = One Download means no duplicate wrapper artifact for a single file.

It does not mean omit the launcher command.

Correct delivery:

1. One artifact link.
2. One clean launcher block when the user must run or use the artifact.

## Clean Copy Block Requirement

The launcher copy block must contain only the exact runnable command.

No explanation inside the block.

No extra chat text in the block.

Use the actual known file location, not assumed Downloads, when the user has shown or stated a different folder.
