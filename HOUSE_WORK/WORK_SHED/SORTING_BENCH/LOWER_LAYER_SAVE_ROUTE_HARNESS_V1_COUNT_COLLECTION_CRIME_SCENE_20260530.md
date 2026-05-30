# Crime Scene Freeze — Lower-Layer Save Route Harness V1 Collection Count Failure

Date: 2026-05-30
Status: CRIME SCENE / LOWER-LAYER COLLECTION-SHAPE FAILURE / NOT DESIGN FAILURE
WorkKey: LOWER-LAYER-SAVE-ROUTE-HARNESS-ROOT-REPAIR-20260530-V1-2

## Upper object frozen

Lower-Layer Save Route Harness Root Repair V1.

## What happened

The V1 root-repair harness passed Code Gate parser/probe with watch, then direct run failed before save completion.

Observed direct error:

`The property 'Count' cannot be found on this object. Verify that the property exists.`

## Who did what

- User ran Code Gate and direct commands from `C:\Users\13527\Desktop\123`.
- Assistant generated the defective V1 root-repair harness.
- The script failed at lower-layer collection handling.

## How

The script used `.Count` on values returned from helper/list functions without forcing those values into arrays. PowerShell can collapse zero/one outputs into `$null` or scalar objects, especially through function output enumeration.

## Root relation

This belongs to the same lower-layer save-route harness family:

- V1.2 interpolation.
- V1.3 argument binding.
- V1.5 staged-set equality.
- Root-harness V1 collection shape.

## Repair

V1.2 normalizes list outputs with `@(...)` at call sites and returns arrays from helper functions using unary comma where needed.

## Need-to-know helper evidence

- PowerShell generator needs collection-normalization guard.
- Git/save helper needs staged/unstaged/status arrays.
- Upper chat-source object only needs to know the root repair remains frozen until V1.2 proves completion.

## Boundary

No broad refactor, delete, move, watcher, automation, Whirlpool, doctrine, ACTIVE_GUIDES, CURRENT_TRUTH_INDEX, universal mapper, graph database, or whole-house crawl.