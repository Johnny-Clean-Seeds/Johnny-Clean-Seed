# Extended Source-To-Claim Map - HNS Mesh V2 Deepening Pass

Date: 2026-05-21
Lane: Mule return / extended source map
Status: Source support only

## Boundary

This map does not promote outside sources into house truth. Each row states the supported house claim, adaptation, boundary, and what it does not prove.

## Extended Map

| Source / concept | House claim supported | HNS adaptation | Boundary | Does not prove |
| --- | --- | --- | --- | --- |
| OpenTelemetry, "What is OpenTelemetry?" | Sensors and instrumentation should precede alarms. | A lane cannot cleanly alarm unless it can emit a named signal. | OTel is a software telemetry standard, not house doctrine. | Does not authorize runtime, collector, dashboard, or backend. |
| OpenTelemetry Semantic Conventions | Word-key clarity and common signal naming matter. | HNS should keep stable names for signal, sensor, threshold, alarm, debugger, route, proof, memory, decay. | Use as naming discipline only. | Does not require adopting OTel schemas. |
| Google SRE Monitoring Distributed Systems | Monitoring should distinguish symptom from cause. | Alarm names symptom; debugger traces cause. | SRE is operational source ore. | Does not make every house problem a service outage. |
| Google SRE Alerting on SLOs | Alarm quality requires precision, recall, detection time, and reset time. | HNS alarm ledger should track false alarms, misses, delay, and quiet-after-fix. | Use as quality frame. | Does not authorize automated SLO alerting. |
| NIST SP 800-61 Rev. 3 | Serious incidents require preparation, detection, response, recovery, and improvement. | High-risk HNS alarms should end in repaired, parked, blocked, decayed, or escalated. | Cybersecurity incident guidance is not all-purpose doctrine. | Does not classify every signal as an incident. |
| NASA Technical Risk Management | Rigor should be tailored to program context and governing bounds. | HNS should scale checks by risk, uncertainty, and consequence. | Source support for scaling. | Does not permit deviating from house authority. |
| NASA Systems Engineering Handbook | Decision analysis should define decision need, criteria, alternatives, uncertainty, and report results. | For high-risk HNS decisions, define the decision before collecting endless signals. | Use for complex choices only. | Does not require heavy NASA ceremony for small tasks. |
| NIST control loop glossary | Control loops include sensors, controller, actuators, variables, and feedback. | HNS architecture maps signal -> sensor -> debugger/controller -> route/reflex -> feedback. | Industrial-control glossary only. | Does not turn HNS into hardware or automation. |
| STAMP Institute | Losses can arise from inadequate control, flawed process models, and missing/delayed feedback. | Dead Nerve and Process Model Mismatch should be named root classes. | Safety model support. | Does not authorize HNS as a safety management system. |
| Leveson STPA tutorial | Causal scenarios include wrong/missing info, inadequate controller model, feedback delays, conflicting actions. | HNS debugger should ask whether information, feedback, model, or control action failed. | Use as root-cause lens. | Does not install STPA as required process. |
| STPA Handbook | Too much raw data can be dangerous; information must be timely, accurate, useful, and tailored. | HNS must guard against source overload and alarm storm. | Source support for anti-bloat. | Does not prove more documentation is always better. |
| Conant/Ashby Good Regulator theorem | Effective regulation requires a model. | Add Model Spine to HNS: active ball, authority, object role, expected state, observed signal, route, proof, close. | Cybernetic theory supports pattern language. | Does not prove the model is complete or final. |
| Ashby Requisite Variety | The regulator needs enough variety to absorb disturbance variety. | Many sensor families are valid, but must be routed and scoped. | Supports "enough sensors, no sensor soup." | Does not justify infinite sensors or all-to-all graph. |
| Hollnagel Resilience Engineering | Resilient performance depends on respond, monitor, learn, anticipate. | HNS should learn from alarms and update sensors, routes, and decay. | Resilience frame only. | Does not install a resilience program. |
| Endsley Situation Awareness | Dynamic work needs perception, comprehension, and projection. | Focus Nerve: observe current state, understand meaning, project next safe move. | Human factors theory, not authority. | Does not prove assistant cognition equals human SA. |
| Seeley Salience Network | Salience filtering is a real research family; essential functions remain debated. | Use salience as a source pattern for relevance gating, with uncertainty label. | Biological analogy with uncertain boundaries. | Does not prove exact brain mechanism or house implementation. |
| Baars Global Workspace | Local processors and global broadcast can be separated. | Local signals stay local until threshold/cross-lane relevance. | Cognitive architecture analogy. | Does not authorize central dashboard or global broadcast feed. |
| Clark Predictive Processing | Prediction error frames meaningful difference from expectation. | HNS trigger = expected clean state vs observed dirty state, not raw input. | Conceptual support. | Does not install active inference or predictive runtime. |
| NCBI Homeostasis | Control needs setpoints, receptors, controllers, effectors, feedback; failures can occur at detection, loop, response, or setpoint. | HNS should test whether failure is sensor, threshold, debugger, route, reflex, proof, or close condition. | Biological/medical source analogy. | Does not make the house a body or medical system. |
| Schulkin Social Allostasis | Regulation can be anticipatory and adaptive but chronic overactivation creates overload. | HNS can anticipate repeated risk but must avoid chronic alarm state. | Source support for feedforward and overload caution. | Does not prove every signal should be anticipated. |
| NCBI Alarm Fatigue | Excessive and false/nonactionable alarms can desensitize responders and cause missed alarms. | Alarm Storm Detector and No Alarm King are necessary safeguards. | Healthcare alarm evidence transfers only as analogy. | Does not prove house alarms have same risk rate. |
| Signal Detection Theory source | Hits, misses, false alarms, correct rejections, criterion, and sensitivity clarify threshold quality. | HNS should track dead nerves and false alarms as paired quality outcomes. | Source support for detection language. | Does not require statistical ROC modeling. |
| Artificial immune anomaly detection, Forrest et al. | Self/nonself discrimination can be distributed, local, and tunable. | Source-ore/authority sensors can distinguish known house self markers from foreign steering. | Computer security analogy. | Does not authorize intrusion detection system build. |
| Dendritic Cell Algorithm source | Danger models combine safe/danger/context signals rather than only known signatures. | HNS immune nerve should look for source context: source steering, missing proof, lane mismatch. | Algorithmic inspiration only. | Does not install AIS algorithm. |
| Brooks, Intelligence Without Representation | Complete small systems should be built incrementally with real sensing/action. | Tiny nerve tests should be complete in miniature before expansion. | Robotics/AI analogy. | Does not authorize autonomous action. |
| Solomon/Corbit opponent process | Strong affects and repeated stimulation can produce opposing processes and after-effects. | Every strong alarm needs brake, reset, and decay counterpart. | Motivational theory support. | Does not make valence/affect authority. |
| IBM autonomic computing / MAPE-K | Monitor, analyze, plan, execute, knowledge gives a control-loop template. | HNS maps monitor=sensor, analyze=debugger, plan=route, execute=reflex/action, knowledge=proof/memory/decay. | Source pattern only. | Does not authorize self-management automation. |

## Claim Clusters

### Model Spine Cluster

Strongest sources:

- Conant/Ashby.
- STAMP.
- Endsley.
- NASA decision analysis.

House claim:

HNS must keep a live model of current work, not just collect signals.

### Alarm Quality Cluster

Strongest sources:

- Google SRE alerting.
- NCBI alarm fatigue.
- Signal detection theory.
- STPA data overload warning.

House claim:

No Alarm King requires tracking false alarms, misses, reset, and nonactionable noise.

### Custody / Authority Cluster

Strongest sources:

- House active guides and anchor.
- Artificial immune systems.
- STAMP process model mismatch.
- Mule workshop docs.

House claim:

Source material must be classified before it can steer.

### Tiny Test Cluster

Strongest sources:

- Brooks incremental complete systems.
- NASA validation/testing.
- SRE alert tuning.
- HNS existing tiny nerve template.

House claim:

Build one complete tiny nerve on a real signal before broad adoption.

## Source Gaps

UNKNOWN: Some cited source pages were searched/opened through abstracts or PDFs, not fully deep-read end to end.

UNKNOWN: Some topics such as Valence Council are house-internal and were not externally verified.

UNKNOWN: No source here proves house adoption.

