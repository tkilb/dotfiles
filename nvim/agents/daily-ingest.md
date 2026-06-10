You are helping me organize my notes vault using the PARA method.
Work through **two passes** sequentially — old daily notes first, then the inbox.

## PARA Structure (vault root: ~/Notes/work)
- `2.Projects/`  — active work with a defined outcome and finish line
- `3.Areas/`     — ongoing responsibilities (no end date)
- `4.Resources/` — reference material, no action required
- `5.Archive/`   — inactive items; mirror PARA inside (e.g. 5.Archive/1.Daily/)
- `0.Inbox/`     — unprocessed captures, should always be emptied

## Current Kanban Board
{{kanban}}

---

## Pass 1 — Old Daily Notes (> {{stale_days}} days)
{{old_daily_notes}}

Read **all** old daily notes upfront. Then generate a single decision form at:

```
~/Notes/work/0.Inbox/.forms/daily-ingest-decisions.md
```

### Form format — one section per daily note:

```markdown
## YYYY-MM-DD

### Todos
**"<todo text>"** — <already on Kanban / not on Kanban>
- [ ] Add to Kanban Active
- [ ] Add to Kanban Backlog
- [ ] Skip
- [ ] Discuss with agent

### Resources
**<resource description>** (<brief context>)
- [ ] Add to `4.Resources/<subfolder>/`
- [ ] Skip
- [ ] Discuss with agent

### Learnings / Decisions
**<learning or decision>** (<brief context>)
- [ ] File to `<suggested PARA path>`
- [ ] File to `<alternative path>`
- [ ] Skip
- [ ] Discuss with agent

### Archive
- [ ] Move `1.Daily/YYYY-MM-DD.md` → `5.Archive/1.Daily/`
```

Rules for form generation:
- Pre-check `[x]` the option you recommend as a default
- Include only items worth a decision — skip anything already on Kanban or clearly stale
- Suggest new subfolders when no existing one fits; note it as "(new)"
- Keep descriptions brief; one line of context max

Tell me the form path, then wait. When I say I'm done, read the form and:
1. Address any items marked `Discuss with agent` conversationally first
2. Execute everything else in one shot
Finish with a summary table of all actions taken.

---

## Pass 2 — Inbox
{{inbox_files}}

Read **all** inbox items upfront. Then generate a second decision form at:

```
~/Notes/work/0.Inbox/.forms/inbox-decisions.md
```

### Form format — one section per inbox file:

```markdown
## <filename>

<One sentence describing what this file is and its current state.>

- [ ] File to `<suggested PARA path>`
- [ ] Archive to `5.Archive/0.Inbox/`
- [ ] Delete
- [ ] Add as Kanban todo (Active)
- [ ] Add as Kanban todo (Backlog)
```

Rules:
- Pre-check `[x]` the option you recommend
- If a file is a raw transcript already processed elsewhere, recommend Delete
- If a file has multiple distinct items, break them out as sub-decisions

Tell me the form path, then wait. When I say I'm done, read the form and execute **everything in one shot**. Finish with a summary table of all actions taken.

---

## General Rules
- Never move or delete a file without a checked box in the form authorizing it.
- Propose new subfolders when no existing one fits.
- Do not ask clarifying questions during form generation — make a recommendation and let the form be the conversation.

