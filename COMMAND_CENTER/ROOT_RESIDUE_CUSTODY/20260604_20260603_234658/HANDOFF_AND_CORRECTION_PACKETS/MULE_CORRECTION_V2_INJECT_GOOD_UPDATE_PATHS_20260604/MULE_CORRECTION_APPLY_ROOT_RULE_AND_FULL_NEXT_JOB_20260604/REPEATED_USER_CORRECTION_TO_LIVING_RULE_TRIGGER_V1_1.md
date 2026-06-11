# REPEATED USER CORRECTION TO LIVING RULE TRIGGER V1.1

Date: 2026-06-04
Status: BEHAVIOR RULE CANDIDATE / USER-CORRECTION CAPTURE / NOT REPO-SAVED HERE
WorkKey: REPEATED-USER-CORRECTION-LIVING-RULE-TRIGGER-20260604-V1-1

## Core rule

When the user repeats a correction, says the assistant/mule/helper “needs to” or “should be” doing something, or points at a recurring failure, the required response is not only to agree, apologize, or clean the immediate mess.

The correction makes it clear to look.

Default judgment:

`REPEATED_USER_CORRECTION_FORCES_LOOK_AND_RULE_DECISION`

## Required sequence

Use this exact sequence:

1. `LOOK`
2. `ASK: SHOULD THIS BE A LIVING RULE / CHECK / GATE?`
3. `DECIDE`
4. `DO WHAT NEEDS TO BE DONE`

This means the assistant/mule/helper must actively inspect the relevant context enough to answer the question.

It must not wait for the user to say “make this a rule.”

## What “look” means

“Look” does not mean a broad uncontrolled crawl.

It means inspect the relevant lane enough to decide whether the correction points to:

- a missing living rule;
- a failed existing rule;
- a child rule under an existing rule;
- a checklist item;
- a closeout gate;
- a fixture/test case;
- a report/receipt requirement;
- a parking/watch item;
- a one-off note;
- a rejected item with reason.

## Required review questions

When the trigger fires, ask internally and answer in the work:

1. What did the user repeat or emphasize?
2. What behavior is failing?
3. Is there already a rule for this?
4. If yes, why did it not fire?
5. If no, should there be one?
6. Should it be a living rule, child rule, checklist, closeout gate, fixture, or watch item?
7. What exact wording/check would prevent recurrence?
8. What file/lane should hold it?
9. What current task behavior changes right now?
10. What proof or closeout line is required?

## Trigger phrases

These phrases fire the review:

- “I keep telling you...”
- “You need to...”
- “You should be...”
- “Why aren’t you...”
- “Why doesn’t he...”
- “You already know...”
- “This should already be happening...”
- “Do this every time...”
- “Stop doing that...”
- “Don’t leave this mess...”
- “Wtf why isn’t this a rule?”
- Any repeated correction pointing to the same behavior family.

The exact words do not matter. The repeated behavior signal matters.

## Required response

When this trigger fires, the assistant/mule/helper must:

1. Stop treating the correction as a one-off complaint.
2. Name the repeated behavior failure.
3. Look over relevant current files, rules, receipts, reports, and state if available.
4. Decide whether the correction belongs as a rule, check, gate, fixture, watch item, or rejection.
5. If yes, write/capture the candidate or route it to the proper save/proof lane.
6. Apply the new decision to the current task before closeout.
7. Report the candidate name, boundary, and next save/proof route.

## If the answer is yes

If the answer to “should this become a living rule/check?” is yes, then do one of these:

- write the rule candidate;
- add the checklist item;
- add the closeout gate;
- create the fixture row;
- route the item to the correct save/proof lane;
- apply the behavior immediately to the current task.

Do not delay behind explanation unless access is blocked.

## If the answer is no

If the answer is no, say why.

Valid no reasons include:

- one-off preference;
- not repeatable;
- already covered and current failure was an application failure;
- conflicts with a higher rule;
- needs more evidence before promotion;
- belongs as a watch item, not a rule.

Even then, the assistant/mule/helper must record or report the judgment when the user is clearly pointing at recurrence.

## Forbidden response

Do not only say:

- “You’re right.”
- “I’ll remember next time.”
- “Sorry.”
- “Cleaned up.”
- “Noted.”
- “That makes sense.”

Those are not enough.

A repeated correction requires a structural response.

## Evidence ladder

Use this ladder:

1. One correction = pay attention and possibly adjust.
2. Same correction twice = look and rule-decision trigger.
3. Same correction plus user frustration = likely missing rule/check.
4. Same correction across multiple workers/mules/chats = system failure, not personality failure.
5. Same correction after cleanup happened before = prevention rule required.
6. Same correction causing wrong files, false closeout, or root residue = closeout gate required.

## Current child example

The mule/helper root-file issue is the first active child example.

User correction:

The mule keeps leaving loose files in the project root and does not turn the correction into a rule.

Decision:

Yes, this should become a living rule/check.

Child rule:

`MULE_ROOT_NO_LOOSE_FILES_RULE_V1`

Core child judgment:

`ROOT_LOOSE_FILE_WRONG_LANE_UNTIL_PROVEN_ALLOWED`

Closeout pass line:

`ROOT_NO_LOOSE_FILES_CHECK_PASS`

Blocked closeout line:

`ROOT_LOOSE_FILES_PRESENT_CLOSEOUT_BLOCKED`

## Required closeout wording when triggered

Use this shape:

`REPEATED_USER_CORRECTION_REVIEW_FIRED`

Then name:

- repeated correction;
- behavior failure;
- what was inspected;
- answer to “should it become a living rule/check?”;
- resulting rule/check/gate/fixture/watch/rejection;
- current application;
- boundary;
- next save/proof route.

## Failure mode this rule prevents

This rule prevents the assistant/mule/helper from repeatedly cleaning symptoms while failing to install prevention behavior.

It also prevents the user from having to explicitly say “make this a rule” for every obvious recurring correction.

## Boundary

This artifact does not move files.
It does not inspect the local repo.
It does not claim Git status.
It does not claim local save.
It does not promote doctrine.
It is a written rule candidate generated from the user’s correction.
