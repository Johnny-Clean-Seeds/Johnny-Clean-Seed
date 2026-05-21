# Tiny Nerve Test Template - HNS Mesh V2

Date: 2026-05-20
Lane: Mule return / tiny live-use template
Status: Template only, not execution

## Boundary

Use only when a real signal appears. Do not force this onto every task. Do not build a dashboard, runtime, automation, or permanent feed.

## Template

```text
HOUSE NERVOUS SYSTEM TINY NERVE TEST

TEST ID:

DATE:

SIGNAL:
What happened?

LANE:
Where did it happen?

SENSOR:
What noticed it?

SALIENCE:
Why does it matter or not matter?

THRESHOLD:
What line was crossed?

ALARM LEVEL:
QUIET / NOTICE / WATCH / WARNING / BLOCK / STABILIZE / STORM

ALARM NAME:
Name the alarm in plain house language.

DEBUGGER:
What questions diagnose root cause?

ROOT CLASS:
rule missing / rule did not fire / wrong rule / stale state / proof gap / custody failure / delivery failure / dead nerve / alarm storm / source-ore drift / authority drift / other

ROUTE:
Where does this belong?

SAFE REFLEX:
What immediate narrow action is allowed?

PROOF / BOUNDARY:
What permits movement, blocks movement, or proves closure?

MEMORY / DECAY:
What is kept, parked, escalated, or allowed to fade?

CLOSE CONDITION:
When does the alarm go quiet?

NO ALARM KING CHECK:
Does this alarm stay support-only and inside authority boundaries?

RESULT:
repaired / parked / blocked / decayed / escalated / unknown
```

## Example Candidate: Requested File Delivery Nerve

```text
SIGNAL:
User asks for a deliverable file, but assistant starts answering only in chat.

LANE:
Delivery hygiene.

SENSOR:
Requested-file-delivery sensor.

SALIENCE:
User requested a file; chat-only output would miss delivery.

THRESHOLD:
The output is being written in chat instead of a file in the approved lane.

ALARM LEVEL:
WARNING.

ALARM NAME:
Requested File Delivery Warning.

DEBUGGER:
Did the user ask for a file?
What is the approved output lane?
Was a file created there?
Is any output scattered elsewhere?

ROOT CLASS:
delivery failure / dead nerve.

ROUTE:
Delivery hygiene and file custody.

SAFE REFLEX:
Create the file in the named lane and report exact path.

PROOF / BOUNDARY:
File exists in approved lane; no doctrine/runtime/dashboard/guide/index changes.

MEMORY / DECAY:
Keep delivery failure as candidate nerve residue if repeated; decay chat-only draft.

CLOSE CONDITION:
Requested file exists in correct lane and no loose copy is active.

NO ALARM KING CHECK:
Do not create permanent delivery dashboard. Use the nerve only when requested-file risk appears.
```

