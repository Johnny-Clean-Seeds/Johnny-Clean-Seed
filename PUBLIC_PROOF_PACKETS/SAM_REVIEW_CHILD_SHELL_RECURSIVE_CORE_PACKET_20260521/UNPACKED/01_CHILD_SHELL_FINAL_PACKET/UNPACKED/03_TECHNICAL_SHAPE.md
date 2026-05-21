# Technical Shape

Generated: 2026-05-21T05:24:44Z

## Pattern

```text
Child Shell / Sub-PowerShell Actuator
```

## Purpose

Expose local usefulness without exposing raw command execution.

## Structure

```text
[Assistant]
    |
    | request object
    v
[Bridge request queue]
    |
    | parse + validate
    v
[Policy gate]
    |
    | only named actions pass
    v
[Child action function]
    |
    | local parent engine executes bounded function
    v
[Response JSON]
[Receipt TXT]
[Hashes]
[State proof]
```

## Parent engine

The parent engine may be PowerShell.

That does not make PowerShell the exposed interface.

The exposed interface is the child action list.

## Child surface

A child surface is a small list of allowed functions.

Example V1 limbs:

```text
house_front_door
write_new_text
house_read_text
house_hash
```

Each limb must define:

- allowed root;
- accepted parameters;
- blocked parameters;
- overwrite behavior;
- extension behavior;
- response fields;
- receipt fields;
- failure behavior;
- proof output.

## Hardstops

V1 hardstops:

```text
no raw shell
no delete
no overwrite
no path traversal
no script-extension write
no house write
no git commit/push
no network service
```

## Why this is safer than terminal access

Terminal access accepts arbitrary command text.

Child Shell accepts only known action names.

That means an unsafe request can fail before reaching the local engine.

The bridge does not need to decide whether a command string is safe. It can refuse command strings entirely.

## Design standard

The bridge should not ask:

```text
Is this arbitrary command safe?
```

It should ask:

```text
Is this request one of the small actions we already designed and proved?
```

If not, it blocks.

## Receipt standard

Every action should create a receipt with:

- request ID;
- action name;
- result;
- request location;
- response location;
- request hash;
- response hash;
- boundary statement;
- error message if blocked.

## State standard

Any bridge connected to a repo-like house should prove state before and after:

```text
branch
HEAD
origin/main
clean status
critical anchor/index presence
```

## Next engineering risks

The next serious tests are not bigger permissions.

They are sharper boundary checks:

- symlink and reparse-point bypass;
- stale queued request handling;
- receipt tamper detection;
- signed script/install chain;
- dry-run proposal mode for future sensitive writes;
- user-visible diff preview before any future write outside the workspace.
