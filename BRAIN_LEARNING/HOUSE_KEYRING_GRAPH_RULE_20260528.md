# House Keyring Graph Rule — 20260528

Status: LOCK-SAVE CANDIDATE / ASSISTANT-FACING BEHAVIOR / ARCHITECTURE SUPPORT RULE
Authority: not doctrine; not ACTIVE_GUIDES; not CURRENT_TRUTH_INDEX
Purpose: convert rule piles, tool piles, source piles, proof piles, and parked idea piles into keyed, mapped, proof-aware house object sets.

## Core correction

A rule pile is dirty when it is unkeyed accumulation.

A rule pack can be clean when it becomes a keyed rule toolset with parent keys, subkeys, child keys, lane separation, proof state, hash/version identity, and a map.

The problem is not rule quantity by itself. The problem is unkeyed mass, unclear authority, weak retrieval, hidden conflict, and no proof state.

## Parent / subkey / child-key model

Parent key = rule family, room, lane, or object family.

Subkey = operation, gate, chain segment, or local function inside the family.

Child key = atomic usable rule, tool action, source step, proof requirement, or lifecycle decision.

Example:

SAVE
  SAVE.STAGING
    SAVE.STAGING.MANIFEST
    SAVE.STAGING.HASH
    SAVE.STAGING.IGNORE
    SAVE.STAGING.RECEIPT

Every child key must carry:

- trigger;
- job;
- lane;
- authority boundary;
- proof need;
- state;
- neighbor links;
- hash/version where saved;
- map position;
- return trigger if not complete.

## Separation plus keys

Clean separation still matters. Keys do not replace lanes.

Separation keeps jobs from mixing. Keys make separated jobs navigable.

Hash/version proof identifies the exact version. It does not prove quality, lane correctness, authority, promotion readiness, or PASS.

## Keyrings

A keyring groups related parent/subkey/child keys by lane or operation.

Examples:

- SAVE_KEYRING;
- SOURCE_KEYRING;
- TOOL_KEYRING;
- RULE_KEYRING;
- PROOF_KEYRING;
- SOFT_SUIT_KEYRING;
- PORCH_KEYRING;
- MULE_KEYRING;
- DEAD_WEIGHT_KEYRING.

A keyring is a navigation ring, not authority by itself.

## Chains

A chain records ordered dependency or workflow.

Example:

SOURCE_OBJECT -> SOURCE_MANIFEST -> CHUNK_SET -> EXTRACTION_REPORT -> DIGEST -> CANDIDATE_PATTERNS -> FIT_DECISION -> RECEIPT -> SAVE_ROUTE

A chain answers:

- what came before;
- what comes after;
- what proof closes the path;
- what object depends on what;
- what action produced what.

## Snap-links

A snap-link is a reversible, typed connection between objects.

A snap-link connects without merging authority.

It says:

Object A is connected to Object B for this reason, under this boundary, until this condition expires.

Snap-links are used for:

- source-to-rule support;
- candidate-to-proof connection;
- tool-to-output connection;
- batch handoff;
- neighbor awareness;
- temporary source-to-house relations;
- parking and return triggers.

Core rule:

Everything can be connected. Not everything should be merged.

## Capability keys

A capability key grants one bounded operation, not ambient authority.

Example:

SAVE.STAGING.FORCE_ADD_EXACT_FILE

This key allows one exact manifest-approved force-add under its proof contract. It does not allow broad Git writes, folder force-add, doctrine edits, ACTIVE_GUIDES edits, or CURRENT_TRUTH_INDEX edits.

## House Object Graph

The house should treat major things as objects with relations, not only files or rules.

Object families include:

- rules;
- tools;
- gates;
- sources;
- receipts;
- helpers;
- batches;
- parked ideas;
- active objects;
- maps;
- proof files;
- Soft Suit candidates;
- deprecated/dead-weight items.

A House Object Graph asks:

- what object is this;
- which keyring owns it;
- which chain is it in;
- what snap-links touch it;
- what proof state is it in;
- what authority does it have;
- what hash/version identifies it;
- what retires it;
- what should happen next.

## Shoe-Fit Import Rule

Borrow ideas from anywhere if the shoe fits.

Outside ideas are source ore, not authority. They must be made house-native before they gain power.

Shoe-fit questions:

- does it reduce fog;
- does it preserve separation;
- does it improve routing;
- does it improve proof;
- does it avoid fake authority;
- can it be tested in a small batch;
- can it be retired cleanly if wrong;
- does it create less burden than it removes.

## Proof states

Use proof states to prevent fake PASS:

RAW -> READ -> MAPPED -> HASHED -> CODE_GATED -> LIVE_RUN -> OUTPUT_JUDGED -> PLACED -> SAVED -> REMOTE_MATCHED -> CLEAN_CLOSED

A thing can be hashed but not placed, code-gated but not output-judged, saved but not promoted, or mapped but not proven.

## Lifecycle states

Use lifecycle states to prevent old objects from looking current:

ACTIVE
SOFT_SUIT
CANDIDATE
PARKED_WITH_RETURN
BLOCKED
SUPERSEDED
DEPRECATED
DEAD_KEY
ARCHIVED_PROOF_ONLY

## Link types

Do not use vague related-to links when a typed link is possible.

Core link types:

SUPPORTS
DERIVED_FROM
DEPENDS_ON
USES_TOOL
PROVES
BLOCKED_BY
CONFLICTS_WITH
SUPERSEDES
PARKED_WITH
OWNER_OF
SNAP_ONLY
RETIRE_AFTER
WHY_LINK

## Dead keys

A dead key is a retired key that remains visible historically so old commands, old helpers, or old proof language do not resurrect it as live authority.

Dead does not mean deleted. It means not live.

## Guardrails

Do not build a graph database yet.
Do not build a giant universal mapper yet.
Do not key every sentence.
Do not let snap-links become hidden doctrine.
Do not let hashes pretend to prove quality.
Do not let key possession imply broad authority.
Do not replace lane separation with a key system.
Do not promote doctrine, rewrite ACTIVE_GUIDES, or rewrite CURRENT_TRUTH_INDEX from this rule.

## First narrow push

First useful test should be a small Markdown/CSV House Keyring Map V1 covering the current active production lane:

SOURCE_TO_HOUSE_INTAKE_KEYRING -> focused extraction -> fit report -> proof ladder -> save route.

The map proves itself by reducing fog in one live chain, not by covering the whole house at once.