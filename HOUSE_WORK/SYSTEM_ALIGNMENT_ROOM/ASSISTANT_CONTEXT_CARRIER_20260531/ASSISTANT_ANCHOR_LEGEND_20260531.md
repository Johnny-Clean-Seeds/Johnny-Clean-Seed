# Assistant Anchor Legend

Date: 2026-05-31
Status: SUPPORT LEGEND / NOT DOCTRINE
WorkKey: ASSISTANT-CONTEXT-CARRIER-AND-ANCHOR-LEGEND-20260531-V1

## Carry Classes

| Class | Meaning | May drive action? |
|---|---|---|
| LIVE_ANCHOR | Current file-grounded pointer with path, source, proof pointer, and freshness | Only inside its boundary |
| REPORTED_STATE | User, mule, assistant, or helper reported state | No, check file proof first |
| LOCAL_REPORT | Local run output | Evidence only unless saved/linked by receipt |
| SUPPORT_SURFACE | Report, CSV, helper output, path/hash mention, index row, or analysis artifact | No approval power |
| APPROVAL_RECEIPT | Receipt that approves or proves an exact object/version/action | Yes, only exact scope |
| SOURCE_ORE | Useful source material | No, needs intake/adoption path |
| PARKED_CANDIDATE | Idea/tool/rule/helper/method with lane, proof need, return trigger, and blocked actions | No, until selected |
| STALE_OR_SUPERSEDED | Historical evidence or older state | No current action |
| NEXT_OBJECT | Next legal action from anchor, TODO, route card, or receipt | Yes, if current and bounded |
| BLOCKER | Named stop condition with evidence | Stops movement until classified |
| DO_NOT_TOUCH | Protected or blocked surface/action | No |
| UNKNOWN_NEEDS_WALK | Cannot classify from chat/context | No, needs file walk |

## Proof Hierarchy

1. Live file proof beats chat memory.
2. Current anchor beats old report.
3. Approval receipt beats support surface.
4. Path/hash proves identity or custody, not approval.
5. Local report proves local output, not adoption.
6. Helper output proves a helper claim, not final judgment.
7. Chat Drop is bridge material, not source authority.
8. Git clean does not prove ignored intended files are tracked.
9. Root clean does not prove concepts were read/applied unless custody/apply receipt says so.
10. Concept captured does not mean concept is a living rule.
11. If claims conflict, freeze and classify.

## False Equivalences To Block

- User pasted report = current truth.
- Newest pasted item = newest file state.
- Local path link = file exists now.
- Git clean = local-only work is irrelevant.
- Receipt = approval.
- Helper says pass = action may proceed.
- Mule said done = all related systems updated.
- Concept ledger row = living rule.
- Root clear = no lost ideas.
- Chat memory = house source.

## Conflict Protocol

When chat carry and file proof disagree:

1. Freeze.
2. Name both claims.
3. Assign carry class to each claim.
4. Compare timestamp, run id, and commit.
5. Check root identity.
6. Check local-only versus Git-saved.
7. Check support surface versus approval receipt.
8. Check stale or superseded status.
9. Check whether both can be true in sequence.
10. Choose current file proof if clear.
11. If unclear, mark unresolved and ask for specific proof.
12. Update carrier or legend if this confusion can repeat.
