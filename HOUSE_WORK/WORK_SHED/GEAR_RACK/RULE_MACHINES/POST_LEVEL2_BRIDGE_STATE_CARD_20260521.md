# Post-Level2 Bridge State Card — 20260521

## Current Bridge Power

Approved childjob routing through Level 2.

## Working Route

DROPZONE -> watcher -> dispatcher -> Level runner -> OUTBOX receipt

## Proved

Level 0.
Level 1.
Watcher drop.
Watcher liveness.
Level 2 approved-helper.

## Blocked

Level 3.
Assistant-direct local execution.
Arbitrary shell.
Raw shell.
Git through Child Shell.
Repo writes through Child Shell.

## Stale Rule Update

When a proof advances a selected-next item, patch the stale queue/rule note and keep proof receipts immutable.
