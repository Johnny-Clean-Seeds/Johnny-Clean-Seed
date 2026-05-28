# Helper Output Shape / Scalar-Safe Contract Rule — Self-Run Review V1

Date: 2026-05-28  
Status: SELF-RUN REVIEW / PRE-SAVE PROOF-SUPPORT  
Object reviewed: HELPER_OUTPUT_SHAPE_SCALAR_SAFE_CONTRACT_RULE_CANDIDATE_V1.md  
Authority: not doctrine, not ACTIVE_GUIDES, not CURRENT_TRUTH_INDEX  
Boundary: rule reviews itself before save; no helper rewrite; no doctrine promotion  

---

## 1. Self-Run Verdict

```text
SELF-RUN PASS WITH GUARDRAILS / READY FOR HASHED SAVE ROUTE
```

This rule passes its own method.

It names the output shapes it governs, rejects opposite patterns, identifies the repeated evidence family, defines proof requirements, and limits its scope.

---

## 2. Internal Think Tank Pressure

Internal pressure:

```text
The house should reduce live thinking burden.
Helpers should not create repeated repair loops.
Proof should not require chat rescue after every helper.
```

Fit:

```text
This rule reduces future helper burden by forcing output-shape contracts before proof-critical actions.
```

---

## 3. Neighbor Rule Pressure

### Neighbor — False PASS Guard

Pressure:

```text
blank, missing, malformed, or untrusted proof cannot be accepted as PASS.
```

Fit:

```text
This rule blocks PASS when proof fields are null, blank, truncated, or malformed.
```

### Neighbor — Code Gate Warning Judgment

Pressure:

```text
warnings are case-building signals, not just noise.
```

Fit:

```text
Return array wrapper and local write warnings become classified output-shape evidence rather than ignored noise.
```

### Neighbor — Evidence Before Movement

Pressure:

```text
source hash before move; destination hash after move; compare before save claims.
```

Fit:

```text
This rule protects hash evidence from truncated display and null/scalar output bugs.
```

### Neighbor — Think Tank + Opposition Cross-Check

Pressure:

```text
use opposite designs to find the rule we do not want.
```

Fit:

```text
The opposite tree rejects pipeline auto-shape trust, exit-code-only PASS, and giant-blob patching.
```

### Neighbor — New Rules Self-Run First

Pressure:

```text
new rule runs on itself before save.
```

Fit:

```text
This self-run is the pre-save proof-support.
```

---

## 4. Outside / Opposite Idea Checked

### PowerShell array subexpression

Outside fact checked:

```text
PowerShell's array subexpression operator @() returns results as an array even when there are zero or one objects.
```

Clean Seed use:

```text
Use @() around unknown-count results before .Count or indexing.
```

### Explicit contracts in typed systems

Opposite-system pressure:

```text
Typed systems force a function signature to say whether it returns one item, many items, null, or a structured object.
```

Clean Seed inversion for PowerShell:

```text
Because PowerShell is flexible, helpers must declare shape by convention and proof checks.
```

### Brittle text patching

Opposite-system pressure:

```text
Exact whole-blob replacement is safe only when exact byte-for-byte source is the object.
```

Clean Seed inversion:

```text
For normal status updates, patch a bounded section and verify the stale marker inside it.
```

---

## 5. Rejected Opposite Rules

Rejected:

```text
Trust command output shape.
```

Inversion:

```text
Wrap unknown-count output with @(...).
```

Rejected:

```text
Trust exit code as proof.
```

Inversion:

```text
Require proof fields to be present, full, and coherent.
```

Rejected:

```text
Treat one successful commit as enough even with dirty display proof.
```

Inversion:

```text
Use direct Git verification when display proof is malformed; then repair the helper pattern before reuse.
```

Rejected:

```text
Use exact giant text matching for normal content patching.
```

Inversion:

```text
Use bounded section replacement with marker verification.
```

---

## 6. Self-Application Test

This rule uses shape language correctly:

```text
scalar
array
object
string
nullable
status record
path record
receipt record
```

This rule defines when `.Count` is allowed:

```text
only after array shape is forced or verified.
```

This rule defines when indexing is allowed:

```text
only after array shape is forced, or when indexing is intentionally into a string and named as such.
```

This rule defines PASS blockers:

```text
blank proof
null proof
truncated proof
malformed proof
unverified patch target
```

Self-run result:

```text
PASS
```

---

## 7. House-Run Need

House-run is needed because this affects:

```text
PowerShell helpers
Code Gate-adjacent helper writing
save helpers
proof receipts
patch helpers
future reusable helper templates
```

House-run scope remains bounded:

```text
save candidate rule and self-run review only;
no Code Gate policy change;
no helper registry rewrite;
no active guide edit;
no doctrine edit.
```

---

## 8. Smallest Next Move

```text
Save the helper output shape rule and this self-run review with hash/move proof.
```

Do not:

```text
repair the entry-path updater yet;
rewrite Code Gate;
create a helper framework;
scan all helpers;
edit ACTIVE_GUIDES;
edit CURRENT_TRUTH_INDEX.
```

---

## 9. Proof Needed

```text
source hashes;
destination hashes;
hash compare;
receipt;
commit;
push;
final HEAD == origin/main;
final git status clean;
boundary held.
```

---

## 10. Self-Run Close

```text
The rule survives its own test: it explicitly controls output shape before count/index/proof and blocks the opposite pattern that caused the repeated helper failures.
```
