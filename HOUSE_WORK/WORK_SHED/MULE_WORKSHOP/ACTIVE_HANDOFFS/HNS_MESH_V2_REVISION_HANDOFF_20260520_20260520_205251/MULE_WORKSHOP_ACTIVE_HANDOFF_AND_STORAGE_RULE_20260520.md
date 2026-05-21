# Mule Workshop Active Handoff + Storage Rule

Date: 2026-05-20  
Status: Workflow Rule Candidate / Mule Workshop Hygiene  
Boundary: Supports mule workflow. Does not make mule authority over Mr.Kleen.

---

## Rule

The mule should have a clean workshop with an active handoff room and a storage/archive lane.

Current handoff files must not be mixed with old handoffs.

Old handoffs must not stay loose in the active working area.

The mule has bounded freedom to shape the workshop as long as custody stays clean.

---

## Recommended Workshop Shape

```text
MULE_WORKSHOP
-> ACTIVE_HANDOFFS
   Current handoff files the mule must read/use now.

-> ACTIVE_DESK
   Live working source packets and in-progress material.

-> RETURNS
   Completed outputs from mule jobs.

-> STORAGE_SHED / HANDOFF_ARCHIVE
   Old handoffs, superseded packets, stale jobs, and used source bundles.

-> INDEX
   Current active handoff pointer and archive locator.
```

---

## Required Handoff Behavior

Each mule job should include a handoff file the mule must read first.

The handoff file should say:

- task;
- context;
- read order;
- required source files;
- output lane;
- blocked moves;
- boundary;
- PASS standard;
- return format;
- workshop cleanup expectation.

---

## Cleanup Rule

After a handoff is completed:

- current handoff moves out of active handoff room;
- old handoff goes to storage/archive;
- return outputs go to RETURNS;
- active desk is cleared or narrowed to current work;
- index points to current active handoff and old archive location.

---

## Freedom Rule

The mule workshop is the mule’s workshop.

The mule may improve folder names or layout if his structure is cleaner and easier to work with.

But he must preserve:

- current vs old;
- source vs output;
- handoff vs return;
- support vs authority;
- active vs archived;
- stale vs current.

---

## Authority Boundary

The mule may recommend.

The mule may sort.

The mule may revise.

The mule may produce candidate outputs.

The mule may not install doctrine.

The mule may not rewrite ACTIVE_GUIDES.

The mule may not rewrite CURRENT_TRUTH_INDEX.

The mule may not become authority over Mr.Kleen.

The mule output must be read, dispositioned, and judged by the house before adoption.
