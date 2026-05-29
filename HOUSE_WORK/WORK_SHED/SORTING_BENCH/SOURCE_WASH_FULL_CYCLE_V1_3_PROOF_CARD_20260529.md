# Source Wash Full Cycle V1.3 Proof Card

Date: 2026-05-29
RunId: 20260529_032818
ScriptWrapperVersion: V2.0
Status: HELPER CONTROLLER CANDIDATE / PROVED REPORT-ONLY RUN
Authority: not doctrine; not ACTIVE_GUIDES; not CURRENT_TRUTH_INDEX

## Object

RUN_SOURCE_WASH_FULL_CYCLE_V1.3.ps1

Saved helper-controller candidate:

HOUSE_WORK/WORK_SHED/TOOLS/SOURCE_WASH/RUN_SOURCE_WASH_FULL_CYCLE_V1_3.ps1

Source script path used for this save:

$SourceScriptFull

Source SHA256:

$sourceSha

Repo copy SHA256:

$repoScriptSha

## Wrapper repair note

V1.0 of this lock-save wrapper used a target-side -AllowGitWrites switch. The Code Gate runner uses -AllowGitWrites at the runner level and did not forward that switch into the target script, so V1.0 correctly stayed in probe mode instead of saving. V1.1 fixed the wrapper contract: default execution is the save path, while -ProbeOnly is available for an explicit dry probe. V1.2 fixes the proof-reader contract: state.json fields are read through property-safe accessors so missing or renamed fields fall back to the chat-proved defaults instead of crashing under StrictMode. V1.3 fixes the ignored-path staging contract attempt. V1.4 fixes the dirty-status parser contract. V2.0 cuts the staging branch: check-ignore is witness only; the exact manifest is authority; every intended file is force-added by exact path only; staged-set verification blocks missing or extra paths before commit.

## Why this object exists

RUN_SOURCE_WASH_FULL_CYCLE_V1.3.ps1 is the first version of the Source Wash Full Cycle controller that passed both the Code Gate probe path and the real bounded -Run path with the embedded HELPER_STABILITY_GOVERNOR_V1.

V1.1 passed probe but failed the real run with a scalar/count shape bug.

V1.2 passed probe but failed the real run with a broad-root detector array-shape bug.

V1.3 fixed those runtime shape problems and completed a bounded report-only source wash.

## Proof summary

Code Gate probe:

- Syntax: PASS
- Target probe: PASS
- Final verdict: PASS WITH WATCH
- Watch reason: target ran probe path with expected warning/watch behavior

Real bounded run:

- EndState: B_CLEAN_CLOSE
- WashVerdict: WASH_CLEAN_REPORT_ONLY
- Processed: 29
- Queued: 29
- ReadCount: 29
- SkippedCount: 0
- ErrorCount: 0
- RoughSpotCount: 0

Governor result:

- GovernorState: SMOOTH_RAMP
- GovernorGear: CRUISE
- GovernorBatchSize: 14
- GovernorSleepMs: 64
- GovernorThrottleEvents: 0
- GovernorRampEvents: 2

The governor proved a clean smooth-ramp behavior under this bounded load: it did not throttle, did not choke, and ramped only after smooth conditions appeared.

## Local proof artifacts

These artifacts remain local proof/run output. They are referenced and hashed here; they are not copied wholesale into Git.

