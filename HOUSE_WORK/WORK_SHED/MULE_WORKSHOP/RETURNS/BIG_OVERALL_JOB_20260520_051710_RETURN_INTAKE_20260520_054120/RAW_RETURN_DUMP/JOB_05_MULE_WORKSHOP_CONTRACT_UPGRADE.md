# JOB 05 - MULE WORKSHOP CONTRACT UPGRADE

Packet base HEAD: `e9bc566bb432817f266e6604595172f5e95afb21`

Stale checker passed: yes.

Files read:
- `MULE_READ_FIRST.md`
- `OUTPUT_CONTRACT.md`
- `MANIFEST.md`
- `PACKET_FILE_HASHES.txt`
- `STALE_CHECKER_001.ps1`
- `RUN_STALE_CHECKER_FROM_HERE.ps1`
- `MULE_OUTPUT_DUMP_ONLY\RETURN_MANIFEST_TEMPLATE.md`
- `JOBS` files

## Finding

EVIDENCE:
The current mule packet already has the strongest safety elements: dump-only output, ordered jobs, stale checker first, no direct repo edits, no commit/push, output contract, and stop-if-stale behavior.

INFERENCE:
The contract is good enough to use. It is not outdated, but it is incomplete as a reusable skeleton because packet self-integrity is not fully checked and return intake rules are only implicit.

## Reusable Local-Only Mule Contract V2 Candidate

ADAPT LATER:

1. Packet root contains:
   - `MULE_READ_FIRST.md`
   - `OUTPUT_CONTRACT.md`
   - `MANIFEST.md`
   - `PACKET_FILE_HASHES.txt`
   - `STALE_CHECKER.ps1`
   - `STATE_SNAPSHOT`
   - `JOBS`
   - `MULE_OUTPUT_DUMP_ONLY`

2. First action:
   - run stale checker;
   - stop on stale/blocked;
   - write only `STALE_BLOCKED_REPORT.md` if stale.

3. Stale checker must verify:
   - branch;
   - `HEAD == origin/main`;
   - expected packet base HEAD;
   - clean repo status;
   - required repo files exist and are nonempty;
   - packet files match `PACKET_FILE_HASHES.txt`;
   - all job files exist;
   - output dump exists.

4. Job order:
   - numeric only;
   - no skipping without blocked reason.

5. Output contract:
   - return manifest;
   - executive summary;
   - disposition matrix;
   - stale result copy/summary;
   - one job output per job;
   - next action recommendation.

6. Return intake gate:
   - assistant/user reads manifest first;
   - verify required files, hashes, readability, bad characters, and placeholders;
   - classify each recommendation APPLY/ADAPT/PARK/REJECT/NEEDS PROOF;
   - no house file changes until separately selected.

## Smallest Safe Upgrade

Add packet hash verification and a deterministic `STALE_CHECK_RESULT_LATEST.txt` to the next packet skeleton.

Do not build a standing mule dashboard or repository automation.

## Proof Needed

A future mule packet uses V2 and catches a missing job file or hash mismatch before any job work.

## Boundary

No optional `MULE_WORKSHOP_CONTRACT_V2_CANDIDATE.md` was created as a separate file. This job output contains the candidate design only.

Recommendation:
ADAPT.

Disposition:
ADAPT.

