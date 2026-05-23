# Mule No-Waste / Prompt Meter Discipline Rule

Status: SUPPORT RULE / MULE WORK-ORDER DESIGN  
Date: 2026-05-23  
Scope: mule prompts, long runs, no back-and-forth waste

## Rule

Mule work orders must not waste time, tokens, data, or prompt-meter space.

Do not play back-and-forth dialogue games with mule when a work order can be made clear up front.

Give mule one strong bounded prompt:
- mission;
- paths;
- hard order;
- allowed actions;
- blocked actions;
- proof required;
- meter discipline;
- stop conditions;
- return format.

## Meter discipline

Mule should work long and hard in bounded phases, but avoid burning the whole prompt meter in one go.

Preferred behavior:
- gather and write reports to files;
- reduce chatter;
- return compact status;
- stop before the prompt meter gets stupid;
- use files/receipts instead of conversational sprawl.

## Stop only on real blockers

Mule should stop only when:
- path/home is missing;
- action risks deletion, overwrite, secret exposure, or Git damage;
- required authority is missing;
- scope conflict cannot be resolved safely.

## Short form

No token games.

No data waste.

No soft chatter loop.

One strong work order, hard work, receipts, honest blockers.
