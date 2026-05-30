# Word Wash Proof Trial and Probe-Safe Route Map V1

Date: 2026-05-30
Status: SUPPORT MAP / NOT IMPLEMENTATION

## Route

Code Gate probe
-> no live task inputs
-> target PROBE_ONLY
-> exit 0
-> Code Gate can inspect safely

Real proof run
-> words/question/candidate/proof bridge
-> verification gate
-> final gate verdict
-> report write
-> reverse intake shell output

## V1.1 failure route

Code Gate probe
-> empty inputs
-> parameter binding crash
-> target nonzero
-> dirty probe behavior

## V1.2 repair route

Code Gate probe
-> empty inputs
-> PROBE_ONLY
-> clean exit 0

Real run
-> PASS_PROVEN or BLOCKED_* verdict
-> report path/hash
-> comment-prefixed shell output

## Rule

Probe-safe does not mean proof-pass.
Probe-safe means Code Gate can run the target without live inputs and receive clean inspection output.
