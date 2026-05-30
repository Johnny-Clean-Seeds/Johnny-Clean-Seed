# Edward All-Room Triple Pathfinding Source Expansion

Date: 2026-05-30
Status: SOURCE EXPANSION / FIT REPORT / NOT DOCTRINE
WorkKey: EDWARD-ALL-ROOM-TRIPLE-PATHFINDING-SOFT-SUIT-20260530-V1

## Source fit summary

This report broadens the pathfinding concept before lock/save.

The material was initially too thin. It had good bones: roots, slime mold, ants, growth cones, and algorithmic path search. But it needed more words, more lanes, more mechanics, and a stronger separation between metaphor and usable behavior.

The stronger shape is:

Pathfinding is not "search everything."

Pathfinding is controlled sensing under partial visibility.

A pathfinder has:

- a target smell;
- a starting point;
- partial terrain;
- cost pressure;
- wrong turns;
- memory;
- constraints;
- proof needs;
- return path;
- and a stop condition.

## Useful source families

### Living systems

Roots:
Roots adapt architecture and growth direction based on environmental signals. Hydrotropism specifically modifies root growth toward moisture gradients. House use: branch only when the target scent improves.

Mycelium:
Mycelial systems explore resource fields while balancing cost and gain. House use: do not keep extending low-yield search branches.

Slime mold:
Physarum-style adaptive transport networks strengthen useful tubes and can converge toward shortest paths in models. House use: paths thicken by proof-flow, not by interest.

Ant trails:
Ant foraging can self-organize through pheromone-like marks and trail decay. House use: repeated useful hits mark a route; weak marks fade.

Axon growth cones:
Growth cones navigate by local cues, dynamic tips, attraction, repulsion, and internal response. House use: feel ahead before committing a path.

Chemotaxis:
Chemotactic movement does not require a full map; it can compare signal changes over time. House use: if the scent gets stronger, continue; if it weakens, turn or cut.

### Formal algorithms

BFS:
Good for shallow complete sweeps.

DFS:
Good for long descent into one branch.

Dijkstra:
Good when cost matters and no heuristic is trusted.

A*:
Good when target scent is strong enough to guide a cost-aware route.

D* / D* Lite:
Good when the map changes after movement starts.

Theta*:
Good when grid/folder boundaries are artificial and a cleaner line-of-sight shortcut exists.

Jump Point Search:
Good when grid-like repetition creates redundant expansions.

RRT:
Good when the space is large, unknown, or high-dimensional.

PRM:
Good when you need landmarks first, then route between them.

Potential fields:
Good when attractions and obstacles matter more than exact graph edges.

Ant colony optimization:
Good when repeated attempts should reinforce useful routes and weaken others.

Particle swarm / genetic search:
Good as inspiration for multiple candidate routes, but dangerous in chat because they can create branch bloat unless capped.

### Human / information systems

Information foraging:
Information sources emit scent. The searcher estimates value, cost, and access path from cues. House use: visible names, folders, snippets, hashes, and relation labels are scent.

OODA:
Observe, orient, decide, act, then use feedback. House use: do not stay in observe forever; do not act without re-orienting.

Double-loop learning:
Repeated error means the governing assumption may be wrong. House use: if exact-title search fails repeatedly, change the search model.

Wayfinding:
People use landmarks, routes, survey knowledge, signs, and memory. House use: use file names, ledgers, indexes, parent folders, and known rules as landmarks.

Forensics:
Evidence must be preserved before the scene is changed. House use: read and label before modifying.

Network routing:
Routes need reliability, loop avoidance, updates, and fallbacks. House use: do not follow tunnels that loop back without proof.

Compiler resolution:
Names are resolved by scope, imports, precedence, and aliases. House use: file title, nickname, folder lane, old chat label, and rule name may all be aliases of one object.

Cache invalidation:
Memory can speed lookup, but stale cache is dangerous. House use: memory trace is allowed as scent, not proof.

## Strongest idea set

The broad useful set is:

- gradient sensing;
- branch caps;
- proof-flow reinforcement;
- decay of weak marks;
- cost-aware search;
- replanning when terrain changes;
- breadcrumbs and return ropes;
- distinction between memory, side hit, and found;
- typed relation sewing;
- checkpoint breath reset.

## Things to cut

Cut "anything goes" if it means no boundary.

Cut "all rooms all at once" if it means every method active simultaneously.

Cut decorative metaphor that does not change search behavior.

Cut endless source gathering when the job is to build a candidate.

Cut over-linking. A tunnel is only useful if it says what it carries, what proves it, and when to stop.

Cut false victory. A target name in memory is not a file find.

## Final fit

This source expansion fits the house as a Soft Suit candidate because it reduces a real failure family:

- target recognized but not proved;
- side hits over-weighted;
- fog not labeled clearly;
- branch paths not cut;
- search route not recorded;
- memory used without proof boundary.

It should be tested on one or more real searches before promotion.