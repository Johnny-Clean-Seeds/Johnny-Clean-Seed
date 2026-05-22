# Final Judge Gate Alpha/Omega Role Rule — 20260522

## Status

Type: brain-learning / gate architecture role rule.

Boundary:
- This is not a doctrine promotion.
- This is not an active guide rewrite.
- This is not a CURRENT_TRUTH_INDEX rewrite.
- This is not automation.
- This does not make any handoff, source, document, mule report, helper, or file the throne.
- This does not override "No source gets the throne. Every source gets a lane."
- This does not make the Final Judge Gate a monarchy.
- This does not replace the individual jobs of each gate.

## Core Clarification

The concern is not mainly whether handoff documents, source packets, or mule reports become part of the house.

The concern is whether every object is doing what it needs to do.

Every object must do its job.

Every gate must do its job.

Every mule, handoff, helper, file, process, source, output, receipt, and map must do its job.

The Final Judge Gate judges the gates.

## Alpha/Omega Meaning

The Final Judge Gate is alpha and omega for gate behavior.

It starts the gate run and ends the gate run.

Alpha:
- opens the gate-run question;
- asks whether this object/process is ready to be judged;
- frames which gates are supposed to fire;
- identifies the expected gate roles, lanes, proof needs, and stop conditions.

Omega:
- closes the gate-run question;
- judges whether the gates actually fired;
- judges whether each gate stayed in lane;
- judges whether each gate judged the right thing;
- judges whether the gate stack produced a clean result;
- decides whether the run closes, parks, blocks, fails, or needs another proof route.

This is start-to-finish role fidelity judgment, not monarchy.

## What the Final Judge Gate Starts

The Final Judge Gate starts a gate run by asking:

1. What object is being judged?
2. What is the object's job?
3. What lane owns it?
4. What gates should fire?
5. What does each gate judge?
6. What proof is needed?
7. What would block PASS?
8. What would require parking?
9. What must not change?
10. Where does the run stop?

## What the Final Judge Gate Ends

The Final Judge Gate ends a gate run by asking:

1. Did each required gate fire?
2. Did any gate fail to fire?
3. Did any gate judge outside its lane?
4. Did any gate underreach or overreach?
5. Did any gate skip proof?
6. Did any gate kill an undisproved candidate?
7. Did any gate allow fake PASS?
8. Did any gate promote source ore, mule output, or candidate material too early?
9. Did every object do its assigned job?
10. Did the final result obey source custody, proof discipline, placement, and boundary?
11. Is the run closed, parked, blocked, failed, or ready for next move?

## Relation to Gate Judge / Gate Role Boundary

Gate Judge / Gate Role Boundary says each gate minds its own business.

Final Judge Gate Alpha/Omega says the final judge starts the gate run, keeps the gate stack bounded, and closes by judging whether the gates actually did their jobs.

Gate Judge controls gate-lane behavior.

Final Judge Gate opens and closes the gate-run evaluation.

## Relation to No Source Gets the Throne

This rule does not make a source, handoff, document, thinker, mule, or helper the throne.

It prevents false thrones by asking whether objects and gates are doing their correct jobs.

Short form:

No source gets the throne.
Every source gets a lane.
Every object gets a job.
Every gate gets judged.
The Final Judge Gate starts the gate run and ends it.

## Relation to Tool Context / No Mystery Parts

This rule supports the no-mystery-parts problem:

A helper file is clean only if its job is known and it does its job.

A gate is clean only if its lane is known and it judges correctly.

A mule output is clean only if it returns what it was assigned to return and does not steal authority.

## Dirty Patterns

Dirty patterns blocked by this rule:

- treating a handoff as authority instead of a work order;
- treating a mule report as final truth;
- letting a helper file exist without a role;
- letting a gate kill useful unproven growth;
- letting a gate promote without proof;
- letting a gate judge outside its lane;
- letting a process finish without asking whether the gates behaved;
- treating "not a throne risk" as enough when role failure still exists;
- starting a gate run without defining which gates are supposed to fire;
- ending a gate run without checking whether the gates actually did their jobs.

## Clean Pattern

Clean pattern:

1. Identify the object.
2. Identify its job.
3. Identify its lane.
4. Identify what depends on it.
5. Start the gate run.
6. Identify which gates must fire.
7. Let each gate do only its job.
8. Let the Final Judge Gate judge the gate stack.
9. Close only when object role, gate role, proof, and boundary line up.

## Short Form

The Final Judge Gate is the alpha and omega of gate behavior.

It starts the gate run and ends it.

It judges the gates.

Every object must do its job.
