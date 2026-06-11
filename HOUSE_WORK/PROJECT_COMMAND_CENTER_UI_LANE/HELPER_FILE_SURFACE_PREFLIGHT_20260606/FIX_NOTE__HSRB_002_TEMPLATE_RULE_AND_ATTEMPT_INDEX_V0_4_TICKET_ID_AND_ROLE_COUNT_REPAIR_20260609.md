# FIX NOTE - HSRB-002 V0.4 TicketID and Role Count Repair

V0.4 repairs TicketID custody and role-count verification together.
TicketID is recovered from selected batch, the 64-row queue, and a hard fallback from the reviewed root-held queue where necessary.
Role counts are derived from filename pattern and verified against expected HSRB-002 composition.

Physical actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0