| Artifact | Exists | Local path | SHA256 |
|---|---:|---|---|
| Report | True | $(@{Label=Report; Path=C:\Users\13527\Desktop\123\_MISC_DRAWER\READ_REPORTS\FULL_WASH_CYCLE_V1_3_20260529_031053\SOURCE_WASH_FULL_CYCLE_V1_3_REPORT.md; SHA256=96D7F2FB64358FDBCAC167C99DE103E0D2C9D4C5B2D47C1D61C9F53645355C19; Exists=True}.Path) | 96D7F2FB64358FDBCAC167C99DE103E0D2C9D4C5B2D47C1D61C9F53645355C19 |
| DecisionLedger | True | $(@{Label=DecisionLedger; Path=C:\Users\13527\Desktop\123\_MISC_DRAWER\READ_REPORTS\FULL_WASH_CYCLE_V1_3_20260529_031053\decision_ledger.csv; SHA256=DFC69343EAD33C7338FD05FE95F644258864A861754444099D66684803104F32; Exists=True}.Path) | DFC69343EAD33C7338FD05FE95F644258864A861754444099D66684803104F32 |
| RoughSpotLedger | True | $(@{Label=RoughSpotLedger; Path=C:\Users\13527\Desktop\123\_MISC_DRAWER\READ_REPORTS\FULL_WASH_CYCLE_V1_3_20260529_031053\rough_spot_ledger.csv; SHA256=50D82969AD0B2D1A81666F35663DB067BE1A4B434322EB404C52A995B13CE5DF; Exists=True}.Path) | 50D82969AD0B2D1A81666F35663DB067BE1A4B434322EB404C52A995B13CE5DF |
| GovernorTelemetry | True | $(@{Label=GovernorTelemetry; Path=C:\Users\13527\Desktop\123\_MISC_DRAWER\READ_REPORTS\FULL_WASH_CYCLE_V1_3_20260529_031053\governor_telemetry.csv; SHA256=B891313465517A000A6DD907F8EC68E37311B852F4E8B1DF0F7E9C9760040F5F; Exists=True}.Path) | B891313465517A000A6DD907F8EC68E37311B852F4E8B1DF0F7E9C9760040F5F |
| StateJson | True | $(@{Label=StateJson; Path=C:\Users\13527\Desktop\123\_MISC_DRAWER\READ_REPORTS\FULL_WASH_CYCLE_V1_3_20260529_031053\state.json; SHA256=61D78000E9DB6F88304941682BB1FA48F019A17F979C96C51E9E0B1C9DC1C2C0; Exists=True}.Path) | 61D78000E9DB6F88304941682BB1FA48F019A17F979C96C51E9E0B1C9DC1C2C0 |
| RopeLedger | True | $(@{Label=RopeLedger; Path=C:\Users\13527\Desktop\123\_MISC_DRAWER\READ_REPORTS\FULL_WASH_CYCLE_V1_3_20260529_031053\rope_ledger.md; SHA256=245DB7E7221F85F52BFC290E1E9A689559CD79AF5DBD2F919C027CD33FB1F2CB; Exists=True}.Path) | 245DB7E7221F85F52BFC290E1E9A689559CD79AF5DBD2F919C027CD33FB1F2CB |
| OptionalReceipt | True | $(@{Label=OptionalReceipt; Path=C:\Users\13527\Desktop\123\_MISC_DRAWER\READ_REPORTS\FULL_WASH_CYCLE_V1_3_20260529_031053\SOURCE_WASH_FULL_CYCLE_V1_3_RECEIPT.txt; SHA256=6E4645DC273510B64DCC53B2845B69FF278523CA4457D74D1FF42F97EC014EB7; Exists=True}.Path) | 6E4645DC273510B64DCC53B2845B69FF278523CA4457D74D1FF42F97EC014EB7 |

## Boundary held

- report-only wash;
- no source writes;
- no move/delete;
- no Git during wash run;
- no doctrine promotion;
- no ACTIVE_GUIDES edit;
- no CURRENT_TRUTH_INDEX edit;
- no automation;
- no dashboard;
- no helper module promotion.

## Placement judgment

This object belongs in the helper/tool evolution lane as a proved helper-controller candidate.

It is allowed to be reused as a source pattern for later helper-controller builds, but it is not general authority and does not skip future Code Gate checks.

## Next clean route

Use this proved controller as the working base for the next bounded source-wash run or for a later V2 helper improvement only after a specific need appears.

Potential next needs:

- inspect V1.3 report content if the user wants source-wash findings;
- run a slightly larger bounded root with the same report-only boundary;
- build a reusable helper-controller harness only after multiple helpers prove the same governor pattern;
- do not promote to doctrine from this proof alone.

