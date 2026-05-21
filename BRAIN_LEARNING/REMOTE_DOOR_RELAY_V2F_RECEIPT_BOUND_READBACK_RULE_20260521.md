# Remote Door Relay V2F Receipt-Bound Readback Rule

Date: 2026-05-21

## Rule

Remote Door final proof must not rely only on the general latest-status mouth when an exact probe created an exact Child Shell job.

When a V2E print probe is accepted, the response must include a job-bound readback URL:

`/door/v2/readback/<job_id>`

## Required Behavior

- `/door/v2/status` may remain the compact general mouth.
- `/door/v2/probe/<print>` must keep one-use print rotation intact.
- `/door/v2/probe` and `/door/v2/probe_async` must remain available as legacy rollback lanes.
- `/door/v2/readback/<job_id>` must check only the matching job, receipt, processed, and rejected paths for that exact job id.
- Readback must not use latest status as proof.
- Readback may accept a cache-buster query such as `?fresh=serial`, but the cache-buster is not the proof.

## Readback Verdicts

- `PASS / RECEIPT FOUND`
- `WAITING / JOB CREATED BUT RECEIPT NOT FOUND YET`
- `FAIL / JOB REJECTED`
- `UNKNOWN / JOB NOT FOUND`

## Boundary

This rule does not add arbitrary shell, raw command, broad crawl, delete, repo write through V2, git through V2, Level 2, Level 3, ACTIVE_GUIDES rewrite, CURRENT_TRUTH_INDEX rewrite, doctrine rewrite, permission expansion, or junction/symlink teleporter.
