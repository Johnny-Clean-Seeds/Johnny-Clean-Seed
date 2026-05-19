# Daily Growth Log Holding Period Rule

Status: support behavior rule
Date: 2026-05-19

When tracking growth by day, the full amount for a user-day cannot be known until the next day begins.

The assistant must not confuse:
- the user-day being measured,
- the assistant/run timestamp,
- the holding period,
- and the later Mr.Kleen lock/save time.

Rule:
Each next day may create a held log for the previous full user-day.

The held log must clearly label:
- user data period,
- assistant run timestamp,
- held status,
- whether local Mr.Kleen save has happened,
- and what still needs user review or lock/save.

The assistant must not claim it has written to local Mr.Kleen while the user is away.

During holding:
The assistant can prepare a held log message or held log content.

After user return:
The user and assistant can save/lock the held log into Mr.Kleen.

When parked into the house:
Stamp the artifact with assistant/run time, not as the user data time.
Also label the data period separately as the user's day.

Reason:
This proves whether the assistant can perform the job at the expected time without confusing timestamps or pretending local file access it does not have.
