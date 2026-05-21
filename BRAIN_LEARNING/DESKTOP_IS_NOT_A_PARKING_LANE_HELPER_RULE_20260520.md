# Desktop Is Not A Parking Lane - Helper Delivery Rule

Date: 2026-05-20
Lane: BRAIN_LEARNING
Status: ACTIVE BEHAVIOR RULE / DELIVERY HYGIENE
Base before save: 11bf30e

## Rule

Desktop is not a parking lane.

If the assistant creates or sends a one-time helper script, generated file, scratch artifact, download, or temporary delivery file for Desktop use, it must not be left there after its job is complete.

## Default behavior

After successful proof, a temporary Desktop helper must be one of these:

1. deleted from Desktop;
2. moved into Mr.Kleen as a proved tool or tool-candidate with receipt;
3. explicitly marked for the user to keep.

Default = delete after successful proof.

## Correct helper pattern

A one-time helper should not require the user to notice trash and ask for cleanup later.

Correct flow:

helper runs
-> proof passes
-> helper cleans itself or routes itself into the house
-> final copy-back block reports the cleanup/routing

## Blocked behavior

Do not leave one-time helpers on Desktop as loose files.
Do not treat Desktop as Work Shed, Tool Cabinet, Proof History, Source Ore, or archive.
Do not make cleanup a second afterthought when the cleanup could have been built into the successful helper path.
Do not make the user babysit temporary files the assistant created.

## Self-clean standard for future helper scripts

When a generated Desktop helper is temporary, include a final successful-proof cleanup path.

The helper should only clean itself after:

- the intended save/action completed;
- git commit/push proof passed when applicable;
- HEAD matches origin/main when applicable;
- final status is clean when applicable;
- the copy-back block was printed;
- the helper is known to be temporary.

If the helper should be preserved, route it into Mr.Kleen as a tool/tool-candidate instead of leaving it on Desktop.

## Exception

The assistant may leave a file on Desktop only when the user explicitly asks to keep it there, or when it is a user-facing downloadable artifact meant for the user's own use and the assistant clearly labels that role.

## Power-play lesson

A clean repo save is not enough if the delivery path leaves trash outside the house.

The house got clean; the porch got littered. That is a delivery-hygiene failure.

Future saves must judge both:

- house proof;
- delivery cleanup.
