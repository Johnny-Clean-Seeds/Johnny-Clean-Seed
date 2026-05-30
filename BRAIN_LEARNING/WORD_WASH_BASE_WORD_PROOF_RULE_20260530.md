# Word Wash Base-Word Proof Rule

Date: 2026-05-30
Status: SUPPORT RULE / WORD-WASH OUTPUT PROOF
Authority: not doctrine, not ACTIVE_GUIDES, not CURRENT_TRUTH_INDEX

## Focal rule

When a word, phrase, or question enters the word-wash machine, the final shell output may be compressed to one base word.

That base word must make semantic sense.

The machine must always prove how it got there.

If the output is obvious, it still records the proof path in the report.
If the output is surprising, it must prove the bridge from input to output.
If it cannot prove the bridge, the output is blocked or marked unproven.

## Example

Input:
awareness

Question:
what does awareness mean?

Muted gate run:
only final output gate speaks to chat.

Final base word:
knowing

Why this passes:
awareness means a state of knowing, noticing, perceiving, or being conscious of something.

## Bad example

Input:
awareness

Output:
tigershark

Verdict:
BLOCKED_UNPROVEN unless the machine can show a real bridge.

Required proof:
awareness -> symbol/context/source/gate reasoning -> tigershark.

If that bridge is not present, the output is dirty.

## Required proof path

Every base-word output must keep a proof trace in the report:

InputText
InputHash
StartingQuestion
BaseWordCandidate
GateSequence
MutedGates
FinalSpeakingGate
SemanticBridge
AnchorEvidence
RejectedCandidates
WhyThisWord
WhyNotRandom
ConfidenceLabel
BlockedIfUnproven
ReportPath
ReportHash

## Gate behavior

### Intake Gate

Receives words from shell or file.
Names the chew object.
Hashes the input.
Identifies the starting question.

### Word Wash Gate

Chews the meaning.
May use house anchors, dictionaries, source files, or known semantic relations if allowed by the run.
Must not hallucinate a jump.

### Anchor Gate

Checks whether the answer has relation to anchors, rule maps, or source material if a source-bound run is requested.

### Final Gate

Cleans the gate output.
Selects one base word.
Requires proof trace.
Blocks random/unbridged output.

### Reverse Intake Gate

Sends the final base word to the shell.
The report keeps the proof.

## Output contract

Shell output can be compact:

BASE_WORD: knowing

Report output must include the proof path.

## Hard blocks

No random word output.
No unproven surprising output.
No silent leap.
No "because the model said so."
No base word without report trace.
No shell-only answer when running the file tool.
No report-only answer without the shell base word.
No hiding rejected candidates when they explain why the final word was chosen.

## Labels

PASS:
base word makes sense and proof bridge is present.

PASS_WITH_WATCH:
base word is plausible but proof is thin or source is not strong.

BLOCKED_UNPROVEN:
base word cannot prove its path.

DIRTY_RANDOM:
output appears unrelated and has no proof bridge.

NEEDS_SOURCE:
question requires source material or web/local reference not available.

## Living phrase

The gates may chew. The final gate must clean. The reverse intake gate must speak one base word. The report must prove the path.
