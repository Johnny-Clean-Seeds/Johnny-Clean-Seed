# Soft Suit Addendum — Report Pasteback To Next Code Rule

Date: 2026-05-28  
Status: SOFT SUIT CANDIDATE ADDENDUM / CHAT-BEHAVIOR SUPPORT  
Authority: NOT doctrine; NOT ACTIVE_GUIDES; NOT CURRENT_TRUTH_INDEX  
Placement target: Soft Suit / Local Code Workbench / helper evolution lane  
Source trigger: user correction — "just send the next code after i send report; if fail send fix"

---

## 1. Clean Rule

When the user sends a Code Gate, save, repair, or helper report:

```text
judge the report first
if PASS:
    send the next approved code/file route directly
if FAIL:
    send only the narrow fix code/route
if no code is needed:
    send only the next clean action
```

Do not re-explain successful reports by default.

Do not re-summarize the whole chain.

Do not turn every PASS into another lecture.

---

## 2. Why This Belongs In Soft Suit

Soft Suit controls live working fit.

This rule improves fit because report pastebacks are repetitive.

The user is not asking for a report explanation every time.

The user is using reports as proof input.

So the assistant should:

```text
read proof
judge state
move to next surface
```

not:

```text
chew proof again
explain every saved hash
repeat boundary language
inflate the turn
```

---

## 3. Fit With Current Helper/Support-Pack

Current support-pack already uses:

- Code Gate;
- target output contract;
- receipt/hash/commit proof;
- final clean status;
- next route.

This addendum completes the loop:

```text
report pasteback -> judgment -> next code/fix route
```

It keeps the workflow fast after proof exists.

---

## 4. PASS Behavior

If report is PASS or expected PASS WITH WATCH:

```text
update state if needed
send next route file/code directly
include expected close marker
keep explanation minimal
```

Minimum output:

```text
Next route file:
<link>

Run:
<command>

Expected close:
<marker>
```

---

## 5. FAIL Behavior

If report shows parser fail, blocker, target nonzero, dirty repo, missing staged file, unexpected staged file, push mismatch, or final status not clean:

```text
do not continue the sequence
classify the failure
send the smallest repair route/code
```

Minimum output:

```text
Fix route:
<one sentence>

Fix file:
<link>

Run:
<command>

Expected close:
<marker>
```

---

## 6. Watch Behavior

If report is PASS WITH WATCH:

Accept only when the watch is expected and bounded.

Examples of acceptable WATCH:

- LF/CRLF warning with final clean status;
- Code Gate watch with target PASS;
- named warning that does not block.

If watch is unexpected:

```text
pause
name the watch
send fix or inspection route
```

---

## 7. Boundary

This addendum does not:

- skip Code Gate;
- skip proof judgment;
- skip memory/state update when needed;
- skip safety;
- promote helper output to authority;
- edit ACTIVE_GUIDES;
- edit CURRENT_TRUTH_INDEX;
- promote doctrine;
- require code when no code is needed.

It changes delivery style after report pasteback.

---

## 8. Fit Decision

ADOPT:

Use this as Soft Suit behavior for report pastebacks.

ADAPT:

If the user asks for explanation, provide the explanation after the next route or instead of the next route as requested.

PARK:

Full cockpit rewrite.

BLOCK:

- treating PASS reports as a reason for long explanation;
- continuing after FAIL;
- skipping judgment;
- skipping Code Gate;
- saving to authority files from this addendum alone.

---

## 9. Short Form

```text
After report:
PASS -> next code.
FAIL -> fix code.
No code needed -> next clean action.
```

