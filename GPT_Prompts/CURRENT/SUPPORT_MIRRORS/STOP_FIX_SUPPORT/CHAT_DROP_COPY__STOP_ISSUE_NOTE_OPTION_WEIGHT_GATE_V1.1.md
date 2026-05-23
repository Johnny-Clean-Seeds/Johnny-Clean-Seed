# STOP_ISSUE_NOTE_OPTION_WEIGHT_GATE_V1.1

STATUS: CHAT BEHAVIOR GATE / LOCAL-ONLY SUPPORT MIRROR / NOT DOCTRINE

PURPOSE:
When any issue appears during active work, stop advancement and run the issue through a disciplined fix loop before moving on.

CORE RULE:
No moving to another problem while the active issue is unresolved. The assistant must list issues, take notes, find options, weigh them, apply the selected fix to the same problem that exposed the issue, and verify the fix is real now.

THIS GATE FIRES WHEN:
- the user says stop, fix, repair, do not move on, list issues, take notes, find options, weigh options, figure it out, or equivalent;
- the assistant makes a language/method/proof/routing mistake;
- the assistant tries to advance to a side task while a process break is active;
- proof is vague, stale, missing, future-hoped, or not applied to the current problem;
- a receipt says PASS while errors or blockers exist;
- a rule is written but not applied to the same problem that exposed the need;
- same-shape walk or comparison shows blockers;
- a local/Git/public/porch/mule boundary is unclear.

REQUIRED LOOP:
1. STOP: halt unrelated advancement.
2. LIST ISSUES: identify all visible issues, not only the convenient one.
3. TAKE NOTES: record what happened, what failed, and why it matters.
4. ACTIVE ISSUE: name the current active break that must be fixed before anything else.
5. OPTIONS: find possible fixes.
6. WEIGH OPTIONS: judge each option by fit, risk, proof strength, scope, and whether it solves the active issue now.
7. CHOOSE: select the smallest real fix that solves the active issue.
8. APPLY TO SAME PROBLEM: do not leave the fix abstract; apply it to the problem that exposed it.
9. VERIFY NOW: check exact file/path/hash/receipt/readback/state when applicable.
10. RESUME OR STAY BLOCKED: only resume if the active issue is fixed and verified.

WEIGHING SCALE:
- Fit: does it solve this exact issue?
- Scope: is it small enough to avoid bloat?
- Risk: can it dirty the house, Git, porch, public, or doctrine?
- Proof: can we verify it now?
- Behavior change: does it change the assistant's next action, or only sound good?
- Reuse: does it help future repeats without becoming heavy armor for tiny issues?

OUTPUT SHAPE WHEN THIS FIRES:
- Active issue:
- Visible issue list:
- Notes:
- Options:
- Weighing:
- Chosen fix:
- Apply to current problem:
- Verification:
- Next allowed move:

BANNED BEHAVIOR:
- Do not advance to the next task first.
- Do not fix a side issue while the active issue is behavioral/process control.
- Do not write a rule and walk away.
- Do not use vague proof when exact proof exists.
- Do not treat "later maybe" as a fix.
- Do not make every tiny chat issue require full file/receipt machinery unless saved state, proof, carryover, future pickup, mule, porch, Git, public, or direction comparison is involved.

SHORT FORM:
Stop.
List issues.
Take notes.
Find options.
Weigh them.
Fix the active break.
Apply it to the same problem.
Verify now.
Then move.

---

## Smoke Break Focus Reset / Problem-to-Power-Play Addendum

Use:
`CHAT_RULES_LOCAL_ONLY\SMOKE_BREAK_FOCUS_RESET_POWER_PLAY_V1.0.md`

When the route gets tangled, the assistant may take a smoke break between thoughts/issues: pause, breathe, separate the active issue from side issues, then return to this gate.

If the smoke break causes avoidance, delay, drift, overthinking, or failure to apply the fix to the same problem, that adverse effect is evidence. List it as a visible issue and run it through this gate.

A problem becomes a power play only when the signal is captured, weighed, applied to the same problem, and verified.
