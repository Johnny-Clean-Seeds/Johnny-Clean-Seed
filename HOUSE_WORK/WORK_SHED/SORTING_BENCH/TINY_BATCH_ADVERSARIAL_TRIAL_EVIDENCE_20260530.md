# Tiny Batch Adversarial Trial Evidence

Date: 2026-05-30
Status: ADVERSARIAL TINY BATCH TRIAL EVIDENCE / SUPPORT ONLY / NOT FULL BATCH

## Trial report

Path:
C:\Users\13527\Desktop\123\_MISC_DRAWER\READ_REPORTS\TINY_BATCH_ADVERSARIAL_TRIAL_V1_20260530_055029.md

File:
TINY_BATCH_ADVERSARIAL_TRIAL_V1_20260530_055029.md

SHA256:
0B2E9B556388E9CEC433C7E214F6E525FF0B05BFEE5DDAB4ED5D8E0688F6DB08

HashMatchesKnownFromChat:
True

Evidence verdict:
ADVERSARIAL_TINY_BATCH_TRIAL_PASS

## Trial result

Final trial verdict:
BATCH_PASS_ADVERSARIAL_TINY_TRIAL

MaxRows:
3

ActualRows:
3

UnexpectedRows:
0

MissingSchemaFields:
0

## Row results

ROW001_CONTROL_BOUNDARY_LIMIT:
ROW_PASS
selected=limit
selection=PASS_SELECTED
verifier=PASS_PROVEN

ROW002_CIRCULAR_REJECT:
ROW_EXPECTED_REJECT
selected=[none]
selection=BLOCKED_NO_CLEAN_SELECTION
verifier=VERIFIER_NOT_RUN_SELECTION_BLOCKED

ROW003_WORDY_FAKE_REJECT:
ROW_EXPECTED_REJECT
selected=[none]
selection=BLOCKED_NO_CLEAN_SELECTION
verifier=VERIFIER_NOT_RUN_SELECTION_BLOCKED

## Meaning

The adversarial tiny batch passed at the allowed scope.

This proves:
- a control pass row still passes;
- a circular bridge pressure row rejects cleanly;
- a wordy function-stuffing pressure row rejects cleanly;
- expected rejects do not become global failure;
- selection blocks before verifier;
- verifier does not run after blocked selection;
- row-level verdicts remain visible;
- no unexpected rows appeared;
- no schema fields were missing.

This does not prove:
- full batch;
- autonomous candidate generation;
- implementation;
- watcher;
- automation;
- Whirlpool.

## Command-glue note

A pasted command first glued -RunTrial and pwsh into -RunTrialpwsh, which produced a parameter error before the trial ran.

That was not trial evidence.
The clean evidence is the later successful real run:
BATCH_PASS_ADVERSARIAL_TINY_TRIAL.
