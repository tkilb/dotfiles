Please read the following files and prepare a two-way sync:

Kanban board: {{kanban}}

Recent daily notes:
{{daily_notes}}

Read **all** files upfront. Then generate a single decision form at:

```
~/Notes/work/0.Inbox/.forms/kanban-update-decisions.md
```

## What to surface in the form

### 1. Daily → Kanban (status updates)
Identify tasks mentioned as done or progressed in the daily notes that are still open on the board.

```markdown
### Status Updates

**"<task title>"** — currently `<status>` on Kanban
- [ ] Mark as Done
- [ ] Mark as In Progress
- [ ] Move to Paused
- [ ] Skip
- [ ] Discuss with agent
```

### 2. New todos (Daily → Kanban)
Scan every "Follow Ups", "Follow Up", "Todos", and "Action Items" section in the daily notes. Surface any item not already on the Kanban board.

```markdown
### New Todos

**"<todo text>"** — from `<daily note date>`
- [ ] Add to Active
- [ ] Add to Backlog
- [ ] Skip
- [ ] Discuss with agent
```

### 3. Stale / nudge items (Kanban → Daily)
Flag open items that haven't appeared in recent daily notes. Each open item has an `(added: YYYY-MM-DD)` stamp.
- Older than {{nudge_days}} days → 🟡 nudge
- Older than {{stale_days}} days → 🔴 stale

```markdown
### Stale Items

🔴 **"<task title>"** — added <date>, not seen in recent notes
- [ ] Keep open
- [ ] Move to Paused
- [ ] Mark as Done
- [ ] Remove
- [ ] Discuss with agent

🟡 **"<task title>"** — added <date>, not seen recently
- [ ] Keep open
- [ ] Move to Paused
- [ ] Remove
- [ ] Discuss with agent
```

## Form rules
- Pre-check `[x]` the option you recommend as a default
- Do not ask clarifying questions during form generation — make a recommendation and let the form be the conversation
- Include only items that need a decision; skip anything obviously current or already correct

Tell me the form path, then wait. When I say I'm done, read the form and:
1. Address any items marked `Discuss with agent` conversationally first
2. Apply all other changes in one shot
Finish with a summary table of every change made.
