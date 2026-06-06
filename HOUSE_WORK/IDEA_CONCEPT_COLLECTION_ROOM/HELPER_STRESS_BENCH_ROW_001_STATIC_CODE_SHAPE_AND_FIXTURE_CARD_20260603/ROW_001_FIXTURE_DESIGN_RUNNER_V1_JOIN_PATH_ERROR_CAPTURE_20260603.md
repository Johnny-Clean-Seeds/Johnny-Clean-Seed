# Row 001 Fixture Design Runner V1 Join-Path Error Capture

Date: 20260603
RunId: 20260603_223720

## Failure Class

POWERSHELL_JOIN_PATH_ARRAY_ARGUMENT_BINDING_ERROR

## Exact Error

Join-Path: _LOCAL_RUNNERS\ROW_001_STATIC_PACKET\WRITE_ROW_001_DISPOSABLE_FIXTURE_DESIGN_AND_RUNNER_INVENTORY_V1.ps1:79
Line |
  79 |    Join-Path $PacketDir "HELPER_STRESS_BENCH_ROW_001_STATIC_CODE_SHAPE …
     |    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     | Cannot convert 'System.Object[]' to the type 'System.String' required by parameter 'AdditionalChildPath'.
     | Specified method is not supported.

## Lower-Layer Cause

The V1 runner placed several Join-Path calls inside a PowerShell array without wrapping each call in parentheses.

PowerShell interpreted the comma-separated following values as extra child path arguments to the first Join-Path call, producing a System.Object[] binding error.

## Repair In This V1.1 Runner

Each Join-Path call inside $RequiredInputs is wrapped in parentheses before being placed in the array.

## Boundary

Target helper executed: false
Fixture executed: false
Git add/commit/push: false
Root cleanup: false
Runner cleanup: false
Pointer/state mutation: false