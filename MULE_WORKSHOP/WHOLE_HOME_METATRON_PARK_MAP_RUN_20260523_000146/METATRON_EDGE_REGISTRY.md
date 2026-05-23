# METATRON_EDGE_REGISTRY

| Edge | From | To | Actor | Close |
|---|---|---|---|---|
| ROOT_DROP_TO_INSPECT | FRONT_GATE_START_HERE | LOCAL_TRUTH_MULE_ROOM | mule/assistant | classification assigned |
| INSPECT_TO_READY | LOCAL_TRUTH_MULE_ROOM | READY_TO_DROP_IN_CHAT | assistant/mule | waiting user or consumed after verify |
| READY_TO_USER_ACTION | READY_TO_DROP_IN_CHAT | CURRENT_USER_ONLY | user only | current verify run |
| USER_ACTION_TO_CURRENT_VERIFY | CURRENT_USER_ONLY | CURRENT_READ_ONLY_VERIFY | assistant/mule verifier | expected hash/name match or blocker |
| READY_DUPLICATE_TO_CUSTODY | READY_TO_DROP_IN_CHAT | CUSTODY_ARCHIVE | mule/assistant | READY no stale duplicate |
| OLD_SCAFFOLD_TO_CUSTODY | GPT_PROMPTS_ROOT_FRONT_DOOR | DEPRECATED_OLD_SCAFFOLD | mule/assistant | old scaffold absent from active lanes |
| HELPER_SCRIPT_TO_TOOLS_OR_CUSTODY | GPT_PROMPTS_ROOT_FRONT_DOOR | TOOLS | mule/assistant | no helper scripts in root/front door |
| FAILED_TOOL_TO_FAILED_TOOLS | TOOLS | FAILED_TOOLS | mule/assistant | failed tool labeled |
| UNKNOWN_TO_ISSUE_REVIEW | LOCAL_TRUTH_MULE_ROOM | ISSUE_REVIEW | mule/assistant | decision pending with reason |
| PUBLIC_POINTER_TO_PROJECT_URL | PROJECT_URL_PUBLIC_SAFE_MAP | PROJECT_URL_PUBLIC_SAFE_MAP | mule/assistant | no private text leaked |
| PRIVATE_SOURCE_TO_LOCAL_ONLY | LOCAL_TRUTH_MULE_ROOM | CUSTODY_ARCHIVE | mule/assistant | private content not public |
| CURRENT_DEBRIS_TO_CUSTODY_AFTER_ACTIVE_VERIFY | CURRENT_READ_ONLY_VERIFY | CUSTODY_ARCHIVE | mule/assistant | CURRENT active set only or blocked |