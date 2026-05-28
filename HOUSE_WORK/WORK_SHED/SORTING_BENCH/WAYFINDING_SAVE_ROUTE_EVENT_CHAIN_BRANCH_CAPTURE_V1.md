# Wayfinding Save Route — Event-Chain Branch Capture V1

Date: 2026-05-28  
Status: BRANCH CAPTURE / PAUSE STATE / NOT REPAIR YET  
Object: Wayfinding path packet hashed save route  
Authority: not doctrine, not ACTIVE_GUIDES, not CURRENT_TRUTH_INDEX  
Boundary: capture only; no command repair; no helper scan; no move; no Git action; no Scratch and Sniff yet  

---

## 1. Why This Capture Exists

This is no longer one isolated mistake.

A string of related stops appeared during the save route:

```text
save selected
source evidence required
move blocked by Code Gate until explicit allow
repo root default wrong
multiple repos found
TargetArgs command shape failed
```

This looks like a vine/branch.

It may expose a later tree around:

```text
local save-route authority,
repo-root selection,
runner argument passing,
helper default assumptions,
and generated-command ergonomics.
```

Do not treat each stop as a separate one-line fix until the chain is named.

---

## 2. Event Chain

### Event 1 — Save was mislabeled as a fork

Observed:

```text
Assistant said “save route or keep as chat artifacts.”
User corrected: this is not a fork; save is a must.
```

Meaning:

```text
The assistant framed selected mandatory work as optional.
```

Pressure:

```text
selected route recognition
user authority recognition
pre-save thinning versus actual save transition
```

### Event 2 — User required evidence before move

Observed:

```text
User stated: get EVIDENCE THEN MOVE.
```

Meaning:

```text
Save route must be source evidence -> hash -> move -> destination hash -> compare -> receipt.
```

Pressure:

```text
hash-before-move custody rule is active and central.
```

### Event 3 — Save helper generated with wrong default repo root

Observed default:

```text
C:\Users\13527\Desktop\Jxhnny_Kleen_C3dz
```

Actual repo proof later found:

```text
C:\Users\13527\Desktop\123\Jxhnny_Kl33N_Seedz
```

Meaning:

```text
The helper carried an outdated/default repo-root assumption instead of requiring repo root proof first or accepting current known 123 house context.
```

Pressure:

```text
Generated save helpers must not assume old house paths.
They should detect/require repo root before doing any save logic.
```

### Event 4 — Code Gate blocked Move-Item until explicit allow

Observed:

```text
BLOCKED - CODE GATE DID NOT RUN TARGET
Move command blocked
Reason: Auto-run is blocked for move/rename scripts unless -AllowMove is used.
```

Meaning:

```text
Code Gate behaved correctly.
This was not a script failure.
It was an intended safety interlock.
```

Pressure:

```text
Move/save helpers need an expected permission recipe.
The assistant should anticipate that hash-move scripts require -AllowMove and -AllowGitWrite.
```

### Event 5 — Direct allowed run stopped before source hash

Observed:

```text
WAYFINDING HASH MOVE SAVE STOPPED:
RepoRoot not found: C:\Users\13527\Desktop\Jxhnny_Kleen_C3dz
```

Meaning:

```text
No source hash, no move, no Git.
The bad repo root stopped before custody work began.
```

Pressure:

```text
Fail-closed worked.
Default repo root was the problem.
```

### Event 6 — Repo-root finder exposed multiple Git repos

Observed:

```text
C:\Users\13527\Desktop\123\Jxhnny_Kl33N_Seedz
Head: d6830af
Remote: https://github.com/Johnny-Clean-Seeds/Johnny-Clean-Seed.git

C:\Users\13527\Desktop\messy\Johnny-Clean-Seed
Head: 9e9d0b0
Remote: https://github.com/Johnny-Clean-Seeds/Johnny-Clean-Seed.git

C:\Users\13527\Desktop\messy\Clean Milk not-BLOAT\GITHUB_PUBLISH_OUTBOX
Head: 72b764b
Remote: https://github.com/Johnny-Clean-Seeds/Johnny-Clean-Seed.git
```

Meaning:

```text
Same remote exists in several local folders.
A helper cannot infer correct repo from remote alone.
```

Pressure:

```text
Repo-root authority must include path/lane/current-shell context,
not only remote URL.
```

### Event 7 — TargetArgs call failed

Observed:

```text
POWERSHELL_CODE_GATE_RUNNER_V1.3.ps1:
Missing an argument for parameter 'TargetArgs'.
Specify a parameter of type 'System.String[]' and try again.
```

Meaning:

```text
The suggested command shape did not match the runner's parameter parsing expectations in this shell context.
```

Pressure:

