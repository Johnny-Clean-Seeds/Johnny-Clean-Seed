# Mule Boss Pool Wheel — 0 Judge + 12 Gates — V1

CORE SHAPE:
0 JUDGE sits in the center.
1-12 sit around it as ordered gates.
The run moves 1 -> 12, then returns to 1 only after 0 JUDGE closes the cycle.

THREE CONTROLS:
1. Order — every gate fires in sequence.
2. Domain — every gate owns one job.
3. Relationship — every gate has neighbors and an opposite/checking gate.

0. JUDGE GATE — Center / Whole-Wheel Judge
Job: starts the run, watches every gate, judges every gate, and closes the run.
Checks:
- Did each gate fire?
- Did each gate stay in its job?
- Did any gate overreach?
- Did any gate get skipped?
- Did the run finish cleanly?
- Is the output safe for user review?

1. ANCHOR GATE — Current Position
Job: confirms current project position, active task, active lane, what is already closed, and what must not be reopened.

2. RUN LOCK GATE — Run Contract
Job: locks mode, scope, authority, inputs, allowed output, stop rule, and expansion rule before work begins.

3. AUTHORITY GATE — What Can Command
Job: separates command files from reference, stale history, source ore, support, and non-command material.

4. FILE ROLE GATE — Every Object Gets a Job
Job: classifies every mule file as active controller, active spine, active support, optional expansion, stale, retired, duplicate, unknown, or needs user review.

5. VERSION DRIFT GATE — Old vs Current
Job: checks version conflict and decides which version controls normal runs, which versions are support-only, and which versions are stale or ignored.

6. NEIGHBOR FIT GATE — Side-to-Side Compatibility
Job: checks nearby gates, files, rules, lanes, and workflows before changing anything, so one fix does not break its neighbor.

7. MIRROR / OPPOSITE CHECK GATE — Direct Counterbalance
Job: checks the opposite side of the wheel. It asks what the opposite risk is, what a gate would miss by itself, whether the run is too narrow or too broad, and whether the fix creates the opposite problem.

8. CONTROLLER / SPINE FIT GATE — Minimal Working Set
Job: decides whether the controller gate plus compact spine are enough for the mule to run cleanly.

9. EXPANSION GATE — Bigger Context Permission
Job: controls access to bigger files, boards, archives, folders, or broader context. Default is no expansion unless blocked.

10. OUTPUT SHAPE GATE — Return Format
Job: forces mule output into a clean top block and reviewable sections.

Required top block:
STATUS:
RUN LOCK:
FILES READ:
TASK:
SCOPE:
MODE:
NOT DONE:
NEEDS USER REVIEW:

11. NO PROMOTION GATE — Authority Boundary
Job: blocks premature authority changes unless explicitly authorized:
- merge
- doctrine install
- active guide rewrite
- CURRENT_TRUTH_INDEX rewrite
- deletion
- cleanup
- final truth declaration
- broad restructuring

12. FIT DECISION / CARRYOVER GATE — Close and Feed Forward
Job: gives every object a disposition and names the next clean move.

Disposition options:
- use now
- support only
- shed later
- retire
- duplicate
- reject
- unknown / needs review
- expansion candidate
- return trigger

WHEEL MECHANICS:
0 Judge opens.
1 Anchor.
2 Run Lock.
3 Authority.
4 File Role.
5 Version Drift.
6 Neighbor Fit.
7 Mirror/Opposite Check.
8 Controller/Spine Fit.
9 Expansion.
10 Output Shape.
11 No Promotion.
12 Fit Decision / Carryover.
0 Judge closes.

Only after Judge closes clean may 12 feed the next clean start back to 1.
