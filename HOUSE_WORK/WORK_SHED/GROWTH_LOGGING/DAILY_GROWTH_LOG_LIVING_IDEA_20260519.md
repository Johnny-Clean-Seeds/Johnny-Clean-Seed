# Daily Growth Log Living Idea

Status: living idea / Work Shed object
Date formed: 2026-05-19

Purpose:
Create a simple daily growth tracking system that logs the previous full user-day's data amount.

Core idea:
At 12:00 AM user time, yesterday becomes complete. That is the first clean moment to log that day's growth amount.

Important distinction:
The data belongs to the user's previous day.
The held log is created at assistant run time.
The final house save happens later when the user returns and lock/saves it.

This means one record may need three separate labels:
1. User data period.
2. Assistant run timestamp.
3. Mr.Kleen save/commit timestamp.

Working rule:
Do not blur these together.

Current state:
This is not active automation yet.
This is not final doctrine.
This is a living house idea that needs one controlled test.

Test concept:
Create a held test log after a short delay.
The held test should prove:
- the assistant can wake/run,
- the assistant can create a correctly labeled held entry,
- the assistant does not claim local save,
- and the entry is ready for later Mr.Kleen lock/save.

Placement:
Work Shed / Growth Logging.

Boundary:
No local save happens automatically while the user is away.
No daily system should be treated as proven until the test shows clean behavior.
