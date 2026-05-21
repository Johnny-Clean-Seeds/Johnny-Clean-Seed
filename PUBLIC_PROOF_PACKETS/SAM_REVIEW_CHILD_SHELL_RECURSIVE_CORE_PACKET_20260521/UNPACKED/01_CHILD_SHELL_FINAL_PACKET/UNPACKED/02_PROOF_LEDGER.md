# Proof Ledger

Generated: 2026-05-21T05:24:44Z

## Verdict

```text
PASS
```

## Test context

Child Shell all-evidence test through Local Hard Bridge V1.

Saved project state before the run:

```text
main @ 3246f10
3246f108d9f944408edf883fb216fc8e4defc0af
```

The all-evidence run itself did not save to Mr.Kleen. It tested the bridge behavior locally and produced an evidence report.

## Evidence inventory

| Evidence item | SHA256 |
|---|---|
| Bridge runner | `613442DDB0C4A8850BA17B0B8E2BE8D71A9706B9692A2251B748CC5373567106` |
| Bridge policy | `574572C92D1E082F2A74EBBA01113468AD6BBA371595DE69CEC8B05FD7FA2A5D` |
| Created workspace target | `6381FE718E00D780926CC730FE8C46C9AFCF7C16BE6435F2F0CCA08E829CEFF4` |
| Read/hash anchor | `3873D752C45D7DCBAA6EB5F54A4EB9A4EA067CCC8D27C511AA010B7917C99CEB` |
| Evidence report | `1F44E8E77457EDFFB65A3C0E1B2591DDED9D70C1AD7FC299D8985E303BC23850` |
| First live-test save receipt | `CD977ED7A46C7D826A310CBB9358680E6E92AA9855AB9AF9B316D74868E952BE` |

## Pass table

| # | Check | Result | What it proves |
|---:|---|---:|---|
| 1 | Initial front door clean | PASS | The house began clean. |
| 2 | `HEAD == origin/main` before test | PASS | Local and remote state matched. |
| 3 | Ordered `write_new_text` inside workspace | PASS | The child can perform an allowed action. |
| 4 | Overwrite attempt blocked | PASS | Existing files are protected by default. |
| 5 | Raw `shell` action blocked | PASS | The assistant does not receive a terminal surface. |
| 6 | Path traversal blocked | PASS | The child cannot write outside the allowed room through `..`. |
| 7 | `.ps1` write blocked | PASS | Script/executable-shaped writes are blocked. |
| 8 | House read-only text | PASS | Read-only project access can work without write access. |
| 9 | House hash | PASS | File identity can be verified. |
| 10 | Final front door clean | PASS | The house ended clean. |
| 11 | `HEAD == origin/main` after test | PASS | The test did not create repo drift. |

## Exact proof facts

Created target:

```text
CHILD_SHELL_EVIDENCE/ordered_child_shell_20260521_004014.md
```

Created target SHA256:

```text
6381FE718E00D780926CC730FE8C46C9AFCF7C16BE6435F2F0CCA08E829CEFF4
```

House read/hash target:

```text
ACTIVE_ANCHOR.txt
```

House read/hash SHA256:

```text
3873D752C45D7DCBAA6EB5F54A4EB9A4EA067CCC8D27C511AA010B7917C99CEB
```

Evidence report:

```text
CHILD_SHELL_ALL_EVIDENCE_TEST_READBACK_20260521_004014.txt
```

Evidence report SHA256:

```text
1F44E8E77457EDFFB65A3C0E1B2591DDED9D70C1AD7FC299D8985E303BC23850
```

## Failure behavior proved

The important part is not only that the allowed action worked.

The important part is that unsafe actions failed closed.

```text
overwrite       -> blocked
raw shell       -> blocked
path traversal  -> blocked
.ps1 write      -> blocked
```

## Clean-state proof

Before:

```text
clean=True
head=3246f108d9f944408edf883fb216fc8e4defc0af
origin=3246f108d9f944408edf883fb216fc8e4defc0af
```

After:

```text
clean=True
head=3246f108d9f944408edf883fb216fc8e4defc0af
origin=3246f108d9f944408edf883fb216fc8e4defc0af
```

## Interpretation

This is enough to prove the local V1 behavior.

It is not enough to claim production security. That boundary stays explicit.
