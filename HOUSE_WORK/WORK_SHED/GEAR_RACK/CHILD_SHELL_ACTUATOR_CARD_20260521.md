# Child Shell Actuator Card

Date: 2026-05-21
Lane: HOUSE_WORK / WORK_SHED / GEAR_RACK
Status: REUSABLE CARD / SUPPORT ONLY

## Fast card

Do not expose raw PowerShell.

Expose child actions only.

## Shape

CHAT REQUEST -> POLICY -> CHILD ACTION -> POWERSHELL FUNCTION -> RESPONSE -> RECEIPT

## Child action checklist

- named action;
- allowed root;
- no path traversal;
- no overwrite unless explicitly designed and previewed;
- no delete unless separately authorized and backed up;
- no arbitrary shell;
- no house write in V1;
- response hash;
- receipt hash;
- false-success guard.

## First proof

First live test at stamp 20260521_001704:

- front door pass: 273BA1AD09B28D23E8B49C34B29A06760F175E3A207AA5DC7D70D6392C00C547
- write/create pass response: 238A7438EA529AC55A9EB23DA74822694C98F0F74F5489BB39E09A1500A02714
- overwrite block response: B570E4F63A91771A97C3A9F25BC9EC8550CF0D1B8CA5D1F774F029FAB57C9B69
- raw shell block response: E5BEB96F2170E5F325D8BDEFD59FDCF133F50A5A9AC21930CA30BE26D66A6B0D
- created target SHA256: B5E05E44F6A256ABFE724C5985C67C92114A9F62416222CFE696B76533AD1F03

## Watch

Dependent request tests must use ordered request names or separate runs because the bridge processes request files by filename.
