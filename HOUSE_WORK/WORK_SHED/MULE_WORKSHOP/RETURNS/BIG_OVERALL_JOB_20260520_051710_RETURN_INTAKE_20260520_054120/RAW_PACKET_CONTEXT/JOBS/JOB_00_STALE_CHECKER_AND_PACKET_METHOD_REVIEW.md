# JOB 00 - Stale Checker And Packet Method Review

Mission: Review this packet method and stale checker. If the method is outdated, propose a better local-only packet/stale-check workflow.

Read:
- STALE_CHECKER_001.ps1
- RUN_STALE_CHECKER_FROM_HERE.ps1
- MULE_READ_FIRST.md
- OUTPUT_CONTRACT.md
- STATE_SNAPSHOT files

Questions:
- Does the stale checker catch wrong HEAD, dirty repo, missing required files, and stale packet state?
- What stale conditions are missing?
- Should this become a reusable local mule packet skeleton later?
- What is the smallest safe improvement?

Output:
MULE_OUTPUT_DUMP_ONLY\JOB_00_STALE_CHECKER_REVIEW.md

Optional candidate output:
MULE_OUTPUT_DUMP_ONLY\STALE_CHECKER_002_CANDIDATE.ps1

Boundary:
Do not edit repo files. Do not promote checker.
