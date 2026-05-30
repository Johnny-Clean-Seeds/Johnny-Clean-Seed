# Helper Save Content Validation and Issue Learning Rule

Date: 2026-05-29
Status: ACTIVE SUPPORT RULE CANDIDATE
Lane: Clean Seed / Mr.Kleen helper refinery and save-script safety

## Trigger

When a helper, save script, viewer lifecycle script, Code Gate route, or toolbox step fails during project work, treat the issue as learning material, not dead friction.

## Rule

Every project-relevant issue should be converted into a power-play record when it exposes a reusable fix.

The file record should capture:

- the issue trigger;
- the failed command or failed proof point;
- the observed error text;
- the root cause as narrowly as possible;
- the fix shape;
- the prevention gate;
- the proof that the fix worked;
- the boundary of what was and was not changed.

## Save-Script Content Gate

Before a helper writes planned project artifacts, it must validate the content object for each planned file.

Required checks:

- content is not null;
- content is not empty or whitespace when the artifact is meant to carry a rule/card/receipt;
- unresolved placeholders are not left behind;
- write path is exact and expected;
- hash is captured after write;
- partial prior writes are either recovered explicitly by exact path or blocked.

## Markdown / Here-String Safety

For long markdown content inside PowerShell scripts, prefer single-quoted literal here-strings plus explicit placeholder replacement. This avoids accidental variable expansion and escape-character behavior while still allowing controlled dynamic values.

## Blocked Claims

Do not call a failed helper route clean just because the parser passed.
Do not treat a binder error, empty-content write, false placement fail, or viewer-open-only event as a successful save/proof.
Do not leave the learning only in chat when it applies to the house.

## Current Failure Family

The Freshen' up V1 save script reached write mode and failed while writing the fit card because the content argument arrived as an empty string. The repair is to validate planned content before writes, use safer literal text construction, recover only expected partial paths, and save this issue as a reusable helper-learning rule.