# Wrap Stage Agent Frame Freedom Ratio Rule

Date: 2026-05-24

Status: active support rule / wrap-stage training checkpoint.

## Rule

Do not train every agent stage with the same amount of frame.

Use more frame when the agent is fast, weak, vague, or prone to smooth answers. Use more freedom
when the agent is already holding the object, preserving source, and visibly changing output through
the washer.

The goal is not to box the assistant in. The goal is to give enough frame that the work enters the
right room, then enough freedom that real synthesis can grow.

## Frame/Freedom Ratio

Use this as a judgment ratio, not fake math:

| Stage | Frame | Freedom | Why |
|---|---:|---:|---|
| Intake / source custody | 80 | 20 | Weak agents need a strong lane so source is not lost or treated as doctrine. |
| First translation | 70 | 30 | Keep object, source, room, and proof visible while allowing cleaner language. |
| House walk / diagnosis | 60 | 40 | The route is framed, but the worker must notice odd pressures and missing rooms. |
| Creative room | 40 | 60 | Creativity needs space, but exit labels and proof boundaries stay active. |
| Washer / replay | 75 | 25 | The same issue must be rerun through corrected behavior; proof beats style. |
| Final wrap / closeout | 85 | 15 | Commit, receipt, proof, parking, and next direction need tight structure. |

Adjust by agent strength:

- Fast/weak/instant agent: add 10 to 20 frame points.
- Strong/slower/reasoning agent: may add 10 to 20 freedom points during diagnosis and creative room.
- Any agent showing rigidity: reduce frame temporarily with a signal-before-object-type pass, then
  restore proof gates before save.
- Any agent showing drift: increase frame immediately and replay the same issue.

## Training Shape

Each wrap stage should train the agent in one behavior at a time:

1. Keep the original work visible.
2. Name the active object.
3. Walk the object through the right room.
4. Find the slip or pressure.
5. Adopt one small correction.
6. Apply it to the same object.
7. Test whether the output changed.
8. Wash and close with proof.

If the agent only explains the lesson, the stage did not train. The output must be different.

## Rigidity Watch

Tightening helps a weak model stop being instant, but too much tightening can make it rigid:

- it repeats ritual words;
- it waits for permission after the route is clear;
- it overuses rope/washer terms without adding proof;
- it narrows too early;
- it becomes laggy, tool-reset prone, or conclusion-shy.

When rigidity appears, use a softer creative-room pass:

`hold signal -> ask what is missing -> test one route variation -> wash -> place`

Do not remove gates. Change the phase weight.

## Clean Pattern

`frame enough to route -> freedom enough to notice -> washer enough to prove -> close enough to release`

## Dirty Pattern

- Same rigid checklist for every stage.
- Loose creative work with no exit label.
- Weak agent asked to infer hidden house structure with no frame.
- Strong agent boxed so tightly it cannot discover missing pressure.
- Saying "activation" without changing the answer shape.

## Relation

This supports Issue Replay Washer Mirror Rule, Rigidity Hunt / Signal Before Object Type Rule,
Rope Tug Checkpoint Rule, Active Object Release And Signal Discipline Rule, Small Build Strength /
Clean Phase Wrap Rule, and Final Judge.
