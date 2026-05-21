# Child Shell Actuator Rule

Date: 2026-05-21
Lane: BRAIN_LEARNING
Status: SUPPORT RULE / LIVE-TESTED / NOT DOCTRINE

## Purpose

The assistant must not treat raw PowerShell as the bridge-facing surface.

PowerShell is the parent engine. The bridge-facing surface is a smaller child shell: a named, allowlisted action layer with hardstops, root guards, false-success guards, and receipts.

## Clean definition

Child Shell = request -> policy gate -> named safe function -> local PowerShell execution -> response and receipt.

The child shell exposes only approved limbs. It does not expose arbitrary shell.

## Why this matters

The safe answer to PowerShell risk is not fear of PowerShell. The safe answer is a smaller command surface.

The child shell is the bridge's local actuator boundary. It lets the assistant use local capability without giving the assistant a terminal.

## V1 allowed child limbs

- ping;
- front_door;
- powershell_check;
- list/read/write_new_text/hash inside bridge WORKSPACE;
- house_front_door read-only;
- house_list read-only;
- house_read_text read-only;
- house_hash read-only.

## V1 hardstops

- no arbitrary shell;
- no delete;
- no overwrite;
- no executable/script writes;
- no path traversal;
- no house write;
- no git commit;
- no git push;
- no network service;
- no success if the returned state is nonsense.

## Live-test proof

A first live test ran through Local Hard Bridge V1.

It proved:
- house_front_door returned real clean git state;
- one write_new_text action created a new file inside WORKSPACE;
- a later write_new_text to the same target was blocked as overwrite;
- raw shell action was blocked as unknown/disallowed;
- receipts were created for each request.

## Watch item

The first test had a label/order issue: request files were processed alphabetically, so the request named OVERWRITE_BLOCK created the file first, and the request named WRITE became the overwrite-blocked request.

This does not invalidate the child-shell behavior proof, but it does prove dependent bridge tests must use ordered request names or separate phases.

## Rule

Future bridge expansions must add child limbs, not raw shell.

Every new child limb must state:
- trigger;
- allowed root;
- blocked paths/actions;
- overwrite/delete rule;
- proof output;
- receipt output;
- false-success guard;
- rollback or cleanup path;
- promotion boundary.

## Boundary

This support rule does not install doctrine and does not expand Local Hard Bridge V1 permissions.
