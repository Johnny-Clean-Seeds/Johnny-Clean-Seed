# Packaging Link Cluster and No Nested Zips Rule

Date: 2026-06-04
Status: BRAIN LEARNING RULE / PACKAGING PRESENTATION / USER-CORRECTION CAPTURE
WorkKey: PACKAGING-LINK-CLUSTER-NO-NESTED-ZIPS-20260604

## Core rule

When delivering related files, keep the file links visually clustered together.

Do not break a group of related download links apart with small labels, extra headings, or spacing between each individual link.

Use one clear explanatory sentence before the cluster, then place the links together, then add any placement note after the cluster.

## Correct presentation shape

Use this shape:

Here are the files for the packet:

[file 1]
[file 2]
[file 3]

Put them in the same folder. No nested zips.

## Why

The user finds clustered links easier to see and handle.

The problem is not the existence of explanation. The problem is scattering related files with little labels and spaces between them so the group becomes visually broken.

## Packaging construction rule

Do not put zipped folders or `.zip` files inside another `.zip` package unless the user explicitly asks for nested archives.

If files belong together, send one flat zip containing the files directly.

If a separate zip/source artifact also matters, send it separately and plainly say where it goes.

## Delivery rule

For related files:

1. Put the explanation above the cluster.
2. Put all related links together in one clean group.
3. Do not add mini-labels above each individual link.
4. Do not add blank spacing between each individual link.
5. Add the placement note below the cluster.
6. Keep the note plain and direct.

## Bad shape

Avoid this:

Rule file:

[file 1]

Manifest:

[file 2]

Zip:

[file 3]

This breaks the group visually.

## Good shape

Use this:

Here are the files:

[file 1]
[file 2]
[file 3]

Place them together in the same folder.

## Boundary

This rule controls artifact packaging and presentation.

It does not authorize nested archives.
It does not authorize broad refactor.
It does not authorize delete/move of user files.
It does not replace proof receipts or manifests.
It does not require every answer to include files.
It applies when files are being delivered or grouped for a work packet.

## Closeout line

Use this when the rule is followed:

`PACKAGING_LINK_CLUSTER_RULE_APPLIED / NO_NESTED_ZIPS`

Use this when blocked:

`PACKAGING_LINK_CLUSTER_BLOCKED_WITH_REASON`
