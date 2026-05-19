# Predictive Learning And Mule Flow Review Report

Status: hard critique package only.
Authority: outside reviewer / mule, not final authority.
Current send position checked: main @ 9fb81c7be4f3f8fc92d24674ea8b6ed95afba8ea.
Handoff inspected: HOUSE_WORK\WORK_SHED\AGENT_HANDOFFS\PREDICTIVE_LEARNING_AND_MULE_FLOW_CRITIQUE_HANDOFF_20260519.md.

## Executive Verdict

EVIDENCE: The candidate loop is pointed at the right failure: the house has enough old receipts, failures, wins, source-ore, gear, and mule patterns that repeating slow one-by-one handling is no longer acceptable when a connected batch or known failure shape is visible.

INFERENCE: The loop should not be installed under the name "Future-Prediction Learning Loop." That name is too mystical and can invite confidence theater. The stronger name is:

Prior-Mistake Retrieval And Route Selection Gate.

Best current shape:

1. Classify the current situation.
2. Retrieve similar prior failures, wins, and parked candidates by tags.
3. Choose route: batch safe-bin, one-by-one inspection, mule critique, or direct next action.
4. Prove the chosen route against speed, safety, placement, and proof-path criteria.
5. Save only the smallest reusable lesson and retrieval tags.

UNKNOWN: Whether the house already has a single durable index that can retrieve prior mistakes quickly. The scan found many useful pieces, but not one compact retrieval index dedicated to lessons/failures.

## 1. Strong Parts

EVIDENCE: Existing house rules already support the candidate direction:

- Awareness before action exists in BRAIN_LEARNING\AWARENESS_CLASSIFIES_STATE_BEFORE_ACTION_20260519.md.
- Batch handling exists in BRAIN_LEARNING\BATCH_SAFE_BIN_TRIAL_SUIT_RULE_20260519.md and HOUSE_WORK\WORK_SHED\INCOMING_FILE_PARKING\BATCH_SAFE_BIN_TRIAL_SUIT_METHOD_20260519.md.
- Critique learning exists in BRAIN_LEARNING\ADAPT_ADOPT_CRITIQUE_LEARNING_GATE_20260519.md.
- Tool trial / gear rack logic exists in TOOL_SHED and HOUSE_WORK\WORK_SHED\GEAR_RACK.
- Prior false-pass failures are captured in Work Shed sorting notes.

INFERENCE: The strongest part is not "prediction." It is retrieval before route choice. A future failure is often visible because the same shape already failed: stale state, split custody, one-file drag on connected batches, guard failure followed by fake success, receipt without artifact, or source-ore pretending to steer.

Real advantage: safer and faster. It avoids re-inspecting every piece from zero when prior evidence already identifies the dangerous edge.

## 2. Vague Or Risky Parts

EVIDENCE: The candidate says "retrieve prior similar failures and wins," but it does not define how similarity is found, what fields are required, or what counts as enough retrieval.

Risks:

- "Predict likely failure" can become confidence without evidence.
- "Save the lesson" can create another note that never fires.
- "Install only after proof" is correct but too late in the loop if route choice already went wrong.
- Mule output can return cleanly only if the handoff also specifies manifest, file roles, status labels, and expected proof fields.
- Big issue labs can become a new junk drawer unless every lab has close conditions and parking states.

Better constraint: predictions must be labeled as INFERENCE until matched to prior evidence and a current trigger.

## 3. Rename Recommendations

Reject as active name:

- Future-Prediction Learning Loop

Reason: it overstates what the method does.

Better names:

- Prior-Mistake Retrieval And Route Selection Gate
- Case Retrieval Gate
- Known-Shape Route Gate
- Lesson Retrieval Before Motion

Use now: Prior-Mistake Retrieval And Route Selection Gate.

Reason: it names the real behavior, prevents mysticism, and points to retrieval plus route choice.

## 4. Smallest Installable Version

Install nothing into active doctrine yet.

Smallest safe install candidate:

Create one Work Shed / Soft Suit card that says:

- Trigger: repeated failure, connected batch, old/new/stale mix, mule return, proof/receipt mismatch, or long painful route starting.
- Action: retrieve 3 to 7 similar prior cases by tags before choosing route.
- Route decision: batch safe-bin, one-by-one inspect, direct action, mule critique, park, or block.
- Proof: name advantage type, evidence, tradeoff, risk, and close condition.
- Save: only add lesson tags if they will improve future retrieval.

Why this is better than the current candidate:

- Faster: the assistant does not run the full 12-step loop for every task.
- Safer: it starts with trigger and evidence, not prediction language.
- Less stale-pointer risk: it requires current state and prior-case tags before route choice.
- Less house drag: one small card uses existing gear instead of building a new doctrine stack.

