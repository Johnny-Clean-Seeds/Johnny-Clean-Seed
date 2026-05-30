# Crime Scene Freeze — Living System Bridge/Tunnel V1.3 Parser Failure

Date: 2026-05-30
WorkKey: LIVING-SYSTEM-FRONT-DOOR-BRIDGE-TUNNEL-20260530-V1-4
RepairKey: CRIME-SCENE-FREEZE-LSBT-V1-3-PARSER-FAILURE
Status: LOWER-LAYER ERROR RECORD / V1.4 REPAIR INPUT / NOT DESIGN EXPANSION

## Freeze call

User called: `crime scene freeze`, `record`, `get evidence`, `who did what how when where ect`.

Upper object frozen: Living System Front Door / Bridge-Tunnel save package.

Lower-layer failure: PowerShell parser failure in generated V1.3 save script.

## Who

- Assistant generated `LOCK_SAVE_LIVING_SYSTEM_FRONT_DOOR_BRIDGE_TUNNEL_V1.3.ps1`.
- User ran Code Gate from `C:\Users\13527\Desktop\123`.
- PowerShell Code Gate blocked the target before execution.
- User then ran the target directly and exposed the parser error.

## What

Parser error in function `Assert-PathExists`:

`throw "Missing $Label: $Path"`

PowerShell parsed `$Label:` as an invalid variable reference because `:` directly followed the variable name inside a double-quoted string.

Correct repair:

`throw "Missing ${Label}: $Path"`

or equivalent format-string construction.

## When

Evidence pasted in chat on 2026-05-30. Code Gate report timestamp in user output:

`POWERSHELL_CODE_GATE_RUNNER_REPORT_V1.4_20260530_121045_LOCK_SAVE_LIVING_SYSTEM_FRONT_DOOR_BRIDGE_TUNNEL_V1.3.ps1.md`

## Where

User shell location:

`PS C:\Users\13527\Desktop\123>`

Target script:

`C:\Users\13527\Downloads\LOCK_SAVE_LIVING_SYSTEM_FRONT_DOOR_BRIDGE_TUNNEL_V1.3.ps1`

Reported parser location:

`Line 26`

## How

The assistant produced a generated PowerShell string with unsafe colon-adjacent variable interpolation. Code Gate syntax check detected the parser failure and correctly refused to run the target.

The direct run confirmed the exact parser mechanism:

`Variable reference is not valid. ':' was not followed by a valid variable name character. Consider using ${} to delimit the name.`

## Evidence

Code Gate output:

- `Final verdict: BLOCKED - CODE GATE DID NOT RUN TARGET`
- `Syntax: FAIL`
- `Blockers: 1`
- `Run verdict: NOT RUN - blockers exist`
- `Child target status: TARGET_NOT_RUN`

Direct PowerShell output:

- `ParserError`
- target file: `LOCK_SAVE_LIVING_SYSTEM_FRONT_DOOR_BRIDGE_TUNNEL_V1.3.ps1`
- line: `26`
- failing phrase: `Missing $Label: $Path`

## Fault split

Concept failure: NO.

House design failure: NO.

Lower-layer script generation failure: YES.

Code Gate behavior failure: NO. Code Gate did its job by blocking target execution.

Assistant process failure: YES. The generated script was not parser-clean.

## Repair

V1.4 performs a narrow repair:

- changes `$Label:` interpolation to `${Label}:`;
- records this crime-scene evidence;
- preserves the V1.3 design intent;
- does not broaden the ledger/bridge design;
- does not update ACTIVE_ANCHOR by default;
- keeps all blocked lanes blocked.

## Boundary

No broad refactor. No delete. No move. No watcher. No automation. No Whirlpool. No doctrine. No ACTIVE_GUIDES. No CURRENT_TRUTH_INDEX. No universal mapper. No graph database. No whole-house crawl.