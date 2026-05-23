# Mule Return - Alarm / Debugger Clean-Bloat Appendix

Date: 2026-05-22

Status: candidate appendix / source support only

Boundary: not doctrine, not promotion, not ACTIVE_GUIDES, not CURRENT_TRUTH_INDEX, not automation.

## Purpose

This appendix preserves useful clean bloat that should not clutter the main cabinet report.

Clean bloat means the idea expands real coverage, names a missing failure family, helps future compression, improves firing proof, or protects source/proof/authority/recovery without becoming random noise.

## High-value clean-bloat candidates

### 1. Alarm Event Receipt

Primary home: Meta Alarm Governors.

Cross-links: all groups.

Job: record whether an alarm actually fired.

Fields:

1. Event.
2. Intended action.
3. Alarm group.
4. Severity.
5. Trigger.
6. Behavior change.
7. Evidence path.
8. Status label.
9. Next tightening move.

Why clean: the cabinet has names and firing cards, but it still needs compact event proof.

### 2. Intake / User-Signal Alarm

Primary home: new Intake / Work Request / User-Signal drawer.

Cross-links: Route/Root, Source/Lane, Authority, Proof.

Job: classify user input before work.

Trigger examples:

- correction
- teaching
- proof report
- source note
- stop/pause/let-it-hang signal
- mixed signal
- task with hidden authority/proof implications

Why clean: Think Before Work and Work Request Sorting show that route failures often start before route selection.

### 3. Artifact Completion / Self-Check Alarm

Primary home: new Artifact Completion / Self-Check drawer.

Cross-links: Rule Quality, Source/Lane, Tool Safety, Proof.

Job: make sure durable artifacts are revised, linked, complete, and checked before delivery/save.

Includes:

- Completion Revision / Second-Pass Editing.
- Linking Papers / Evidence Chain.
- Artifact Self-Check.
- Compose-Review-Reflect-Capture.
- report completeness/readback.

Why clean: this is too broad to live only inside Rule Quality.

### 4. Lifecycle / Staleness / Custody Alarm

Primary home: new Lifecycle / Staleness / Custody drawer.

Cross-links: Authority, Proof, Source/Lane, Agent/Mule/Bridge.

Job: prevent useful but stale objects from commanding work.

Labels to require:

- active
- current
- candidate
- support
- source-only
- parked
- broken
- retired
- stale as command
- bounded/proved
- unproved

Why clean: stale bridge notes, mule homes, source ore, memory, copied folders, old receipts, and candidate tools all share this failure family.

### 5. Alarm Fatigue / Overblocking Watch

Primary home: Meta Alarm Governors.

Cross-links: Growth/Bloat, Route/Root.

Job: stop every alarm from becoming a blocker during messy growth.

Trigger: the assistant is about to stop useful growth for a warning/watch issue.

Better action: downgrade to watch, park, or route with guardrails unless real damage is possible.

### 6. Proof Scope Inflation Alarm

Primary home: Proof / PASS / Save Integrity.

Cross-links: Artifact Completion, Authority.

Job: prevent narrow PASS from being reported as whole-system PASS.

Examples:

- a receipt proves file creation, not promotion.
- a live-use test proves one event, not adoption.
- a bridge proof proves Level 3 bounded package, not arbitrary shell.

### 7. Scaffold Expiration Alarm

Primary home: Meta Alarm Governors or Lifecycle / Staleness / Custody.

Cross-links: Growth/Bloat, Artifact Completion.

Job: prevent temporary scaffolds, firing cards, maps, and ladders from becoming permanent authority.

Action: each scaffold needs an expiration condition, next proof need, or parking state.

### 8. Stale Script / Stale Handoff Alarm

Primary home: Tool / Script / Copy Safety.

Cross-links: Proof, Lifecycle/Staleness, Mule/Bridge.

Job: generated scripts and handoffs become unsafe when HEAD, path, lane, or expected base moves.

Action: require expected-base checks and refuse stale runs.

### 9. Chain-of-Custody Lens

Primary home: Lifecycle / Staleness / Custody.

Cross-links: Proof, Source/Lane, Agent/Mule/Bridge.

Job: track origin, copy path, manifest, hash, receipt, return lane, and disposition.

Why clean: provenance material has multiple live uses and should not be buried only under mule/bridge.

### 10. Delivery Burden Alarm

Primary home: Tool / Script / Copy Safety.

Cross-links: Artifact Completion.

Job: stop screen-filling code, paste-trash risk, and user copy burden before delivery.

Action: use file-first artifact plus one clean launcher for long scripts.

### 11. Memory / Chat Not House Proof Alarm

Primary home: Source / Lane / Artifact Placement or Lifecycle / Staleness / Custody.

Cross-links: Authority, Proof.

