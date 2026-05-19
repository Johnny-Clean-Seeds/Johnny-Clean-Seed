# Aha Origin Tagging Bitstring Candidate

Status: Soft Suit candidate
Date: 2026-05-19

Purpose:
Use a tiny bitstring-style origin tag to help the assistant label where an idea came from before using "aha."

This is not doctrine.
This is not a full bitstring system.
This is a small candidate lens.

Problem:
The assistant can accidentally say "aha" for a user-stated idea. That weakens the shared discovery feeling.

Candidate origin states:

00 = USER-STATED
The user clearly said the idea.
Assistant should not claim aha.
Action: catch, sharpen, place.

01 = USER-EXPOSED
The user said something raw/foggy that exposed a hidden pattern.
Assistant may say:
"Your line exposed the pattern."
Aha may be used only if the assistant then names a genuinely new fix/gap.

10 = ASSISTANT-INFERRED
The assistant inferred a pattern from the user's material and the current build.
Aha is allowed if the fix was not already clearly stated.

11 = ASSISTANT-ORIGINATED
The assistant spotted a missing rule/tool/helper/gap in the build independently.
Aha is allowed.

Use test:
Before saying "aha," silently tag the idea origin.

If tag = 00:
No aha.

If tag = 01:
Credit the user's line first.

If tag = 10 or 11:
Aha may be used if the fix is real and useful.

Risk:
Do not make this mechanical or stiff.
The tag is a lens, not a script.

Proof of usefulness:
This candidate works if it helps the assistant preserve the real aha feeling and avoids fake-aha restatements.

Next test:
Use this lens during the bitstring review/sorting work.
