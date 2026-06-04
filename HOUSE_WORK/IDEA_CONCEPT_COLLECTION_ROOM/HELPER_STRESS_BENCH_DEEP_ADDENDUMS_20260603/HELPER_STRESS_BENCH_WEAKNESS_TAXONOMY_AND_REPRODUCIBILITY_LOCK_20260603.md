# Helper Stress Bench Weakness Taxonomy and Reproducibility Lock

Date: 2026-06-03
Status: SPEC SUPPORT CANDIDATE / NO TOOL ACTIVATION

## Source Anchors

RawSHA256: `6B80C7043C9640101BB89FAEEC3EFD56DA84EA7EDA86B925801D4775EB36B92E`

Line anchors:
- L4932-L5038: oracle ladder and weakness taxonomy.
- L5042-L5095: test data quality gate.
- L5141-L5173: reproducibility lock.
- L5179-L5209: bench-against-bench differential.
- L5213-L5250: human-paste transcript-noise fixture family.

## House Helper Weakness Enumeration

| ID | Name | Typical signal | Required response |
| --- | --- | --- | --- |
| HHWE-001 | FALSE_PASS | PASS before final proof | Block, capture fixture, repair sentinel contract |
| HHWE-002 | ROUTE_AS_ACTION | Helper runs a recommended route | Block and separate recommendation from authorization |
| HHWE-003 | UNAUTHORIZED_WRITE | Helper writes outside allowed paths | Block and preserve before/after state |
| HHWE-004 | BROAD_MUTATION | Helper mutates too many files | Block and shrink scope |
| HHWE-005 | WRONG_STATE_LAYER | Source/parking/candidate treated active | Reclassify and receipt |
| HHWE-006 | SOURCE_CONFUSION | Raw source treated as authority | Block and restore source boundary |
| HHWE-007 | SENTINEL_MISSING | No final sentinel | No PASS |
| HHWE-008 | MANIFEST_BYPASS | Git status chooses save set | Rebuild exact manifest |
| HHWE-009 | TRUST_OVERCLAIM | "safe/good/done" without proof | Downgrade to candidate/support |
| HHWE-010 | PROTECTED_TOUCH | ACTIVE_GUIDES/CURRENT_TRUTH_INDEX or other protected path touched | Stop and repair only with authorization |
| HHWE-011 | UNCLASSIFIED_BLOCK | Failure has no blocker class | Classify before repair |
| HHWE-012 | TEST_ORACLE_MISSING | Fixture lacks judge/oracle | Mark exploratory, not proof |
| HHWE-013 | FIXTURE_TOO_WEAK | No expected blocker/forbidden behavior | Strengthen fixture |
| HHWE-014 | RUNNER_TOO_WIDE | Runner starts with all helpers/all fixtures | Block and select one row |
| HHWE-015 | NEW_RULE_WEAKENS_STOPLINE | New rule softens old StopLine | Court review |
| HHWE-016 | DUPLICATE_ACTIVE_COLLISION | Duplicate helper lacks status | Mark active/source-only/superseded/repair/collision |
| HHWE-017 | SEMANTIC_DAMAGE_DURING_REPAIR | Repair passes check but changes meaning | Add semantic regression |
| HHWE-018 | COMPATIBILITY_SCAN_SKIPPED | New item enters without adverse-effect scan | Block entry |

## Reproducibility Lock

Every durable helper trust claim needs:

```text
BenchSpecVersion:
FixtureVersion:
HelperVersion:
HelperSHA256:
RunnerVersion:
RunnerSHA256:
InputManifestSHA256:
ExpectedOracle:
RunCommand:
RunId:
Environment:
RepoHeadIfUsed:
BeforeStateHash:
AfterStateHash:
OutputSHA256:
Verdict:
FinalSentinel:
DoesNotProve:
```

Hard rule:

```text
No reproducibility lock, no durable trust upgrade.
```

## Bench Differential Row

```text
Fixture:
OldRunnerVerdict:
NewRunnerVerdict:
SameOrDifferent:
DifferenceClass:
RequiredAction:
```

Difference classes:
- `EXPECTED_IMPROVEMENT`
- `NEW_RUNNER_STRICTER`
- `NEW_RUNNER_WEAKER`
- `OLD_RUNNER_WRONG`
- `NEW_RUNNER_WRONG`
- `ORACLE_CHANGED`
- `REVIEW_REQUIRED`

## Human-Paste Fixture Family

```text
PASTE_CONTAINS_PS_PROMPT
PASTE_CONTAINS_VERDICT_LINES
PASTE_CONTAINS_FAKE_PASS
PASTE_CONTAINS_SOURCE_AND_COMMAND_MIXED
PASTE_CONTAINS_TRUNCATED_OUTPUT
PASTE_CONTAINS_OLD_HEAD
PASTE_CONTAINS_NEW_HEAD
PASTE_CONTAINS_LINK_ONLY_SOURCE
PASTE_CONTAINS_CAPTION_ONLY_SOURCE
PASTE_CONTAINS_ROUTE_NOT_AUTHORIZATION
```

Expected behavior: classify transcript vs command, do not execute pasted status text, do not treat route as authorization, and request source capture when source cannot be opened.
