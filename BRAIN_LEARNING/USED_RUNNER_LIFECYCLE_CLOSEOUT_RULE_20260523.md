# Used Runner Lifecycle Closeout Rule

Status: SUPPORT RULE / ROOT CAUSE REPAIR  
Date: 2026-05-23  
Scope: `.ps1` runners, Desktop\123 porch, local helper scripts, save runners

## Root diagnosis

The problem is not merely loose `.ps1` files sitting in `Desktop\123`.

The root problem is missing runner lifecycle closeout.

A runner has a full life:
sent -> dropped at porch -> run -> proves work -> reports back -> archived as used mail -> porch returns clean.

If the runner finishes but remains loose at the porch, the work is not fully wrapped.

## Moving Forward

From now on, when I send a `.ps1` runner for `Desktop\123`, I will include the closeout path and not leave used helper scripts loose at the door.

This is better because it fixes:
- stale reruns;
- porch clutter;
- active-vs-used confusion;
- stale helper scripts pretending to be current mail;
- repeated cleanup after the user catches the mess.

## Required behavior

A runner must include or trigger:
1. drop/use path;
2. execution;
3. final report;
4. proof or receipt;
5. used-runner archive path;
6. hash/ledger where practical;
7. porch clean check.

## Safe closeout lane

Used runner files should be moved, not deleted, into a local-only used-runner archive such as:

`C:\Users\13527\Documents\Jxhnny_Kl33N_Seedz_LOCAL_ONLY\USED_PORCH_RUNNERS\...`

## Proof

Proof is the final porch root plus receipt/ledger.

A clean porch root should show only active home and approved live mail, not used helper scripts.

## Short form

A runner is not finished until its mail is closed.
