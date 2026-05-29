# After-Run Breadcrumb Wash / Leap-Close Living Order

Status: SAVED HOUSE PROCESS CANDIDATE / NOT DOCTRINE / NOT ACTIVE_GUIDES / NOT CURRENT_TRUTH_INDEX
Saved: 20260528_233215
Source: pasted markdown from chat
SourceSHA256: B0BECC68B3B48811FEC68B72EF55C7DFF715B126DADD0515D288E5C51A458AC6
Boundary: living-order candidate only; no doctrine promotion; no mule rule change; no helper build.

---
Yes. This should become a **living order**, not a one-time cleanup.

Status: **SOFT SUIT NOW / UNSAVED / NOT DOCTRINE**.
Object: **After-Run Breadcrumb Wash / Leap-Close Living Order**.
Purpose: make every meaningful run teach the house before the next leap stacks on top of it.

External cross-check: this lines up with serious real-world learning systems. Google SRE postmortems focus on documenting incidents, understanding contributing/root causes, and creating preventive actions; they also stress blameless factual analysis instead of personal blame. ([Google SRE][1]) After-Action Review practice asks what was supposed to happen, what actually happened, why, and what to do next. ([The Systems Thinker][2]) PDSA/PDCA is the same improvement engine in another form: plan/do/study-or-check/act, repeated to increase learning over time. ([The W. Edwards Deming Institute][3])

The house-native version should be stronger than a postmortem because it is not just “review after failure.” It is **run harvesting**: turn every meaningful run into boundary proof, mechanism extraction, dead-weight burn, and next-leap control.

## AFTER-RUN BREADCRUMB WASH / LEAP-CLOSE LIVING ORDER V0

Core law:

After any meaningful run, close the run before opening the next run. Closing is not just PASS/FAIL. Closing means tracing the object, splitting proof from noise, washing failures, extracting mechanisms, burning live dead weight, deciding house fit, and naming the next bounded leap.

A run means any action that produces evidence or risk: script run, helper run, tool test, source wash, transcript extraction, save route, repo commit, gate run, mule return, file move, failed command chain, repeated chat/tool failure, source intake, dashboard/helper build, or meaningful judgment pass.

The transcript job proved why this matters: the URL existed at the user command boundary, survived into the helper, but died before `yt-dlp`; the direct road later proved the URL, `yt-dlp`, subtitles, folder, VTT output, TXT output, and final artifact length. The real rule extracted was that a helper only passes when the active object survives every boundary and the final artifact proves it. 

## Whole deep list

1. **Run Trigger**
   Name why this run deserves a close. Do not wash every tiny chat turn. Wash meaningful runs: failed twice, produced artifact, changed state, crossed tools, touched files, created proof, or revealed a new mechanism.

2. **Object Lock**
   State the active object in one line. Example: “YouTube URL → transcript TXT.” If the object cannot be named, the run was not controlled.

3. **Intent Lock**
   What was supposed to happen? This is the AAR “intended result” question in house form. It blocks vague review.

4. **Actual Result**
   What actually happened? Include PASS/FAIL/PARTIAL, but do not stop there.

5. **Boundary Trace**
   Map every boundary the object crossed. For the transcript run: chat → PowerShell → helper script → `yt-dlp` → VTT → TXT conversion → Explorer selection → verification. This is one of the most important fields.

6. **Object Survival Check**
   At each boundary, ask: did the active object survive unchanged? Did the URL/file/path/source/mode/lane remain intact? Where did it die, mutate, or disappear?

7. **Timeline**
   Keep a minimal event sequence. Not a novel. Enough to prove order: first helper fail, second helper fail, direct road pass, conversion issue, .NET write pass, file length verified.

8. **Expected vs Actual Delta**
   State the mismatch. Example: expected helper to pass URL to `yt-dlp`; actual helper launched `yt-dlp` with no URL.

9. **Error Inventory**
   List real errors only. Do not include emotional noise as technical evidence. Example: `yt-dlp.exe: error: You must provide at least one URL`; `Set-Content: parameter Encoding not found`; duplicated verification command.

10. **False Diagnosis Burn**
    Name wrong explanations and burn them from live carry. Example: “PowerShell is broken” was false; “user typed URL wrong” was not the root; “yt-dlp failed” was false.

11. **Assumption Audit**
    What did we assume without proof? In this run: that helper passed `-Url` internally; that `Set-Content -Encoding UTF8` worked in this shell; that long one-liners were safe in recovery mode.

12. **Tool Trust State**
    Every helper/tool gets a lifecycle label: `UNTESTED`, `PARSE_PASS_ONLY`, `RUN_FAIL`, `DIRECT_ROAD_PROVEN_BUT_HELPER_FAILS`, `REPAIR_CANDIDATE`, `NARROW_LIVE_USE_PASS`, `REUSE_PATTERN_ONLY`. Old V1 became `REPAIR_CANDIDATE / DO NOT USE`.

13. **Script Status vs Job Status**
    Split these. A script can run while the job fails. The old helper printed organized status, but the job failed. This matches the house warning that Code Gate PASS is not job PASS.

14. **Direct Road Test**
    Before repairing a wrapper, prove the raw road. In this case, direct `yt-dlp ... "$Url"` proved the road.

15. **Road-Before-Button Gate**
    No icon, wrapper, installer, shortcut, broad helper, or manager until the raw command works once.

16. **Repeat-Failure Breaker**
    One failure: inspect.
    Two same failures: stop the tool.
    Do not rerun.
    Prove direct road.
    Repair only from proof.

