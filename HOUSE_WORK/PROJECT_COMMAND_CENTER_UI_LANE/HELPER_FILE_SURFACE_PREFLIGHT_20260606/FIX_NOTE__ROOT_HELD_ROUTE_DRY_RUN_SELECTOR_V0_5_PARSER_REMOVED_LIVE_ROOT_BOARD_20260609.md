# FIX NOTE — ROOT HELD ROUTE DRY-RUN SELECTOR V0.5 PARSER REMOVED / LIVE ROOT BOARD 20260609

Status: FIX_NOTE / SAME_FAILURE_FAMILY_REPAIR / NO_PHYSICAL_ROUTING

## Fix

V0.5 stops trying to repair the brittle expected-row parser. It verifies the expected Git head, checks clean Git status, searches for route-plan proof objects by filename, snapshots the live project root, hashes live top-level files, and creates receptionist tickets. Because expected route-plan row parsing is disabled, every non-system live-root file remains review-required and no movement eligibility is inferred.

## Boundary

This fix does not authorize movement, deletion, cleanup, route execution, helper execution, commit, or push.
