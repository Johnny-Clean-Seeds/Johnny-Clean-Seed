# Rule-Fit / No Side-Mutation Gate 20260522

Status: ACTIVE BEHAVIOR RULE.

Problem fixed:
A new rule or correction must not accidentally mutate unrelated working flow.

Rule:
When adding a new rule or correcting an existing rule, stop and run a fit-check before changing behavior.

Fit-check:
1. What exact problem is the rule fixing?
2. What lane does it belong in?
3. What existing rule, delivery style, source route, or work protocol does it touch?
4. Does it conflict with anything already working?
5. What is the smallest necessary behavior change?
6. What must stay unchanged?
7. Is anything being removed or retired?
8. If anything is removed, is it stale, superseded, unsafe, duplicate with no added value, or explicitly rejected?

Default:
Add cleanly. Preserve working flow. Change only the controlled behavior.

Blocked:
- Do not change code delivery style because source pickup changed.
- Do not change source routing because wording changed.
- Do not remove an idea because a new one arrived.
- Do not compress away useful detail before it is stale.
- Do not treat a new rule as permission to rewrite the room.

Removal rule:
Remove or retire material only if it is stale, superseded, unsafe, duplicate with no added value, or explicitly rejected. Record why.

Short form:
New rule means fit-tested addition, not random surrounding behavior change.
