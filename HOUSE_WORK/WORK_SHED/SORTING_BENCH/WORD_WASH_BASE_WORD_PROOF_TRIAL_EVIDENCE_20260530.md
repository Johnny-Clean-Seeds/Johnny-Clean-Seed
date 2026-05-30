# Word Wash Base-Word Proof Trial Evidence

Date: 2026-05-30
Status: TRIAL EVIDENCE / READ REPORT ONLY / NOT IMPLEMENTATION

## Trial report

Path:
C:\Users\13527\Desktop\123\_MISC_DRAWER\READ_REPORTS\WORD_WASH_BASE_WORD_PROOF_TRIAL_20260530_041238.md

File:
WORD_WASH_BASE_WORD_PROOF_TRIAL_20260530_041238.md

SHA256:
082DBCADCA34B6CDF7E775947A40965E9AF3E8EF47715A1429CB0F29682E9C41

Evidence verdict:
TRIAL_EVIDENCE_PASS

## Observed sequence

V1.1:
Code Gate parser PASS.
Target run failed nonzero because empty input caused PowerShell parameter binding failure.
Powerplay learning event exposed.

V1.2:
Code Gate parser PASS.
No-input target run returned PROBE_ONLY with exit code 0.
Direct real run returned PASS_PROVEN.
Reverse Intake emitted BASE_WORD: knowing.
Report path and report hash were printed.

## Proven real-run output

Input:
awareness

Question:
what does awareness mean?

Candidate base word:
knowing

Proof bridge:
awareness -> aware state -> noticing/perceiving/conscious knowing -> knowing

Final gate verdict:
PASS_PROVEN

Reverse Intake shell output:
BASE_WORD: knowing

## Meaning

The base-word proof rule works when the candidate and proof bridge are supplied.

The V1.2 target shape is cleaner than V1.1 because the probe path does not crash.

This remains trial evidence only.
It does not implement a live washer.
