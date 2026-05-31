# Know, Do Not Think Lower-Layer Diagnosis Rule

Date: 20260531  
Status: BRAIN LEARNING / OPERATING RULE / NOT DOCTRINE  
WorkKey: CODING-ROOM-KNOW-DONT-THINK-LOWER-LAYER-DIAGNOSIS-20260531

## Rule

Do not descend to a lower-layer or root-cause repair merely because it feels plausible.

Before treating an issue as lower-layer, prove it with evidence:

1. Check or clear the upper-layer object first.
2. Identify the exact failing coordinate: command, script, line, field, file, or receipt row.
3. Resolve contradictory evidence before repair.
4. Show why the proposed lower-layer cause explains the observed failure better than a surface explanation.
5. Rerun the same chain after repair and require the same proof object to pass.

If those conditions are not met, stop and gather more proof instead of building a speculative lower-layer repair.

## Current event proof

V1 Save-Candidate Packet blocked at 11/12 proof rows.

A direct search proved the missing ghost/manual-classification receipt existed under the parent READ_REPORTS root, not under the narrower CODING_ROOM branch. That made the V1 block a search-scope problem, not a missing-proof problem.

V1.1 then failed at the exact coordinate:

`WRITE_CODING_ROOM_SAVE_CANDIDATE_PACKET_V1_1_UNIQUE_20260531_0635.ps1:194`

Failure:

`Argument types do not match`

That coordinate was below the proof layer: collection/count mechanics. V1.2 repaired that mechanics layer and reran the same candidate chain to completion.

## Confirmed result

V1.2 result:

- TotalProofRows: 12
- FoundProofRows: 12
- MissingRequiredProofRows: 0
- CandidateVerdict: READY_FOR_SAVE_ROOM_REVIEW

Save Room Decision Packet result:

- PassedChecks: 10
- FailedChecks: 0
- SaveRoomDecision: APPROVED_FOR_LOCK_SAVE_SCRIPT_DRAFT

## Code Gate V1 save-script repair

The first lock-save draft failed Code Gate before target execution. The proved blockers were parser errors caused by PowerShell here-string termination/quoting structure and a cleanup removal command in the probe path.

V1.1 replaces here-string-generated content with line-array generated content and removes the probe cleanup removal pattern. V1.2 repairs Git single-line output capture so a one-line git result is not indexed as a character before Trim.

## V1.1 direct-run repair

After V1.1 passed Code Gate, direct execution with -AllowGitWrites failed before file writes at the Git branch read line.

Failure:

`Method invocation failed because [System.Char] does not contain a method named Trim.`

That proved a Git-output wrapper problem: a one-line git result was being indexed before array capture, producing a character instead of a string. V1.2 uses Invoke-GitFirstLineStrict to capture git output as an array first, then trim the first string line.

## Boundary

This rule does not authorize doctrine promotion, ACTIVE_GUIDES rewrite, CURRENT_TRUTH_INDEX rewrite, broad refactor, automation, watcher, movement, removal, or speculative root-cause claims.