17. **User Surface Review**
    Ask whether the next user action was obvious. If the user reasonably typed a URL alone, the interface/prompt failed. Future helper should prompt for URL when missing.

18. **Command Shape Review**
    Recovery mode should use short commands or clear blocks. Avoid dense pipelines when the user is already in an error loop.

19. **Compatibility Wash**
    Identify shell/version/tool assumptions. Prefer stable .NET file writes when encoding matters because your shell rejected `Set-Content -Encoding`.

20. **Artifact Proof**
    PASS requires artifact proof, not just tool output. For transcript: `.txt` exists and length is 429,377 bytes.

21. **Proof Split**
    Separate proof from noise. Proof: direct download, VTT files, TXT file, file length. Noise: repeated old logs, emotional debate, duplicate pasted command.

22. **Lucky Break / Near Miss**
    Ask where the run could have gone worse. Here: the helper looked official enough that it could have been trusted despite failing.

23. **Impact**
    What would this mistake damage if repeated at larger scale? In this case: any wrapper could lose active object at tool boundary and still look controlled.

24. **Mechanism Extraction**
    Extract the reusable rule. Example: “A wrapper passes only when the active object survives every boundary and final artifact proves it.”

25. **Prevention Gate**
    Turn mechanism into a gate. Example: every local helper needs an external-argument handoff audit before execution.

26. **Boundary Handoff Receipt**
    Small local receipt for tools. Minimum fields: tool/version, input present, tool path, output folder, final args include object, exit code, artifact created, artifact length, verdict, failure note, next action.

27. **Dead-Weight Burn**
    Burn means stop carrying live weight, not delete proof. Keep failed logs as proof trail; stop dragging them into active reasoning.

28. **Parking / Proof Trail**
    Decide what stays only as proof history. Failed helper logs belong there, not in the live task lane.

29. **House Fit Decision**
    Classify where each mechanism belongs: chat behavior, helper design, Code Gate, proof receipt, local-only tool, BRAIN_LEARNING candidate, Soft Suit card, or no-save proof trail.

30. **Authority Boundary**
    State what this does not change. Example: no doctrine promotion, no ACTIVE_GUIDES rewrite, no CURRENT_TRUTH_INDEX rewrite, no mule rule change, no repo save unless separately authorized.

31. **Repair Candidate**
    Name exact repair, not vague improvement. Example: build `YOUTUBE_TRANSCRIPT_DESKTOP_TOOL_MIN_HELPER_V1.1.ps1` from proven direct road.

32. **Test Plan**
    Define the next proof. For V1.1: run with real URL, confirm VTT created, TXT created, length > 0, receipt written, Explorer selects file.

33. **Action Items**
    External postmortem practice stresses that preventive action items matter; a postmortem without executed action items does not improve the system. ([Google SRE][1]) House version: every action item needs owner/surface, proof condition, and return trigger.

34. **Next Leap**
    Name the next meaningful leap. Not baby step, not blind jump. For this run: V1.1 helper with boundary gates.

35. **A/B Checkpoint**
    A = progress while alive.
    B = stop truth.
    Valid B labels: `CLEAN_CLOSE`, `BLOCKED_WITH_RETURN_POINT`, `CHOKE_STOP`, `CHOKE_CAUSED_END`, `USER_STOP`.
    `CHOKE_CAUSED_END` is poison, not completion.

36. **Learning Ledger Entry**
    Every meaningful run should leave a small breadcrumb card. Not necessarily a repo save every time. The house needs a trail: run, proof, mechanism, next leap.

37. **Compression Key**
    Carry only the key forward: active object, current blocker, proof pointer, next action. Do not carry the furniture.

38. **Recurrence Watch**
    Mark whether this is first occurrence, second occurrence, or pattern. Three related occurrences becomes consolidation candidate.

39. **Powerplay Conversion**
    Convert mistake into stronger future move: failure → cause → missing gate → reusable mechanism → proof test.

40. **Close Statement**
    Final close must say: final result, placement, proof status, next action.

## The living order as a compact run shape

Use this shape after meaningful runs:

```text
AFTER-RUN BREADCRUMB WASH / LEAP-CLOSE

1. Object:
2. Intended result:
3. Actual result:
4. Boundary trace:
5. Object survival / death point:
6. Errors observed:
7. False diagnoses burned:
8. Assumptions that failed:
9. Proof that held:
10. Noise / dead carry:
11. Tool trust state:
12. Mechanism extracted:
13. Missing gate:
14. Prevention rule:
15. House fit:
16. Authority boundary:
17. Repair candidate:
18. Test plan:
19. Next leap:
20. Close label:
```

## The clean house-native principle

Do not slow the project into baby steps. Do not leap so far that the trail breaks.

Make a leap.
Close the leap.
Harvest the mechanism.
Burn the dead carry.
Carry the key.
Then leap again.

## Gate result

Final result: **READY FOR NARROW LIVE USE AS SOFT SUIT METHOD**.

Placement: candidate living order for house process; likely BRAIN_LEARNING plus a Gear Rack/Soft Suit operating card later.

Proof status: supported by the transcript failure wash, the uploaded failure map, and outside postmortem/AAR/PDSA methods.

Next action: turn this into a saved local/repo card only after you approve the lane and name.

[1]: https://sre.google/sre-book/postmortem-culture/?utm_source=chatgpt.com "Blameless Postmortem for System Resilience"
[2]: https://thesystemsthinker.com/emergent-learning-in-action-the-after-action-review/?utm_source=chatgpt.com "Emergent Learning in Action: The After Action Review"
[3]: https://deming.org/explore/pdsa/?utm_source=chatgpt.com "PDSA Cycle - The W. Edwards Deming ..."

