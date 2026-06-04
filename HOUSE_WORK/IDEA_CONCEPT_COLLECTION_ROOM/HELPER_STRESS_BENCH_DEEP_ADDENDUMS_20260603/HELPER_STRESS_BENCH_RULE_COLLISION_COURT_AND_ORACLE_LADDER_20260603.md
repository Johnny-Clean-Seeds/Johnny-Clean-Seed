# Helper Stress Bench Rule Collision Court and Oracle Ladder

Date: 2026-06-03
Status: SPEC SUPPORT CANDIDATE / NOT IMPLEMENTATION

## Source Anchors

RawSHA256: `6B80C7043C9640101BB89FAEEC3EFD56DA84EA7EDA86B925801D4775EB36B92E`

Line anchors:
- L4643-L4665: rule collision court.
- L4707-L4737: oracle/judge rule.
- L4932-L4974: oracle ladder.
- L4328-L4372: anti-requirements that the court must defend.
- L4478-L4515: compatibility verdict vocabulary.

## Rule Collision Court

Trigger the court when a new helper, rule, test, batch, fixture, runner, or wording change might weaken, rename, duplicate, or contradict an existing stress-bench rule.

Court row:

```text
CollisionId:
OldRule:
NewRule:
ConflictType:
WhichStoplineIsStricter:
WhichOneHasProof:
WhichOneHasBroaderBlastRadius:
AffectedBatches:
AffectedHelperTiers:
AffectedFixtures:
DoesEitherCreateNewAuthority:
DoesEitherWeakenFinalSentinel:
DoesEitherBypassManifestFirstSave:
Disposition:
ReviewOwner:
ReturnTrigger:
```

Allowed dispositions:
- `KEEP_OLD`
- `ADOPT_NEW`
- `MERGE`
- `PARK`
- `CONTRADICTION_OPEN`

Forbidden dispositions:
- `NEWEST_WINS`
- `CLEAN_ENOUGH`
- `PASS_WITH_WARNINGS`
- `ROUTE_AS_AUTHORIZATION`
- `TRUSTED_BECAUSE_HELPER_SAYS_SO`

## Oracle Ladder

```text
ORACLE_0_NONE
Use: exploration only.
DoesNotProve: pass/fail proof.

ORACLE_1_MECHANICAL
Use: exact expected state or text exists.
DoesNotProve: semantic fit beyond the checked value.

ORACLE_2_BLOCKER_CLASS
Use: expected blocker family is known.
DoesNotProve: repair quality.

ORACLE_3_RELATION
Use: output must preserve a relation.
DoesNotProve: exact output identity.

ORACLE_4_DIFFERENTIAL
Use: compare helpers, versions, or runners.
DoesNotProve: which side is correct without review.

ORACLE_5_HUMAN_REVIEW
Use: human/assistant judgment is required.
DoesNotProve: mechanical reproducibility.

ORACLE_6_COMPOSITE
Use: high-risk Tier 4/5 helpers.
DoesNotProve: global trust outside the named fixture set.
```

Hard rule:

```text
No oracle, no proof fixture.
```

## Neighbor Fit

Final sentinel rule:
- A verdict is not PASS without the required final sentinel.

Blocker router rule:
- Router judges, repair fixes, save records. The court does not repair.

Helper self-test candidate:
- Output shape and report shape must be tested before Git write branches.

Route-is-not-action:
- A recommended next action is not authorization to run it.

Manifest-first save:
- A save set is chosen by manifest, not by whatever Git status happens to show.
