# Pending Bay / Complete Set Bundle Gate Rule

Date: 2026-05-30
Status: SUPPORT RULE / NOT DOCTRINE
Authority: not ACTIVE_GUIDES, not CURRENT_TRUTH_INDEX

## Focal rule

Related dropped files form a bundle.

The first gate must not fire blindly on the first file. It must either enforce order or wait until the complete expected set is present.

Only after the expected set is present may the gate hash/classify the bundle, assign bundle id/key, verify required members, classify extras, route by manifest/order, and select one next action.

## Pending Bay

The Pending Bay is the waiting room for incomplete, uncertain, extra, duplicate, or not-yet-ordered drop bundles.

It is custody, not failure.
It preserves useful material while preventing premature action.

## Live bundle event

DropRoot:
C:\Users\13527\Desktop\123

BundleVerdict:
BUNDLE_COMPLETE / READY_FOR_CODE_GATE

Members:
- FOUND | bigcode.txt | Role=SOURCE_BODY / REVIEW_EXTRA / NOT_RUNNABLE | Size=39630 | SHA256=F8D06F86C497ABC5125E33A8BF769D57946A59CF222F213C21B578766467D18F | Path=C:\Users\13527\Desktop\123\bigcode.txt
- FOUND | DUAL_SHELL_TANDEM_GATE_BRIDGE_DEEP_SEARCH_PILES_V1.md | Role=SOURCE_ARTIFACT | Size=15223 | SHA256=3C2930A9E3F53FD8F3E928779A106F67E5442BF23AACE815BE6BBC640FC1B86F | Path=C:\Users\13527\Desktop\123\DUAL_SHELL_TANDEM_GATE_BRIDGE_DEEP_SEARCH_PILES_V1.md
- FOUND | LOCK_SAVE_DUAL_SHELL_TANDEM_LIVING_PILES_V1.ps1 | Role=SCRIPT_CANDIDATE / CODE_GATE_ONLY | Size=22635 | SHA256=41AAE10FEBB0468D9BA49EA5174DC651AA5852700B44B397EED37718F7DF82F6 | Path=C:\Users\13527\Desktop\123\LOCK_SAVE_DUAL_SHELL_TANDEM_LIVING_PILES_V1.ps1

## Imported concepts

Aggregator:
collect related members until the complete set exists.

Resequencer:
arrival order is not route order; assign correct order before action.

Done file / read lock:
file existence is not readiness; use stable hash/size, ready marker, or complete set.

Idempotent receiver:
duplicate hashes/keys do not trigger repeat work blindly.

Invalid message channel:
unknown or malformed members go to invalid/review lane.

Dead letter channel:
unrouteable bundles park with reason.

Claim check:
manifest carries paths/hashes/roles instead of moving large payload text through every route.

Landing/staging:
root is landing; Pending Bay is staging; Ready Bay is route-ready.

## Bay lanes

ROOT_DROP_LANDING
PENDING_BAY
READY_BAY
INCOMPLETE_BAY
EXTRA_REVIEW_BAY
INVALID_MEMBER_BAY
DEAD_LETTER_BAY
DUPLICATE_BAY
CLAIMED_BAY
RUNNING_BAY
RECEIPT_BAY
ARCHIVE_BAY

## States

BUNDLE_UNKNOWN
BUNDLE_DETECTED
WAITING_FOR_BUNDLE_COMPLETION
BUNDLE_STABLE_CHECK
BUNDLE_COMPLETE
BUNDLE_HAS_EXTRA_MEMBERS
BUNDLE_HAS_INVALID_MEMBERS
BUNDLE_ORDER_BLOCKED
BUNDLE_READY_FOR_CODE_GATE
BUNDLE_CLAIMED
BUNDLE_RUNNING
BUNDLE_RECEIPT_READY
BUNDLE_ACKED
BUNDLE_PARKED
BUNDLE_DEAD_LETTERED
BUNDLE_ARCHIVED

## Hard blocks

No first-file trigger.
No .txt execution.
No .ps1 execution without Code Gate.
No route while required bundle members are missing.
No ignored extras.
No silent delete.
No watcher by default.
No broad root crawl.
No treating root folder as authority.

## Living rules

Pending Bay Rule:
incomplete or uncertain bundles wait in a named bay with manifest, missing list, and return trigger.

Complete Set Rule:
related drops route only after required members are present and classified.

Order Before Action Rule:
arrival order is not route order.

Manifest Before Route Rule:
no bundle routes without manifest.

Stable Before Consume Rule:
file existence is not readiness.

Extras Are Evidence Rule:
unknown files are reviewed, not ignored.

Duplicate Is Not Repeat Rule:
same hash/key does not trigger repeat work unless route says so.

No First-File Trigger Rule:
first observed file cannot command the route.

## Next action

Resume DUAL_SHELL_TANDEM_GATE_BRIDGE_SESSION_PROTOCOL_V1 after this support rule is saved.
