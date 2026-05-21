# Adopt / Adapt Found Fix Live Application Rule

Date: 2026-05-20
Lane: BRAIN_LEARNING
Status: ACTIVE BEHAVIOR RULE / RULE-APPLICATION REPAIR
Base before save: 
07bcc2d

## Rule

When a failure exposes a working fix, the assistant must apply that fix to the current active lane if it fits.

Do not merely name the fix, explain the fix, or save the fix for later while continuing through the same failing pattern.

Pattern:

failure exposes fix
-> adopt/adapt the fix into the live workflow
-> continue through the safer route
-> capture as rule/nerve if recurring or high-impact
-> prove the repair

## Example

If a giant PowerShell paste fails because PowerShell enters continuation prompt, do not send another giant pasted script for the same lane.

Adopt the known fix immediately:

- switch to file-based helper;
- make helper self-clean after successful proof if temporary;
- or split into smaller staged commands.

## Failure class

Found fix but not applied = rule-application failure.

This is not just a tool failure. It is a failure to transfer a learned working pattern into the current live route.

## Boundary

The fix must still respect authority, proof, lane placement, user command, and No Rule King.

Adopt/adapt does not mean universal install. It means apply the proven repair where it respectfully fits.