## 5. Folder Structure For Big Issue Labs

Use a lab only when the issue is too large for one Work Shed note and needs mule or multi-pass review.

Recommended model is in PROPOSED_FOLDER_MODEL.md.

Key critique: the candidate folder shape is good but missing a lesson index, retrieval key file, and closeout state. Without those, labs will be findable by date but not by future failure shape.

## 6. Prior-Mistake Indexing

Minimum retrieval index fields:

- lesson ID
- failure mode
- trigger phrase / condition
- lane
- artifact path
- authority state
- proof anchor
- current-status risk
- route chosen
- route result
- future-use trigger
- do-not-repeat warning

Do not index every note equally. Index only lessons that changed behavior, prevented a repeat failure, or should be retrieved before a similar route.

## 7. Bitstring / Tag Fields

Use readable tags first. Optional bitstring/check-vector fields may support retrieval but must never replace readable proof.

Recommended schema is in PROPOSED_TAG_SCHEMA.md.

Best compact fields:

- AUTH: active / support / source-ore / parked / candidate / proof
- FMODE: stale-state / false-pass / custody-gap / batch-split / source-promotion / tool-risk / proof-gap / ghost-boss
- ROUTE: batch / inspect-one / direct / mule / park / block
- REV: two-way / one-way / unknown
- PROOF: hash / receipt / commit / test / none
- RESULT: helped / hurt / partial / blocked / unknown

## 8. Batch Handling Trigger

Use faster batch handling when all are true:

- items arrived together or depend on each other,
- one-by-one review risks fake ghosts,
- no item requires immediate private/security isolation or execution,
- source/custody can be preserved,
- batch can be tested as a set without promotion.

Use one-by-one inspection when any are true:

- executable scripts,
- private/security material,
- unclear provenance,
- authority-changing files,
- specific collision-causing item,
- destructive or irreversible action risk.

Option A is better when:

- Batch safe-bin is better for connected mule returns, checker batches, multi-file reports, and companion artifacts.

Option B is better when:

- One-by-one inspection is better for scripts, secrets, authority changes, or high-risk collisions.

Evidence that decides later:

- Whether batch-level fit reduces false positives without hiding a risky item.

Use now:

- Batch safe-bin for mule return intake.
- One-by-one for executable or private/security items inside the batch.

## 9. Mule Output Shape

Mule output should always return as one folder with:

- MANIFEST.md first.
- REVIEW_REPORT.md as the main report.
- CANDIDATE or PROPOSAL files separated from evidence.
- OPTIONAL_SUPPORT for raw comparisons and source notes.
- No active doctrine edits.
- No command instructions that pretend to be authority.
- File roles: report, evidence, candidate, source-ore, do-not-use.
- Status labels: adopt, adapt, test, park, reject-as-active, do-not-build-yet.

Real advantage: easier intake. The assistant can read manifest first, know the role of each item, and safe-bin the whole return without guessing.

## 10. Reject Or Park

Reject now:

- Full knowledge graph build.
- Full runtime automation.
- Numeric trust score pretending precision.
- Blockchain / transparency-log style custody.
- Full FMEA ritual for every issue.
- Automatic doctrine update from lesson index.
- Auto-running tool candidates.
- Mule output treated as steering authority.

Park:

- Formal ontology.
- Graph database.
- Full case-based reasoning engine.
- SBOM/provenance framework imports.
- Decision-record registry for every tiny move.
- Cross-house dashboard.
- Merkle/hash tree lineage.

Keep unchanged:

- Source-of-truth order.
- Active guide protection.
- Work Shed as support lane.
- Batch safe-bin boundary.
- Tool Trial Ledger.
- Proof-before-promotion.

## 11. Internal Material Scan

Checked and applicable:

- ACTIVE_GUIDES: active authority and proof discipline.
- CURRENT_TRUTH_INDEX.txt and ACTIVE_ANCHOR.txt: source routing and active-ball boundary.
- BRAIN_LEARNING awareness, batch safe-bin, adapt/adopt, queue, incoming parking, guard-fail rules.
- Work Shed predictive capture and batch method notes.
- Tool Shed index, crib, and room maps.
- Gear Rack map and promotion reviews.
- PowerShell false-pass and failed-proof sorting notes.
- Issue Intake / Boss-vs-Ghost bench.
- Provenance lens reviews and mule intake summary.
- Algorithm and bitstring source-ore shelves.
- Joji 88 route-picking and 3/6/9 sieve notes.

Checked but not used as direct authority:

