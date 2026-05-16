CLEANSEED LIVE PULL BRIDGE V1

Purpose:
Local read-only pull bridge for current safe evidence from approved roots.

Approved roots:
PROJECT = C:\Users\13527\Desktop\Clean Milk not-BLOAT
SHED = C:\Users\13527\Desktop\Shed

Bind:
127.0.0.1:8791 only.

Endpoints:
GET /status
GET /manifest
GET /delta
GET /file?root=PROJECT&path=RELATIVE_PATH
POST /checkpoint

Start:
powershell -ExecutionPolicy Bypass -File C:\CleanSeedsBuild\CleanSeedLivePullBridgeV1\START_LIVE_PULL_BRIDGE_V1.ps1

Stop:
powershell -ExecutionPolicy Bypass -File C:\CleanSeedsBuild\CleanSeedLivePullBridgeV1\STOP_LIVE_PULL_BRIDGE_V1.ps1

Test:
powershell -ExecutionPolicy Bypass -File C:\CleanSeedsBuild\CleanSeedLivePullBridgeV1\TEST_LIVE_PULL_BRIDGE_V1.ps1

Boundaries:
Read-only bridge behavior.
No public URL.
No Cloudflare.
No ngrok.
No OpenAI API.
No MCP.
No broad Desktop scan.
No Downloads scan.
No project source edits.
No ACTIVE_GUIDES edit.
No CURRENT_TRUTH_INDEX edit.
No scanned-folder scripts run.
No shortcuts executed.
No archives extracted.

Delta rule:
Delta is evidence, not truth. Detection is not promotion.
