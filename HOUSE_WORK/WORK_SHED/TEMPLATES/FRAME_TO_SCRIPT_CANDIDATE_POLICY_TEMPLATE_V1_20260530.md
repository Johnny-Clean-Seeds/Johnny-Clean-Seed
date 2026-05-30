# Frame-to-Script Candidate Policy Template V1

Date: 2026-05-30
Status: POLICY TEMPLATE / SUPPORT CONCEPT

## Default policy

AllowedScriptTypes:
- ps1_candidate
- cmd_launcher_candidate
- no_script_decision

DefaultBlockedActions:
- delete
- move
- git_add_all
- git_commit_push
- network
- registry_edit
- scheduled_task
- service_install
- whole_drive_recursion
- wildcard_write
- hidden_args
- self_modify
- auto_elevate
- permanent_install

DefaultRequiresApproval:
- Git write
- delete
- move
- network
- system touch
- permanent tool placement
- cmd launcher placement
- broad scan
- raw source save

DefaultProofRequired:
- source hash
- frame id
- candidate hash
- template id/hash
- policy version
- output path/hash
- receipt path
- Code Gate report if code exists
- Final Judge verdict

## Decision defaults

If frame incomplete:
FRAME_REPAIR_NEEDED.

If key route manual-only:
NO_SCRIPT_ALLOWED.

If output contract missing:
NO_CANDIDATE.

If policy blocked:
POLICY_BLOCKED.

If candidate written:
CODE_GATE_REQUIRED.

If Code Gate passed:
JOB_PROOF_STILL_REQUIRED.

If proof scope narrow:
NO_PROMOTION.

If .cmd contains logic:
CMD_BLOCKED.
