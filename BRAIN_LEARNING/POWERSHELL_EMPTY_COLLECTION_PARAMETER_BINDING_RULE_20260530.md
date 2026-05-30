# PowerShell Empty Collection Parameter Binding Rule

Date: 2026-05-30
RunId: 20260530_003810
WorkKey: KEY_2E6F99ED9EFE
Status: SUPPORT RULE / POWERPLAY LEARNING / CHECKPOINTED

## Failure family

PowerShell function parameters can reject an empty collection when a parameter is mandatory and the value is an empty array/list, unless the parameter explicitly allows empty collections or the function avoids passing the starter collection as a mandatory parameter.

Live failure:

`Add-PlanItem: Cannot bind argument to parameter 'Plan' because it is an empty collection.`

## What actually happened

The plan object existed and was correct as an empty `System.Collections.ArrayList`, but the function parameter binder rejected it before the first item could be added.

## Repair pattern

Prefer a script-scoped plan collector function that owns the list internally, or use:

`[Parameter(Mandatory=$true)][AllowEmptyCollection()][System.Collections.ArrayList]$Plan`

## Rule

When a helper builds a plan/list/map/ledger incrementally, the empty starting collection is valid input. The function must allow it or initialize it internally.

## Reopen trigger

Reopen this rule if a generated PowerShell helper fails while passing an empty array/list/hashtable into a function that is supposed to fill it.
