# Child Shell
## A Bounded Local Actuator Pattern for Safe AI-to-PC Work

Generated: 2026-05-21T05:24:44Z

## 1. The problem

There is a missing middle layer in AI-to-computer work.

At one extreme, the assistant is trapped in chat. It can reason and write, but it cannot touch the working surface where the user's real files live.

At the other extreme, the assistant becomes an agent with broad terminal, browser, GUI, or computer-control power. That can be useful, but it immediately raises harder questions: what can it touch, what can it overwrite, what can it execute, what happens if a request is malformed, and what proves what happened?

Child Shell sits between those extremes.

It gives the assistant local usefulness without giving it raw local power.

## 2. The formula

```text
AI request -> policy gate -> child action -> local function -> response + receipt
```

Expanded:

```text
the assistant proposes a small request
the bridge checks the request against policy
only a named child action can run
the local engine performs that one bounded function
the bridge returns a response, receipt, hash, and state proof
```

The assistant does not receive a terminal.

The assistant receives a small set of named limbs.

## 3. The placement

PowerShell is the parent engine.

Child Shell is the exposed surface.

That distinction is the whole design.

A raw terminal accepts commands. A child shell accepts only pre-defined action names. The assistant cannot invent a command string and hand it to the machine. It can only request an approved child action, and the bridge can still refuse.

This changes the safety question from:

```text
How do we let the AI use PowerShell safely?
```

to:

```text
How do we prevent the AI from ever seeing raw PowerShell while still allowing useful local actions?
```

The answer is the child surface.

## 4. What the prototype proved

A local Child Shell V1 evidence run passed.

It proved:

- an allowed workspace write can succeed;
- overwrite attempts can fail closed;
- raw shell requests can fail closed;
- path traversal can fail closed;
- script-extension writes can fail closed;
- read-only house file access can work;
- hashing can prove file identity;
- front-door state can prove the house was clean before and after;
- receipts and hashes can make the action trail auditable.

The strongest evidence line:

```text
Initial front door: clean=True head=3246f108d9f944408edf883fb216fc8e4defc0af origin=3246f108d9f944408edf883fb216fc8e4defc0af
Final front door:   clean=True head=3246f108d9f944408edf883fb216fc8e4defc0af origin=3246f108d9f944408edf883fb216fc8e4defc0af
```

## 5. What this means

The useful unit is not:

```text
AI controls my computer.
```

The useful unit is:

```text
AI requests a named local child action.
The local policy decides.
The child function acts or blocks.
The system returns proof.
```

That is smaller, cleaner, and easier to reason about.

## 6. What stayed blocked

The test intentionally kept these unavailable:

```text
raw shell
delete
overwrite
path traversal
script write
house write
git commit
git push
network service
```

That is not a limitation to hide. It is the value of the pattern.

The bridge is useful because it is small.

## 7. Why this is product-relevant

A consumer-safe local assistant does not need to begin with full computer control.

It can begin with one bounded folder, one policy file, a small action list, a request queue, a response queue, receipts, hashes, and user-run approval.

That creates practical local utility without handing the assistant a terminal-shaped hole.

## 8. Precise claim

This packet proves one precise claim:

> A bounded local bridge can expose named child actions instead of raw terminal access, perform allowed work, block unsafe requests, produce auditable proof, and leave the working state clean.

It does not prove every future expansion. It proves the minimum pattern is real.
