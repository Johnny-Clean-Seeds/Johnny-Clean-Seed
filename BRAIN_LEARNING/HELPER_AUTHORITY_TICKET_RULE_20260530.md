# Helper Authority Ticket Rule

Status: SUPPORT RULE / ADDENDUM
Authority: not doctrine, not ACTIVE_GUIDES, not CURRENT_TRUTH_INDEX

## Rule

A helper packet must act like a bounded authority ticket. It must not only name a file or object; it must name the exact rights the helper has over that object.

A path is not permission.

## Ticket must state

- authority objects;
- allowed actions;
- blocked actions;
- write allowed yes/no;
- Git allowed yes/no;
- move/delete allowed yes/no;
- promotion allowed yes/no;
- expiration after stop;
- proof required.

## Blocked

- no broad authority from path visibility;
- no file edit because the helper can read it;
- no Git action unless packet explicitly grants Git authority;
- no promotion unless packet explicitly grants promotion authority.