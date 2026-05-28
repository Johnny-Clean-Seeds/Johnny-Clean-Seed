# Helper Issue Gate Routing Rule — Candidate V1

Date: 2026-05-28  
Status: CANDIDATE RULE / HELPER BEHAVIOR / NOT DOCTRINE  
Authority: not doctrine, not ACTIVE_GUIDES, not CURRENT_TRUTH_INDEX  
Boundary: helper issue handling rule only; no helper rewrite yet; no save route; no Git action  

---

## 1. Problem

A helper can stop, warn, or fail, but still leave the assistant/user with a loose issue.

Loose issue output looks like:

```text
failed
blocked
missing path
bad argument
wrong repo
warning found
target not run
```

That is not enough.

If the helper can understand the issue, it should route the issue through the gates it owns or can safely apply.

---

## 2. Rule

```text
When a helper detects an issue, it should run that issue through its available gates before returning output.
```

Available gates may include:

```text
syntax gate
safety gate
source/custody gate
path/root gate
hash/proof gate
authority gate
permission/allow-switch gate
argument-shape gate
write/move/delete/Git boundary gate
output/receipt gate
job-result gate
```

If the helper does not own a gate, it must not fake it.

It should mark:

```text
NEEDS_GATE
NEEDS_ASSISTANT_REVIEW
NEEDS_SOURCE_CHECK
NEEDS_PROOF
NEEDS_USER_SELECTION
```

---

## 3. Minimum Helper Issue Report Shape

When possible, helper issue output should include:

```text
Issue ID:
Issue title:
Detected by:
Affected object:
Gate applied:
Gate verdict:
Evidence:
Stopped before action:
Files moved:
Files written:
Git action:
Hash/proof state:
Authority impact:
Next safe action:
What not to do:
Needs assistant/user review:
```

---

## 4. Good Helper Behavior

A helper should say:

```text
I stopped before move.
Repo root was not found.
No source hash was made.
No destination hash was made.
No Git action occurred.
Gate verdict: PATH/ROOT FAIL.
Next safe action: prove repo root before rerun.
```

Not:

```text
failed
```

A helper should say:

```text
Move command detected.
Code Gate blocked auto-run until -AllowMove is explicit.
Gate verdict: EXPECTED SAFETY BLOCK.
Next safe action: permission route review.
```

Not:

```text
target did not run
```

---

## 5. What Helpers Must Not Do

Blocked:

```text
do not invent source proof;
do not invent repo root;
do not claim PASS when target did not run;
do not continue after wrong root;
do not move before hash;
do not treat remote URL alone as repo authority;
do not decide doctrine/ACTIVE_GUIDES/CURRENT_TRUTH_INDEX;
do not run broad scans unless root/bounds are approved;
do not hide warnings;
do not flatten all issues into generic failure.
```

---

## 6. Helper Capability Boundary

Helpers can only run gates they are designed to know.

Examples:

```text
Code Gate can judge syntax/safety patterns and runner permission boundaries.
Hash helper can judge file/folder hash proof.
Move helper can judge hash-before-move custody and destination hash compare.
Save helper can judge repo root, clean status, selected files, hash/move/receipt/Git save.
Registry helper can judge row shape, missing fields, source state, and status labels.
```

If a helper cannot judge something:

```text
mark NEEDS_ASSISTANT_REVIEW;
preserve evidence;
stop before risky action.
```

---

## 7. Fit To Current Branch

Current branch:

```text
LOCAL SAVE ROUTE AUTHORITY HANDOFF BRANCH
```

The branch exposed that helpers should return gate-shaped issue reports for:

```text
Code Gate move block
wrong default repo root
multiple same-remote repos
TargetArgs pass-through failure
source hash not reached
move not reached
Git not reached
```

A better save helper issue report would have named:

```text
Gate: PATH/ROOT
Verdict: FAIL BEFORE SOURCE HASH
Evidence: RepoRoot not found
Stopped before action: YES
Files moved: NO
Git action: NO
Next safe action: prove selected repo root and runner args
```

---

## 8. Rule Candidate Names

Strong name:

```text
HELPER ISSUE GATE ROUTING RULE
```

Short name:

```text
Helpers Run Issues Through Gates
```

---

## 9. Close Condition

This candidate becomes useful when a helper is revised or created with issue reports that include:

```text
issue classification
gate verdict
evidence
stopped-before-action state
next safe action
what not to do
```

It remains candidate until proven in a helper run.

---

## 10. One-Line Clean Wrap

```text
A helper that can detect an issue should return the issue already routed through the gates it owns, and mark what it cannot judge instead of leaving a loose failure for chat to clean up.
```
