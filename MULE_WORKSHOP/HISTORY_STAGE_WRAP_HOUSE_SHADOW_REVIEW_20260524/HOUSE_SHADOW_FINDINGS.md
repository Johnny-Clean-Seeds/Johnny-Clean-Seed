# House Shadow Findings

Date: 2026-05-24

## Finding 1 - Live Path / Active Sign Mismatch

Severity: high.

Evidence:

- CURRENT_TRUTH_INDEX.txt and AGENTS.md still point to C:\Users\13527\Desktop\Jxhnny_Kleen_C3dz.
- The current live house is C:\Users\13527\Desktop\123\Jxhnny_Kl33N_Seedz.
- Test-Path result on 2026-05-24: old path false, live path true.

Risk:

The house can be clean inside a pass and still send future workers to the wrong door.

Clean placement:

Create a scoped TODO for path/home/sign repair. Do not mass-replace historical receipts. Do not rewrite CURRENT_TRUTH_INDEX or active guides without a scoped repair pass, because ACTIVE_ANCHOR currently blocks active-guide/current-truth rewrites by momentum.

## Finding 2 - TODO Load Is Becoming A Second Fog Bank

Severity: medium.

Evidence:

- COMMAND_CENTER\TODO contains many "next use" items.
- HOUSE_WORK\TODO also carries many parked items.

Risk:

The TODO system can become a memory pile instead of a route selector.

Clean placement:

Run the TODO list through the same stage-card washer: one TODO object, owner, trigger, proof target, close condition, route. Burn active weight for any TODO that has no route effect, leaving a runner trace.

## Finding 3 - Duplicate CleanMilkChecker Surfaces

Severity: medium.

Evidence:

- CleanMilkChecker exists at CleanMilkChecker and CleanSeedsBuild\CleanMilkChecker.
- Sampled hashes differ, while no meaningful content diff surfaced in the quick no-index stat sample.

Risk:

Duplicate surfaces can create source-of-truth confusion even when the content is only line-ending or formatting drift.

Clean placement:

Create a source-of-truth review before editing either copy. If both are intentionally kept, mark one as active and one as archive/reference.

## Finding 4 - LocalBot Evidence Is Repeated In Multiple Places

Severity: low to medium.

Evidence:

- LocalBot evidence appears in Public Proof Packets, SOURCE_TRANSFER, and GPT prompt custody loose candidates.
- Some copies are identical by hash; one plain-text candidate differs by formatting.

Risk:

Evidence duplication is useful for custody, but without a source marker it adds review weight.

Clean placement:

Mark canonical proof surface and preserve the rest as custody/reference copies.

## Finding 5 - Support Rules Are Starting To Act Like A Rule Pile

Severity: medium.

Evidence:

- The recent house added many good rules around rope, washer, tug, runner, burn, schedule, gate, and note weight.
- The active anchor already warns not to open broad rule piles without a real task.

Risk:

Good rules can become fog if every pass tries to wear all of them at once.

Clean placement:

Use a suit selector: only wear rules triggered by the current object. The default loadout for a history wrap is source map, stage card, note burn, runner trace, washer.

## Finding 6 - Remote Door Token Audit Is Parked Correctly But Still Sensitive

Severity: medium.

Evidence:

- COMMAND_CENTER\TODO\TODO_REMOTE_DOOR_TOKEN_TRACKING_SECURITY_AUDIT_20260524.md exists.

Risk:

Security material should stay named and tracked without exposing secrets in summaries.

Clean placement:

Keep as scoped TODO. Do not print token values. Do not broaden into unrelated remote-door work during this pass.

## Washer Pass 1

The biggest shadow is not a missing concept. It is a sign mismatch that can route future work to a dead home path.

## Washer Pass 2

After wearing the stage-card pattern, the shadows separate cleanly:

- path/home sign repair is the next best active fix
- TODO load is a later sorting pass
- duplicates need source-of-truth marking
- support rules need a suit selector

## Verdict

PASS WITH GUARDRAILS.

Promote the history-stage routine as support. Create the scoped path/home/sign TODO. Do not rewrite active authority in this pass.
