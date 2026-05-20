# JOB 00 - STALE CHECKER REVIEW

Packet base HEAD: `e9bc566bb432817f266e6604595172f5e95afb21`

Stale checker passed: yes.

Files read:
- `STALE_CHECKER_001.ps1`
- `RUN_STALE_CHECKER_FROM_HERE.ps1`
- `MULE_READ_FIRST.md`
- `OUTPUT_CONTRACT.md`
- `STATE_SNAPSHOT` files
- `PACKET_FILE_HASHES.txt`

## Finding

EVIDENCE:
`STALE_CHECKER_001.ps1` checks:

- branch is `main`;
- `HEAD` equals `origin/main`;
- current HEAD equals packet base HEAD;
- `git status --short` is clean;
- selected required repo files exist and are nonempty;
- stale result is written into `MULE_OUTPUT_DUMP_ONLY`.

EVIDENCE:
The checker passed for this packet and wrote `STALE_CHECK_RESULT_20260520_051938.txt`.

INFERENCE:
The checker is strong enough to prevent the worst stale-packet error: working from a packet whose base commit no longer matches current synced repo state.

## Missing Stale Conditions

ADAPT:
The current checker does not verify:

- packet job files still match `PACKET_FILE_HASHES.txt`;
- `STATE_SNAPSHOT` files match current repo files or intentionally remain frozen snapshot evidence;
- `OUTPUT_CONTRACT.md`, `MULE_READ_FIRST.md`, `MANIFEST.md`, and all required `JOBS` files are present and nonempty;
- dump folder contains only allowed output patterns or previous outputs are clearly old;
- packet root is the active working directory;
- the stale result filename that downstream intake should read;
- whether a previous stale result in the dump conflicts with the newest result.

## Should This Become Reusable?

Recommendation:
ADAPT LATER.

This is a good reusable local-mule skeleton candidate, but do not promote it from one pass. First use it through return intake, then improve the checker as `STALE_CHECKER_002` candidate only if packet reuse continues.

## Smallest Safe Improvement

Candidate only:

Add a packet self-integrity section to the stale checker:

1. Read `PACKET_FILE_HASHES.txt`.
2. Verify each listed packet file exists.
3. Verify each listed packet file hash matches before work starts, excluding newly produced dump outputs.
4. Verify all required job files exist.
5. Write a deterministic `STALE_CHECK_RESULT_LATEST.txt` plus timestamped copy.

## Proof Needed

A later packet should prove the improved checker catches a deliberately missing job file or mismatched packet hash while still passing a valid clean packet.

## Boundary

No repo edit. No checker promotion. No optional candidate script was created.

Disposition:
ADAPT.

