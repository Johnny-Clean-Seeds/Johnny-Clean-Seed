# Limits and Next Tests

Generated: 2026-05-21T05:24:44Z

## What is proven

Child Shell V1 proved the tested local behavior:

```text
allowed write passed
overwrite blocked
raw shell blocked
path traversal blocked
.ps1 write blocked
read-only house read passed
house hash passed
front door clean before and after
HEAD == origin/main before and after
receipts/hashes produced
```

## What is not proven

This packet does not prove:

- production security;
- cross-platform support;
- all filesystem edge cases;
- symlink/reparse-point safety;
- malicious local tampering resistance;
- enterprise policy control;
- signed installer trust;
- GUI automation safety;
- arbitrary app control;
- future permission expansion safety.

## Red lines

Do not expand the bridge to include these without separate proof:

```text
raw shell
delete
overwrite
house write
git commit
git push
background service
network service
auto-run without user approval
```

## Next tests

### 1. Symlink / reparse-point test

Prove the root guard cannot be bypassed through filesystem indirection.

Expected result:

```text
blocked
```

### 2. Stale request test

Prove old queued requests cannot surprise-run later.

Expected result:

```text
stale block or explicit archive-before-run
```

### 3. Receipt tamper test

Modify a response or receipt and verify the mismatch is detected.

Expected result:

```text
hash mismatch detected
```

### 4. Dry-run proposal mode

Allow the bridge to create proposed changes only in an outbox.

Expected result:

```text
proposal written
house unchanged
front door clean
```

### 5. Diff preview gate

Before any future sensitive write, show the exact intended diff.

Expected result:

```text
no write without visible diff and explicit user action
```

## Product hardening path

The next step is not more power.

The next step is more trust in the same small surface.