Job: memory and chat can signal a house-relevant rule, but they are not local files, receipts, commits, or proof.

Action: save through local/Git route if accepted; otherwise park.

### 12. Duplicate Name / Word-Key Collision Alarm

Primary home: Rule Quality / Wording Coverage.

Cross-links: Lifecycle/Staleness, Meta.

Job: prevent labels like active, current, live, proof, pass, final, guide, rule, tool, bridge, mule, source, and parked from hiding different states.

Action: define, rename, narrow, or pair with neighbor term.

### 13. Missing Recovery Path Alarm

Primary home: Loss / Destructive Action.

Cross-links: Tool Safety, Proof.

Job: before cleanup, move, overwrite, compression, or Whirlpool, name how source/proof/recovery survives.

### 14. Helper Collision / Ownership Alarm

Primary home: Agent / Mule / Bridge Lifecycle.

Cross-links: Tool Safety, Proof.

Job: prevent parallel helper, mule, bridge, or worker outputs from colliding with active work.

Action: state ownership, active lane, read/write boundary, and return path.

### 15. Outside-Pattern Candidate: Alert Severity Hygiene

Primary home: Meta Alarm Governors.

Source: outside/general operations pattern candidate, not house authority.

Job: separate page/block alerts from ticket/warning/watch alerts.

House translation: not every alarm is a blocker. Severity must match damage and phase.

### 16. Outside-Pattern Candidate: Runbook Actionability

Primary home: Artifact Completion or Meta Alarm Governors.

Source: outside/general operations pattern candidate, not house authority.

Job: an alarm should point to a clear next action.

House translation: alarm card should say stop, inspect, park, prove, revise, recover, save, or downgrade.

### 17. Outside-Pattern Candidate: Post-Incident Learning Loop

Primary home: Meta Alarm Governors.

Source: outside/general operations pattern candidate, not house authority.

Job: after a failure, record trigger, missed detection, impact, repair, prevention, and owner.

House translation: failed-to-fire events should create a repair target or event receipt, not just a new name.

### 18. Outside-Pattern Candidate: Canary / Dry-Run

Primary home: Tool / Script / Copy Safety or Artifact Completion.

Source: outside/general operations pattern candidate, not house authority.

Job: test risky behavior on a narrow proof surface before full use.

House translation: live-use tests and firing cards are canaries; do not promote from one canary.

## House-found source material worth preserving

High-value house material that should inform future cabinet work:

- Think Before Work / Intake Alarm Gate.
- Work Request Sorting Formula and Place Finder.
- Rule-Firing Confirmation Before Action Gate.
- Relevant Root Key and Tool Use Selector.
- House-Wide Fog Alarm Candidate.
- Stop-and-Tool / Bookmark Rule.
- Split Proof / Save Flow Rule.
- Mr.Kleen / PowerShell Save Gate.
- PowerShell Copy Delivery Lint / Script Execution Rule.
- PowerShell Paste / False-Success Guard.
- Reusable Script Skeleton Pull Rule.
- Long Code Draft-Review-Send Gate.
- File-First Artifact With Launcher Balance Rule.
- Downloaded ps1 Resolver and Source Validation Rule.
- Completion Revision / Second-Pass Editing Rule.
- Linking Papers / Evidence Chain Rule.
- Directive-to-Artifact Separation Rule.
- Broad Words / Concept-Family Coverage Rule.
- Clean Seed Build vs Other Noise Phase Boundary Rule.
- Current Growth Bloat Tolerance / Polish-Then-Whirlpool Rule.
- Whirlpool Powerplay / Dense Growth Rule.
- Memory Update Is Not a House Rule / Save Repair Trigger.
- Project Rule Placement / No Chat Rules Rule.
- Project to Build Clean Seed Scope Boundary Rule.
- Build Keeps Form / Conceptual Same-Treatment Rule.
- Mule Worker, Not Supervisor / House Walk First.
- Mule Return Finalization Gate.
- Assistant Mule Exchange Bridge Rule.
- Mule 123 Working Doorway and Source-Only Rule.
- Local Hard Bridge Front Door Use Rule.
- Bridge Level3 Bounded House-Save Route Proof Rule.
- Bridge Level3 Result Receipt Repair Rule.
- No Rule King / Better-Fit Promotion Rule.
- Word-Key Clarity Checker Rule.
- Artifact Self-Check live-use proof notes.
- Rule-Concept-Event partial live-use proof.
- Source Note Quiet Self-Proof / Capture-Disposition Rule.
- Provenance / Chain-of-Custody lens material.

## Clean-bloat parking rule

Do not inject this appendix into doctrine.

Do not promote these candidates from existence.

Do not collapse them yet.

Future Whirlpool should compress only after repeated firing evidence shows which candidates are real, duplicate, stale, or decorative.
