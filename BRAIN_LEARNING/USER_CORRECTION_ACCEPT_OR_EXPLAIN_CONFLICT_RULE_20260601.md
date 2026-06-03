# User Correction Accept Or Explain Conflict Rule

Date: 2026-06-01
Status: SESSION WORKING RULE / BRAIN_LEARNING CANDIDATE / NOT ACTIVE GUIDE
Source: user correction in Codex thread, plus attached `pasted-text.txt`

## User Rule

When the user tells the assistant it is not doing something, and the instruction does not conflict with the project, make it the new working way.

If it does conflict with the project, tell the user either while working or in the final report.

Do not silently skip user corrections, refinements, constraints, or requested process changes.

## Trigger

Use this when the user says or implies:

- "you are not doing X";
- "from now on do X";
- "do not just skip X";
- "this is how the project needs it";
- "if it conflicts, tell me";
- "make this the new way";
- a pasted/attached correction changes workflow, naming, proof, intake, reporting, placement, or save behavior.

## Required Response

1. Classify the instruction:
   - clean and compatible;
   - compatible but needs bounded placement;
   - already covered but needs tighter trigger;
   - conflicts with active project boundary;
   - unclear and needs user decision.
2. If clean, apply it in the current work and capture it in the right lane.
3. If conflicting, say what conflicts and what safe fallback is being used.
4. If only partly done, name what was done and what remains.
5. Never leave a skipped item invisible.

## Conflict Examples

| User instruction state | Assistant action |
|---|---|
| fits current project rules | apply and capture |
| asks for active guide edit while boundary blocks it | explain conflict and capture as candidate/support |
| asks for delete/move/merge without proof | refuse or yield, then name proof needed |
| asks to treat sequence folder as duplicate without proof | keep separate and require hash/manifest proof |
| asks for bulk activation of candidate cards | block activation, allow candidate shelf/index |

## Current Application

The attached order corrected the lower-cause lab injection process:

- numeric suffix folders are not automatically duplicates;
- duplicate content must be proven by manifest/hash comparison;
- sequence-looking folders must not be renamed, deleted, merged, or treated as disposal candidates;
- injection means living placement, neighbor fit, status, proof need, return trigger, and findability;
- intake is not injection;
- injection is not activation;
- activation is not doctrine.

Applied now as a session working rule.

## DoesNotProve

This file does not edit ACTIVE_GUIDES, CURRENT_TRUTH_INDEX, or final doctrine. It captures a compatible behavior correction and makes it visible for future project-file work.

## StopLine

Do not use this rule to bypass active guide boundaries, proof requirements, exact staged-set checks, protected-file checks, or user approval for commit/push/delete/move/merge/activation.
