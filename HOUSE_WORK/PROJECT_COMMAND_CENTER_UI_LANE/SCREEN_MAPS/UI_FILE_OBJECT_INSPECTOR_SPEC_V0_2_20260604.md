# UI File/Object Inspector Spec V0.2

Date: 2026-06-04
Status: CANDIDATE INSPECTOR SPEC / DESIGN ONLY / NOT IMPLEMENTATION
WorkKey: UI-FILE-OBJECT-INSPECTOR-SPEC-V0-2-20260604

## Purpose

The inspector gives one-object-at-a-time custody and fit without dumping project content.

## Required Fields

| Field | Meaning | Source |
|---|---|---|
| Path | exact relative project path | user selection or manifest |
| Type | file, folder, receipt, manifest, source handoff, script, archive | metadata |
| SHA256 | content hash for files | hash command |
| Owner lane | durable lane that owns the object | path map or lane rule |
| Status | candidate, receipt, source, parked, support, blocked, local-only | path map or receipt |
| Proof pointer | manifest/receipt that supports the status | receipt or manifest row |
| Related artifacts | source, derived spec, TODO, receipt, rollback row | path map |
| Allowed actions | inspect, show proof, route, stage, park, reject | recipe registry |
| Blocked actions | run, activate, delete, broad export, pointer mutate | boundary rule |
| Last touched receipt | most recent proof event | receipt path/hash |

## Inspector Output Shape

```text
OBJECT_INSPECTED_WITH_BOUNDARY
Path:
Type:
SHA256:
OwnerLane:
Status:
ProofPointer:
AllowedActions:
BlockedActions:
DoesNotProve:
NextLegalAction:
```

## Guardrails

- Never treat source as authority without fit/proof.
- Never infer a durable lane from root location alone.
- Never inspect by broad raw dump unless the user asks for that exact file/excerpt.
- Scripts are inspectable as files but not runnable from this spec.
