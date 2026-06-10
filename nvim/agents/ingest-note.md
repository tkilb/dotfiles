You are helping me file a single note into my PARA notes vault (~/Notes/work).

The note at {{note}} is **authoritative** — treat its content as more accurate and up-to-date than anything already in the vault. When existing files conflict with this note, recommend updating them.

Read the note in full, then generate a single decision form at:

```
~/Notes/work/0.Inbox/.forms/ingest-note-decisions.md
```

---

## PARA Structure (vault root: ~/Notes/work)

- `2.Projects/`   — active work with a defined outcome and finish line
- `3.Areas/`      — ongoing responsibilities (no end date)
- `4.Resources/`  — reference material, tools, links, facts — no action required
- `5.Archive/`    — inactive items; mirror PARA inside
- `0.Inbox/`      — source of the note; do not re-file here

---

## Form structure

### Section 1 — Summary

Write a one-paragraph plain-English summary of what this note is and what it contains. The user may correct it before saying done.

```markdown
## Summary

> Edit if needed.

<one paragraph describing the note's content, domain, and why it is authoritative>
```

---

### Section 2 — Conflicts / Updates

Scan the relevant PARA subfolders for files that cover the same topic. For each file that may be stale or contradicted by this note, surface it here.

```markdown
## Conflicts / Updates

**`<existing file path>`** — <one-line description of the conflict or overlap>
- [ ] Overwrite with content from this note
- [ ] Merge: append new content from this note
- [ ] Add a "superseded" notice to the existing file and file new content separately
- [ ] Skip — no real conflict
- [ ] Discuss with agent
```

If no conflicts are found, write: `_No conflicts detected._`

---

### Section 3 — Project Filing

```markdown
## Project Filing

**<project match or proposed name>** — <existing / new>
- [ ] Add note to `2.Projects/<folder>/<date>-<slug>.md` (new file)
- [ ] Append to `2.Projects/<folder>/<existing file>`
- [ ] Create new project folder `2.Projects/<folder>/` with starter file
- [ ] Skip — no project relevance
- [ ] Discuss with agent
```

---

### Section 4 — Areas Filing

One entry per distinct area topic in the note.

```markdown
## Areas Filing

**<topic>** — <brief description>
- [ ] File to `3.Areas/<subfolder>/`
- [ ] File to `3.Areas/<alt subfolder>/`
- [ ] Skip
- [ ] Discuss with agent
```

---

### Section 5 — Resources Filing

Extract reference material: tools, APIs, systems, concepts, links, business rules, technical facts — anything worth looking up later with no action required.

Pay special attention to:
- How internal systems behave (rules, constraints, data models)
- Business rules stated as current fact
- Distinctions between external/third-party systems and internal systems — file them separately

```markdown
## Resources Filing

**<fact or resource title>** — <one-line description>
Proposed content:
- <bullet>
- <bullet>

- [ ] Add to `4.Resources/<subfolder>/`
- [ ] Add to `4.Resources/<alt subfolder>/` (new)
- [ ] Skip
- [ ] Discuss with agent
```

Rules:
- Never propose `4.Resources/misc/` — always find or propose a specific, meaningful subfolder.
- Group closely related facts into one entry rather than filing them separately.

---

## Form rules

- Pre-check `[x]` the option you recommend as a default
- Because this note is authoritative, prefer **update/overwrite** over **skip** when conflicts exist
- Do not ask clarifying questions during form generation — make a recommendation and let the form be the conversation
- Never move, create, or modify a file without a checked box in the form authorizing it

Tell me the form path, then wait. When I say I'm done, read the form and:
1. Address any items marked `Discuss with agent` conversationally first
2. Execute everything else in one shot
Finish with a summary table of all actions taken.