```text
Runner argument pass-through needs a proven copy-paste recipe.
Do not assume a string-quoted TargetArgs expression will parse correctly.
```

---

## 3. Neighbor Systems Touched

This chain touches several neighbors:

```text
Code Gate V1.3 allow-switch behavior
Code Gate V1.4 wrapper role boundary
hash-before-move custody rule
repo-root authority selection
local house path memory
multiple-repo hazard
PowerShell parameter passing / TargetArgs shape
generated helper defaults
save-route transition after selection
proof-before-move discipline
```

This is bigger than “rerun the command.”

---

## 4. Branch Pressure Name

Candidate branch name:

```text
SAVE ROUTE REPO-ROOT AND ARGUMENT-PASSING BRANCH
```

Cleaner name:

```text
LOCAL SAVE ROUTE AUTHORITY HANDOFF BRANCH
```

Short form:

```text
Before save helpers move anything, the save route must prove which house, which runner permissions, and which child args are actually active.
```

---

## 5. What This Is Not

This is not Scratch and Sniff yet.

Not yet:

```text
no new probe
no broad file search
no helper rewrite
no registry expansion
no rerun
no save attempt
no command repair loop
```

Reason:

```text
The sequence itself must be preserved first.
The branch may expose a larger tree.
```

---

## 6. Immediate Lessons

### Lesson 1 — Fail-closed worked

The generated helper did not move files after repo-root failure.

Status:

```text
GOOD
```

### Lesson 2 — Code Gate block worked

Move was blocked until explicit permission.

Status:

```text
GOOD
```

### Lesson 3 — Default repo-root assumption failed

The helper carried an old/default path.

Status:

```text
FAIL / BRANCH PRESSURE
```

### Lesson 4 — Remote URL alone is insufficient

Multiple local repos share the same remote.

Status:

```text
WATCH / AUTHORITY PRESSURE
```

### Lesson 5 — TargetArgs recipe is not proven

The suggested one-line pass-through failed.

Status:

```text
FAIL / USABILITY PRESSURE
```

---

## 7. Rule Candidates Found

### Rule Candidate 1 — Save Helper Must Prove Repo Root Before Save Logic

Working form:

```text
A generated save helper must not rely on a hardcoded repo root as truth.
Before source hash/move/Git, it must prove the selected repo root by exact path, .git presence, remote, branch/head, and user-selected/current-house context.
If multiple matching remotes exist, stop and ask/select by exact path.
```

### Rule Candidate 2 — Runner Pass-Through Arguments Need Proven Recipe

Working form:

```text
When a Code Gate runner uses -TargetArgs, do not hand the user an unproven quote shape for important save/move work.
Use a tested array/splat or provide a small wrapper command that constructs the array in shell.
If the pass-through shape fails, capture it as runner UX evidence.
```

### Rule Candidate 3 — Expected Safety Block Is Not Failure

Working form:

```text
If Code Gate blocks move/delete/Git/network due missing explicit allow switch, mark it as expected safety behavior, not target failure.
Next action is permission route review, not target repair.
```

### Rule Candidate 4 — Save Route Selection Is Not Optional Fork

Working form:

```text
Once the user selects save as mandatory, the assistant must stop presenting save versus skip-save as equal branches.
The next branch is how to save safely, not whether to save.
```

---

## 8. Current State

```text
Save selected: YES
Files moved: NO
Source hashes made by save helper: NO
Destination hashes made: NO
Git action: NO
Repo-root proof: PARTIAL / exact candidate found
TargetArgs route: FAILED
Current branch: LOCAL SAVE ROUTE AUTHORITY HANDOFF BRANCH
```

Likely selected repo:

```text
C:\Users\13527\Desktop\123\Jxhnny_Kl33N_Seedz
```

But because the branch is paused:

```text
do not run save again until the argument route is settled.
```

---

## 9. Clean Next Step After Pause

Do not continue with another save command immediately.

Next should be one of:

```text
A. Capture this branch into house/save-support packet before retry.
B. Inspect Code Gate runner TargetArgs expected syntax from runner source.
C. Create a tiny no-move/no-Git argument-pass proof target to prove TargetArgs shape.
D. Revise save helper to discover/reject repo roots more cleanly before any selected file handling.
```

Recommended after capture:

```text
B first: inspect runner TargetArgs handling from the V1.3 runner source.
```

Reason:

```text
The current blocker is not the save helper content.
It is the handoff from runner command to child script argument passing.
```

---

## 10. One-Line Clean Wrap

```text
The save route exposed a local authority handoff branch: before moving saved artifacts, the system must prove the active repo root, expected Code Gate permissions, and child-argument passing shape instead of treating each stop as an isolated typo.
```
