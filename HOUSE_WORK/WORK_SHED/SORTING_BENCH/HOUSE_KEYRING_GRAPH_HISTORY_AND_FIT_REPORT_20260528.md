# House Keyring Graph — History, Fit, and Deep Build Report — 20260528

Status: HISTORY/FIT REPORT / THINK TANK OUTPUT / LOCK-SAVE SUPPORT
Authority: not doctrine; not ACTIVE_GUIDES; not CURRENT_TRUTH_INDEX

## Why this exists

A prior history review warned against rule piles. The user corrected the shape: a rule pile is not inherently dirty if it becomes keyed, hashed, mapped, and separated.

The clean distinction is:

BAD RULE PILE = many rules with no routing.
GOOD RULE PACK = many rules with keys, lanes, triggers, proof states, and map position.

This report preserves that correction and extends it to all major house objects.

## What the chat added that must not be dropped

- rule piles can be clean if converted into keyed toolsets;
- parent keys, subkeys, and child keys make rules navigable;
- clean separation still matters and keys make separation retrievable;
- hash/version identifies exact object version but does not prove quality;
- keyrings group related keys by lane or operation;
- chains record workflow order and dependency;
- snap-links connect objects without permanent glue or merged authority;
- snap-links can be attached, detached, expired, replaced, or promoted later;
- all major house objects can use this model, not only rules;
- capability keys grant exact bounded action, not broad permission;
- outside ideas can be borrowed if the shoe fits;
- outside ideas remain source ore until made house-native;
- House Object Graph is the preferred parent concept;
- no graph database or universal mapper yet;
- start with small Markdown/CSV map for active lane;
- dead keys keep retired keys traceable without making them live.

## Outside ideas adapted by shoe-fit

Git/IPFS content addressing -> HASH_ID for exact version identity.

Merkle DAGs -> root manifest can seal a group of child objects by hash relation.

Kubernetes labels/annotations -> use labels for routing and notes for non-routing context.

Kubernetes owner references/finalizers -> owner links and close blockers prevent premature retirement.

W3C PROV -> proof chain: entity/action/actor/product/receipt.

SLSA/in-toto -> house step: inputs, outputs, actor/tool, expected products, boundary, receipt.

JSON-LD/SKOS/SHACL -> possible later object-card vocabulary and shape validation, not immediate tooling.

Bazel/Nix dependency query -> WHY_LINK explains why one object depends on another.

OpenAPI operation IDs/links -> OP_KEY and CHAIN_LINK for operation-to-operation flow.

OpenTelemetry semantic conventions -> common names prevent tools describing same thing inconsistently.

Object-capability model -> capability key grants exact bounded action only.

Zettelkasten -> idea cards and snap-links beat loose note piles.

## House-native rooms/tools proposed

Key Forge — creates clean parent/subkey/child-key names.

Keyring Rack — stores grouped keyrings by lane.

Chain Loom — builds ordered paths from source to action to product to proof to save.

Snap-Link Board — stores temporary reversible links.

Capability Locksmith — verifies a key grants only the exact action needed.

Proof Mesh — connects object, action, receipt, commit, remote match, and final state.

Dead-Key Graveyard — keeps retired keys visible so old commands do not resurrect.

Why-Link Desk — every dependency must answer why these objects are connected.

Shoe-Fit Bench — checks whether a borrowed idea reduces fog and can be tested or retired.

## Active test lane

The best first test is Source-to-House Intake V2 focused extraction.

Test chain:

source batch -> intake manifest -> chunks -> extraction -> digest -> candidate rules/tools -> fit decision -> save packet -> Lane-Locked Manifest Staging -> receipt -> clean close

Related keyrings:

- SOURCE_KEYRING;
- TOOL_KEYRING;
- PROOF_KEYRING;
- SAVE_KEYRING;
- SOFT_SUIT_KEYRING;
- DEAD_WEIGHT_KEYRING.

## Fit judgment

This architecture fits because it preserves separation while adding retrieval, map position, proof state, and reversible links.

It should not become a giant new authority layer yet.

It should first exist as a lightweight map and object-card pattern.

## Do not repeat

Do not make a huge knowledge graph before the small map proves itself.
Do not make every phrase into a child key.
Do not let source links become doctrine links.
Do not use a hash as quality proof.
Do not give broad authority to a narrow key.
Do not bury current-state clarity under a new mapping project.

## Recommended next move

Create a small House Keyring Map V1 for the current active lane and test it on Source-to-House Intake V2 focused extraction.

If it reduces fog, later build a helper. If it adds burden, park or trim it.