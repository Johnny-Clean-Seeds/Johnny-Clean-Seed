# Helper Stress Bench Candidate Next-Proof Table - 20260603

Status: NEXT PROOF RECOMMENDATION / NO RUNNER / NO SCRIPT EXECUTION

| Order | Candidate | Why | Required proof before any run | Blocked until |
| ---: | --- | --- | --- | --- |
| 1 | Static shape review of READ_ONLY_INSPECT_ACTIVE_TASK_V0.ps1 | Base candidate is fresh and local, but static inventory found write/protected/PASS surfaces | prove expected read scope, output locations, no repo mutation, no active/protected touch, no PASS-before-sentinel | user authorizes static row review |
| 2 | Row 001 fixture card set | Needed before execution | golden clean, missing source, wrong hash, dirty repo, stale staged index, fake PASS in pasted source, forbidden behavior list | static shape review passes |
| 3 | READ_ONLY_INSPECT_ACTIVE_TASK_V0.ps1 in fake/sandbox fixture only | First possible helper run, not authorized yet | final sentinel, before/after state, output hash, no mutation, expected blocker classes | user authorizes one-row run |
| 4 | READ_ONLY_INSPECT_ACTIVE_TASK_V0_COLOR_V1.ps1 | Variant after base row survives | output-shape comparison and regression against base | base row passes |
| 5 | READ_ONLY_INSPECT_ACTIVE_TASK_V0_COLOR_V1_1.ps1 | Newer variant after color V1 comparison | same as Row 4 plus regression row | V1 comparison passes |
| 6 | RUN_GUARD_REVIEW_READ_ONLY_INSPECT_* | Guard-review wrappers detected stage/move/process patterns | authority scan, no-write proof, no-stage proof, no-process proof | direct read-only inspect row survives |
| 7 | COMMAND_GRAMMAR design/save-gate family | Useful later, but many save/stage/commit patterns | manifest-first, route-is-not-action, final-sentinel, no protected touch | read-only rows and fixture quality gate pass |
| 8 | HOUSE_DOCK and watcher/remote surfaces | High risk implementation/process/watch surfaces | fake/sandbox only, negative fixtures, no live process proof | separate authorization |

Final recommendation: do not run a helper next. Build the static Row 001 code-shape review and fixture-card packet first.
