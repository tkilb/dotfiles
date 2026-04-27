Please read the following files and help me do a two-way sync:

Kanban board: {{kanban}}

Recent daily notes:
{{daily_notes}}

1. Daily → Kanban: identify tasks mentioned as done or progressed in the daily notes that are still open on the board. Suggest status updates.
2. Kanban → Daily: flag active or paused items that haven't appeared in recent daily notes — they may be stale.
3. Follow Ups: scan every "Follow Ups", "Follow Up", "Todos", and "Action Items" section in the daily notes. Any item not already on the Kanban board should be suggested for addition — do not skip these.
4. Age flags: each open item has an `(added: YYYY-MM-DD)` stamp. Flag items older than {{nudge_days}} days as 🟡 nudge and items older than {{stale_days}} days as 🔴 stale.
5. Ask me about anything unclear, then walk me through changes one at a time.