- Source-ore algorithm shelves.
- Bitstring ledgers.
- Public notes and Joji method tournament reports.
- Mule report intake examples.
- Tool candidates.

Do not apply now:

- Runtime kernel lanes.
- Full PROOF_HISTORY restructuring.
- Full tool promotion.
- Active guide rewrite.

## 12. Outside Method Scan

Useful mechanisms:

- Lessons learned: turn prior failures into retrieval triggers.
- After-action review: convert event into small action items and proof needs.
- Retrospective: focus on what to start, stop, continue.
- OODA: observe and orient before deciding route.
- Decision logs / ADR: record decision, context, consequence, supersession.
- Knowledge graphs: useful as a later retrieval model, too heavy now.
- Tagging / taxonomy: best near-term retrieval mechanism.
- Case-based reasoning: closest outside family to "similar prior failure."
- FMEA / pre-mortem: useful for high-risk route prediction, too heavy as default.
- Workflow automation: later only after manual fields prove stable.
- Systems thinking: useful for parent/child and neighbor effects.
- Library/catalog methods: useful for manifest-first and index-first retrieval.
- Search/retrieval methods: use targeted search by tags and failure modes.

Rejected or parked:

- Full frameworks when one mechanism is enough.
- Mandatory postmortem ceremony.
- Tool automation before field stability.
- Numeric scoring without trace.

## 13. Tool-Building Improvement

This method can help tools build better tools if the first tool is not a large automation. The first tool should be a lesson index and retrieval template.

Future worker/tool made easier:

- Mule return intake checker.
- Lesson retrieval search helper.
- Handoff completeness checker.
- Safe-bin manifest validator.
- Prior-failure trigger suggester.
- Tool candidate promotion reviewer.

Repeated work removed:

- Re-explaining old failure classes.
- Rereading broad source-ore.
- Rebuilding mule return contracts from scratch.
- One-by-one handling of connected batches.

Mistakes prevented:

- Stale pointer trust.
- Source-ore promotion.
- False PASS after failed proof.
- Receipt without artifact.
- Tool candidate execution before inspect.
- Mule report overclaim acceptance.

## 14. Controlled Idea-Bounce Result

Disagreement with the candidate:

- The 12-step loop is too linear and broad for point-of-work use.
- "Prediction" is the wrong center. Retrieval and route choice are the center.
- The loop lacks an explicit stop condition for when direct action is already safe.
- It does not define the minimum index fields that make future retrieval possible.
- It under-specifies mule return intake.

Stronger alternative:

Prior-Mistake Retrieval And Route Selection Gate:

TRIGGER -> STATE CLASSIFY -> RETRIEVE SIMILAR CASES -> CHOOSE ROUTE -> PROVE ADVANTAGE -> ACT/PARK/BLOCK -> SAVE LESSON TAGS ONLY IF USEFUL.

What should remain unchanged:

- No promotion without proof.
- Mule is not authority.
- Work Shed and source-ore are support material.
- Batch safe-bin / trial suit remains the right pattern for connected batches.
- Executables remain inspect-before-execute.

## 15. Finish Discipline

Smallest safe install:

- One Soft Suit / Work Shed card for Prior-Mistake Retrieval And Route Selection Gate.
- One companion lesson tag template.
- No active guide edit yet.

Stronger later version:

- HOUSE_WORK\WORK_SHED\LESSON_INDEX with a compact LESSON_INDEX.md and one case file per high-value failure/win.
- Mule return manifest checker after two or three manual returns prove stable.
- Optional graph/link view only after tag retrieval becomes insufficient.

Do-not-build-yet list:

- Full knowledge graph.
- Runtime watcher.
- Automated predictive engine.
- Full FMEA/postmortem ritual.
- Numeric trust scoring.
- Auto-promotion pipeline.
- Cryptographic provenance infrastructure.
- Big dashboard.
- Active guide rewrite.

Proof needed for each proposed improvement:

- Soft Suit card: test on one real connected batch or stale-state case; evidence must show faster route or safer stop.
- Lesson tag template: retrieve at least one prior failure faster than broad search and choose a better route.
- Lesson index: three indexed cases must be found by trigger/failure-mode tags and change the next action.
- Mule return contract: next mule return must arrive with manifest first and reduce intake ambiguity.
- Future checker/tool: must validate manifest/tag completeness without executing candidate tools or promoting content.

Final conclusion:

EVIDENCE: The candidate is directionally right and matches several existing house lessons.
INFERENCE: The best now-version is smaller, renamed, tag-driven, and route-focused.
UNKNOWN: Whether a manual lesson index will stay light after multiple uses; test before automation.

