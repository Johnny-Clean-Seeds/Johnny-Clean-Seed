# Daily House-Walk Digest Logs

Date: 2026-05-19.
State: daily log lane index.
Authority: support index only.

## Rule

At least one house-walk digest should exist per day.

The assistant should only self-initiate one daily digest around the 8 AM window if no near-8 digest has already been done.

More than one digest per day is allowed when:

- the user asks,
- major state changes happen,
- deep scan results land,
- fog appears,
- custody risk appears,
- house load changes.

## No Timer

This lane does not use timers.

The local brain gate script checks state only when invoked:

- HOUSE_WORK/TOOLS/Invoke-DailyHouseWalkDigestGate.ps1

## Daily Logs

Daily logs live here:

- HOUSE_WORK/DAILY_LOGS/HOUSE_WALK_DIGESTS/

## Digest Status Key

Near-8 Digest: YES

Means the daily self-initiation requirement is satisfied for that date.

Near-8 Digest: NO

Means the log is still valid as an extra/user/event digest, but the assistant may still self-initiate one near-8 digest if none exists.
