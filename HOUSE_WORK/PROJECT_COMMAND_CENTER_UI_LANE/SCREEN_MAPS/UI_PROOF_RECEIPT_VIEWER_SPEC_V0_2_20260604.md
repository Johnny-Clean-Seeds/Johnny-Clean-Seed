# UI Proof/Receipt Viewer Spec V0.2

Date: 2026-06-04
Status: CANDIDATE VIEWER SPEC / DESIGN ONLY / NOT IMPLEMENTATION
WorkKey: UI-PROOF-RECEIPT-VIEWER-SPEC-V0-2-20260604

## Purpose

The proof viewer lets review verify a claim by paths, hashes, verdicts, and boundaries without rebuilding the whole job or dumping raw files.

## Required Receipt Card

| Section | Required content |
|---|---|
| Claim | one-line claim being proved |
| Source | source path and source hash |
| Manifest | manifest path and SHA256 |
| Hashes | changed/created file hashes or manifest pointer |
| Before/After | branch, HEAD, origin/main, root status |
| Staged Set | name-status only, not full diff |
| Rollback | rollback manifest or no-mutation reason |
| Verdict Lines | exact final sentinel lines |
| Boundaries | target/helper, watcher, automation, protected-path results |
| DoesNotProve | what the receipt cannot prove |
| Next Legal Action | one concrete next action |

## Viewer Modes

| Mode | Shows | Hides unless requested |
|---|---|---|
| Compact | paths, hashes, verdicts, status | raw source body |
| Review | compact plus selected DoesNotProve and blockers | full diffs |
| Audit | manifest rows and hash table | private/local-only content |
| StopLine | current blocker and exact ask | unrelated history |

## Overclaim Checks

- No claim that a candidate is active.
- No claim that parking is closure.
- No claim that a source is authority.
- No claim that commit/push happened without HEAD/origin proof.
- No claim that OpenAI, external tools, or helper scripts received or used an idea.
