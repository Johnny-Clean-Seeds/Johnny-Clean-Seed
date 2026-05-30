# Word Wash Base-Word Proof Route Map V1

Date: 2026-05-30
Status: SUPPORT MAP / NOT IMPLEMENTATION

## Route

Shell/File Words
-> Intake Gate
-> Word Wash Gate
-> Anchor Gate
-> Final Gate
-> Reverse Intake Gate
-> Shell Base Word

## Report route

Each gate may speak internally.
Final Gate cleans the gate speech.
Reverse Intake Gate emits one base word to shell.
Report preserves the proof trace.

## Proof route

InputText
-> InputHash
-> StartingQuestion
-> CandidateWords
-> RejectedCandidates
-> SemanticBridge
-> FinalBaseWord
-> WhyThisWord
-> WhyNotRandom
-> Verdict

## Block route

If FinalBaseWord has no proof bridge:
BLOCKED_UNPROVEN.

If FinalBaseWord appears unrelated:
DIRTY_RANDOM unless proof bridge exists.

If source is required but missing:
NEEDS_SOURCE.

## Clean route

A clean base word must be:

related to the input;
answering the starting question;
defensible by a semantic bridge;
recorded in the report;
emitted to shell by Reverse Intake Gate.
