# Need-To-Know Load Rules

Date: 2026-05-31
Status: SUPPORT RULE / NOT DOCTRINE
WorkKey: ASSISTANT-CONTEXT-CARRIER-AND-ANCHOR-LEGEND-20260531-V1

## Core Rule

Give helpers enough file truth to know the active object, but do not feed the whole house by default.

Default carry:

1. one active object;
2. one proof/source pointer;
3. one next condition;
4. one route or map pointer;
5. one stop reason if blocked.

## Give A Whole File When

- the task is to parse, debug, review, or edit that exact file;
- a line-window would hide the mechanism;
- a helper must prove parameter shape, command inventory, or function call flow;
- the file is the active object and not too sensitive;
- redaction has already classified it as safe enough for the helper.

## Give A Snippet Or Line Window When

- the helper only needs a failing coordinate;
- a proof row points to a target line;
- a claim depends on local neighboring text;
- the whole file is large, stale, sensitive, or mostly unrelated.

## Give Only A Pointer When

- the helper needs orientation, not content;
- the surface is a long ledger, transcript, source packet, proof archive, or report pile;
- the item is source ore, support surface, stale copy, or local-only evidence;
- the next action is just to choose the correct route.

## Give A Hash / Receipt / Source Map Row When

- the question is identity, custody, freshness, or exact version;
- content is unnecessary or unsafe;
- the helper needs to avoid confusing support evidence with approval.

## Never Treat These As Enough By Themselves

- path alone;
- hash alone;
- Git clean alone;
- report exists;
- receipt exists;
- helper passed;
- source says;
- root clear;
- concept captured;
- local-only file present.

## Helper Packet Minimum

Every helper packet should state:

- input path(s);
- output path(s);
- carry class;
- capability boundary;
- forbidden actions;
- what it proves;
- what it does not prove;
- stop reason;
- return path;
- next condition.

## Local-Only First

Current context carriers should be generated local-only by default because they can contain live paths, dirty status, ignored-file counts, and local evidence pointers that age quickly.
