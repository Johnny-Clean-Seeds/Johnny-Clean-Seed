# Helper Confidence Ladder and Source-to-House File Logic Rule â€” 20260528

Status: BRAIN_LEARNING / helper-file-logic rule candidate  
Authority: working project logic after local save proof; not doctrine; not ACTIVE_GUIDES; not CURRENT_TRUTH_INDEX  
Parent boss: helpers doing context work without dumping raw source into chat  
Boundary: helper output must be proven before it is trusted

## Rule

When a helper, script, packet, or source-intake file is built, the assistant must label the proof state honestly:

- **BUILT** means the artifact was generated.
- **PACKAGED** means the files were gathered into a packet or zip.
- **HASHED** means hashes were written for the packet contents.
- **DESIGNED** means boundaries and route were intentionally shaped.
- **CODE-GATED** means the helper passed the local Code Gate on the user's machine.
- **LIVE-RUN** means the helper ran against the real target object.
- **OUTPUT-JUDGED** means the produced files were reviewed for usefulness, gaps, overcollection, and fit.
- **PLACED** means the output was routed into the house or parked with lane/custody.
- **PROVEN** means local proof, useful output, and route custody all passed.

A helper is not proven merely because the assistant created it.

## Moving forward

For now on, when I make helper files for this project, I will separate **built**, **checked**, and **proven** instead of implying that a clean-looking packet is clean in the house sense.

This is better because it prevents false closure, prevents missing-context claims, and keeps helper work tied to local proof instead of assistant confidence.

I will start doing this before the next helper/action packet. I will apply the fix, send the working file or save packet, run or request Code Gate proof, lock/save only after proof, then return to the active work.

## Source-to-house intake logic

Raw source files should not be repeatedly dumped into chat when a local helper can reduce them.

The clean pattern is:

```text
exact source folder
-> manifest/hash
-> chunk ledger
-> dissect extract
-> house digest
-> candidate rules/patterns
-> fit decision
-> receipt
-> assistant reviews compact handoff
```

The helper does not become the judge. It prepares source custody and reduces chat weight.

## Required helper output contract

A source-intake helper should write, at minimum:

- `SOURCE_MANIFEST.md`
- `SOURCE_CHUNKS_LEDGER.csv`
- `DISSECT_EXTRACT.md`
- `HOUSE_CONTEXT_DIGEST_FOR_CHAT.md`
- `CANDIDATE_RULES_AND_PATTERNS.md`
- `FIT_DECISION_AND_NEXT_ACTION.md`
- `RECEIPT_SHA256.txt`

The assistant should ask for the digest/candidate/fit files first, not the raw source pile.

## Anti-pattern blocked

Do not repeat the broad-search failure.

Blocked patterns:

- broad Desktop scan when an exact source folder exists;
- broad root search using noisy terms;
- collecting tool noise when the task needs a rare source word;
- calling a candidate helper "clean" before Code Gate and live run;
- calling source output "house logic" before fit is judged;
- promoting a pattern to doctrine from a single helper run;
- staging raw transcripts into Git by default.

## Confidence ladder for helper reports

When reporting helper status, use this exact ladder:

```text
BUILT: yes/no
PACKAGED: yes/no
HASHED: yes/no
CODE-GATED: yes/no
LIVE-RUN: yes/no
OUTPUT-JUDGED: yes/no
PLACED: yes/no
PROVEN: yes/no
```

If any lower proof step is missing, say so directly.

## Helper-building route

1. Name the active object.
2. State the hard boundary.
3. Build the smallest helper that proves the road.
4. Package with manifest.
5. Code Gate locally.
6. Live-run on exact source.
7. Judge output.
8. Route output into house, parking, TODO, or source ore.
9. Save only what earned custody.
10. Keep raw source local unless explicitly selected for house intake.

## Fit

This rule belongs in helper-file logic because the project is moving toward helpers doing local context work. The assistant must know what helper output can and cannot prove.

## Boundary

This is not final doctrine.  
This does not install automation.  
This does not grant helpers write authority by default.  
This does not make generated packets trusted.  
This teaches proof language and helper intake shape.
