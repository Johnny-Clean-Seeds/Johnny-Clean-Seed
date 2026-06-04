# Helper Stress Bench Self-Test and Coverage Gap Map

Date: 2026-06-03
Status: SPEC SUPPORT CANDIDATE / NO LIVE TESTS

## Source Anchors

RawSHA256: `6B80C7043C9640101BB89FAEEC3EFD56DA84EA7EDA86B925801D4775EB36B92E`

Line anchors:
- L39-L67: helper row test starter cases.
- L1029-L1051: fixture family shape.
- L1167-L1175: authority tier controls fixture depth.
- L4643-L4765: coverage gap and bench self-test requirements.
- L5042-L5095: test data quality gate.
- L5107-L5135: shrink rule.

## Coverage Gap Map

| Test family | Covered now | Known gap | False-confidence risk | Next fixture needed |
| --- | --- | --- | --- | --- |
| Golden clean input | Planned | Not built | Helper looks trusted from happy path only | `000_GOLDEN_CLEAN` |
| Missing source | Planned | Not built | Helper might invent or continue | `001_MISSING_SOURCE` |
| Wrong hash | Planned | Not built | Source custody can be bypassed | `002_WRONG_HASH` |
| Dirty repo | Planned | Not built | Save helper may stage wrong object | `003_UNEXPECTED_DIRTY_PATH` |
| Ignored expected file | Planned | Not built | Helper may force-add or panic | `004_EXPECTED_FILE_IGNORED` |
| Stale staged index | Planned | Not built | Old staged patch can be committed | `007_STALE_STAGED_INDEX` |
| Final sentinel | Planned | Not built | False PASS can survive interruption | `008_NO_FINAL_SENTINEL` and `009_EARLY_PASS_LINE` |
| Route-is-not-action | Planned | Not built | Recommended action becomes execution | `010_ROUTE_IS_NOT_ACTION` |
| Protected path bait | Planned | Not built | Helper touches forbidden lanes | `011_PROTECTED_PATH_BAIT` |
| Human-paste transcript noise | Newly added | Not built | Pasted output is mistaken for command/source | `PASTE_CONTAINS_*` family |
| New rule weakens old rule | Newly added | Not built | Support packet silently lowers StopLine | `NEW_RULE_WEAKENS_STOPLINE` |

## Bench Self-Test Required

The bench must prove it can detect:
- bad fixture.
- wrong expected blocker.
- missing forbidden behavior list.
- runner too wide.
- fake PASS in helper output.
- result ledger missing fields.
- weak spot not captured.
- regression fixture not created after repair.

## Fixture Quality Gate

Every fixture card must answer:

```text
FixtureId:
PrimaryInjectedFault:
ExpectedBlockerClass:
ForbiddenBehaviorList:
CleanupRule:
ProofItIsNotRealRepo:
SourceHashIfRelevant:
ExpectedBeforeState:
ExpectedAfterState:
OracleLevel:
AuthorityTier:
DoesNotProve:
```

Bad fixture labels:
- `OVERNOISY_FIXTURE`
- `UNDERPOWERED_FIXTURE`
- `AMBIGUOUS_FIXTURE`
- `LIVE_DANGER_FIXTURE`
- `VIBE_FIXTURE`

## Shrink Rule

When a big fixture fails, try to reduce it before repair.

Shrink questions:
- Can one input file be removed and still fail?
- Can the manifest be shortened and still fail?
- Can one blocker be removed and still fail?
- Can path depth be reduced and still fail?
- Can transcript noise be reduced and still fail?
- Can options be reduced and still fail?
- Can only the minimum trigger line be preserved?

Allowed shrink verdicts:
- `MINIMIZED_REPRO_READY`
- `MINIMIZATION_NOT_SAFE`
- `MULTI_CAUSE_FAILURE_CONFIRMED`

## StopLine

No live helper stress test begins until the read-only helper inventory exists, a single helper row is selected, and the first fake/sandbox fixture set has expected blockers and forbidden behaviors.
