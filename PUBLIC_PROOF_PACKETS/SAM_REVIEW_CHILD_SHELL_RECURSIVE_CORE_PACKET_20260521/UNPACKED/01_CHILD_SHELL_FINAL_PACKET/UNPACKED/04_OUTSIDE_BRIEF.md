# Child Shell: A Safe Middle Layer for Local AI Work

Generated: 2026-05-21T05:24:44Z

AI assistants need a better local bridge.

Chat-only systems are useful but disconnected from the user's working surface. Broad computer-use agents can be powerful, but they raise harder control and audit questions.

Child Shell is a smaller path.

```text
AI request -> policy gate -> child action -> local function -> response + receipt
```

The assistant does not get a terminal.

It gets a small set of named local actions.

A V1 prototype proved the pattern:

- allowed workspace write passed;
- overwrite blocked;
- raw shell blocked;
- path traversal blocked;
- `.ps1` write blocked;
- read-only file access worked;
- file hashing worked;
- the project state stayed clean before and after;
- proof came back as responses, receipts, and hashes.

The key idea:

```text
Do not make the AI powerful.
Make the local doorway small, named, and provable.
```

This is not full production security. It is a minimum viable safety pattern for local AI usefulness.

The product direction is simple:

```text
one bounded folder
one policy
named actions only
no raw shell
no silent overwrite
no delete by default
receipts for every move
user-run approval
state proof before and after
```

The result is a practical middle layer between chat-only assistance and broad computer control.
