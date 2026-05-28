# Helper Output Shape / Scalar-Safe Contract Rule — Candidate V1

Date: 2026-05-28  
Status: CANDIDATE RULE / ACTIVE HELPER-BUILD BEHAVIOR / SAVE SELECTED  
Authority: not doctrine, not ACTIVE_GUIDES, not CURRENT_TRUTH_INDEX  
Boundary: PowerShell helper-generation and helper-review behavior only  

---

## 1. Rule Name

```text
HELPER OUTPUT SHAPE / SCALAR-SAFE CONTRACT RULE
```

Short form:

```text
No loose output shape.
```

---

## 2. Problem

PowerShell helpers repeatedly failed or showed dirty proof because output shape was assumed instead of controlled.

Observed failures:

```text
1. .Count crash on marker-check result.
2. .Count crash on scalar/missing result.
3. Full Git hash displayed as first character only: e / 7 / 7.
4. Exact giant-string patch failed because the helper expected one perfect blob instead of a bounded section.
```

These were not business-logic failures.

They were helper-shape failures.

---

## 3. Core Rule

Any helper function or command result that will be counted, indexed, joined, filtered, looped, measured, staged, printed as proof, or used in a gate decision must have an explicit output-shape contract.

A helper must decide whether a value is:

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

before using it.

Do not let PowerShell pipeline auto-shape the object silently.

---

## 4. Required Pattern

When a command may return zero, one, or many items, capture it as an array:

```text
$result = @(<command>)
```

When a function returns a list, return an explicit object array or array list output.

When calling a function that may return a list, wrap the call at the call site:

```text
$items = @(Get-Something)
```

When taking the first item, array-wrap before indexing:

```text
$head = @(git rev-parse HEAD)[0]
```

When a function returns text that must stay whole, do not index it as if it is an array.

When output is proof-critical, print the whole value and validate expected length/shape if possible.

---

## 5. PowerShell-Specific Guardrails

### Guardrail 1 — Array subexpression for unknown counts

Use `@(...)` when the result count may be zero, one, or many.

### Guardrail 2 — Never trust `.Count` until shape is known

Before using `.Count`, ensure the variable is array-shaped or intentionally scalar-shaped.

### Guardrail 3 — Do not index unknown strings

This is dirty proof:

```text
$hash = (git rev-parse HEAD)[0]
```

Depending on shape, this can mean:

```text
first line of array
```

or:

```text
first character of string
```

Use:

```text
$hash = @(git rev-parse HEAD)[0]
```

or a dedicated function that returns a named object:

```text
[pscustomobject]@{
    Head = $head
}
```

### Guardrail 4 — Gate reports need shape proof

When a report says PASS, the evidence must not have blank, truncated, null, or first-character fields.

Bad proof examples:

```text
Old HEAD: e
New HEAD: 7
Origin after: 7
```

Good proof examples:

```text
Old HEAD: 7eac2727a7137ca6638e741ec328ff01b6758794
New HEAD: d11ef1d1da4a4944722df53c15f1ffe40da1b764
Origin after: d11ef1d1da4a4944722df53c15f1ffe40da1b764
```

### Guardrail 5 — Patch by bounded region, not giant exact blob

For text patch helpers, do not require an entire large section to match perfectly unless exact provenance is the object being tested.

Better pattern:

```text
find section start marker
find next section marker
verify stale marker inside section
replace only bounded section
hash before/after
write receipt
```

This avoids broad replacement while also avoiding brittle giant-string matching.

---

## 6. Required Helper Review Questions

Before helper delivery or save, ask:

```text
1. Which values may return zero, one, or many?
2. Which values are used with .Count?
3. Which values are indexed with [0]?
4. Which values are joined or printed as proof?
5. Which values can be null?
6. Which helper functions return collections?
7. Are function returns explicit arrays, scalar strings, or named objects?
8. Are proof fields validated against truncation or blank values?
9. Is text patching bounded by section markers instead of a giant blob?
10. Is every PASS blocked if proof fields are blank, null, truncated, or malformed?
```

---

## 7. Opposite Tree

Rejected opposite rule:

```text
Let PowerShell shape the result and trust it.
```

Clean Seed inversion:

```text
Declare and enforce output shape before counting, indexing, or proving.
```

Rejected opposite rule:

```text
A helper PASS is valid if the command exited zero.
```

Clean Seed inversion:

```text
A helper PASS is invalid if proof fields are blank, null, truncated, or malformed.
```

Rejected opposite rule:

```text
Patch by matching one giant expected text block.
```

Clean Seed inversion:

```text
Patch by bounded section, verify stale marker, replace only that region.
```

Rejected opposite rule:

```text
Treat scalar/array bugs as one-off syntax mistakes.
```

Clean Seed inversion:

```text
Treat repeated scalar/array bugs as a helper-family rule gap.
```

---

## 8. Fit With Current House Work

This rule fits because recent helper work showed the same branch repeatedly:

```text
marker missing list .Count crash
saved-file orientation checker V1 .Count crash
save helper full-hash display truncation
entry-path updater brittle giant-string section failure
```

This is a repeated failure family, not a random helper typo.

---

## 9. Required Implementation Surface

Future PowerShell helper templates should include:

```text
Shape-safe Git output capture
Shape-safe search result capture
Shape-safe warning list capture
Shape-safe marker missing capture
Shape-safe status capture
Shape-safe staged-file capture
Proof-field validation
Bounded section patching
False PASS guard for blank/null/truncated proof
```

---

## 10. Proof Standard

A helper passes this rule only if:

```text
all list-like values are array-shaped before .Count;
all indexed values are array-shaped or intentionally scalar-safe;
all proof-critical fields are nonblank and not truncated;
all patch operations are bounded and marker-verified;
any malformed proof stops before save/commit/push.
```

---

## 11. What Not To Do

Do not:

```text
turn every helper into a giant framework;
add broad scans to fix shape bugs;
rewrite Code Gate policy from this rule alone;
promote this to doctrine without more use;
ignore successful saves only because display proof was dirty;
trust dirty display proof without direct verification.
```

---

## 12. Fit Decision

```text
ACCEPT WITH GUARDRAILS / CANDIDATE HELPER RULE / SAVE SELECTED
```

Reason:

```text
The issue repeated across separate helpers and directly affected proof quality.
```

Guardrails:

```text
local helper behavior only;
no doctrine promotion;
no ACTIVE_GUIDES edit;
no CURRENT_TRUTH_INDEX edit;
no broad helper rewrite yet.
```

---

## 13. One-Line Clean Wrap

```text
Before a helper counts, indexes, prints, or proves a value, it must know whether that value is scalar, array, null, text, or a named proof object.
```
