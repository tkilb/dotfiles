You are helping me extract and file information from a meeting transcript into my PARA notes vault (~/Notes/work).

Read the transcript at: {{transcript}}

Infer the meeting name, date, and attendees from the file if present; ask me if critical info is missing.

---

## PARA Structure (vault root: ~/Notes/work)

- `1.Daily/`      — daily notes; meeting entries should be terse bullets only
- `2.Projects/`   — active work with a defined outcome and finish line
- `3.Areas/`      — ongoing responsibilities (no end date)
- `4.Resources/`  — reference material, tools, links, facts — no action required
- `0.Inbox/`      — source of the transcript; do not re-file here

---

## Pass 1 — Daily Note Entry

Extract a terse meeting entry suitable for inserting into my daily note.

Format it exactly as:

```
### <Meeting Name>

#### Notes

- <one-line bullets only — no prose>

#### Takeaways

- <decisions or conclusions worth remembering>

#### Action Items

- <owner: task>
```

Rules:
- Bullets only. No summaries, no paragraphs.
- Strip all filler — keep only facts, decisions, and actions.
- If a detail isn't directly useful to me later, omit it.

Show me the proposed daily note block and ask me to confirm before proceeding.

---

## Pass 2 — Project (`2.Projects/`)

Determine if this meeting relates to an active or new project.

1. Check `2.Projects/` for an existing folder that matches.
   - If one exists → suggest what to add or update (e.g. a new meeting note file or appending to an existing one).
   - If none exists → ask me whether to create a new project folder before suggesting anything.
2. If a new folder is warranted, suggest the folder name and a starter file (use the meeting content as the basis).
3. Never create or move anything without my explicit confirmation.

Show your suggestion and ask me to confirm before proceeding.

---

## Pass 3 — Area (`3.Areas/`)

Identify any ongoing responsibilities, decisions, or domain knowledge surfaced in the transcript.

1. Suggest the right `3.Areas/` subfolder.
2. Propose new subfolders only when nothing existing fits — ask me first.
3. Show the exact content to add and the target file path.

Ask me to confirm before proceeding.

---

## Pass 4 — Resources (`4.Resources/`)

Extract reference material: tools, APIs, systems, concepts, links, vendor names, technical facts — anything I might want to look up later with no action required.

Pay special attention to:
- How internal systems behave (e.g. rules, constraints, data models mentioned in passing by engineers)
- Business rules stated as current fact (e.g. "once opted out, they're gone regardless of comp code")
- Distinctions between external/third-party systems and internal Carfax systems — file them separately

1. Suggest the right `4.Resources/` subfolder.
2. If nothing fits, propose a new one — ask me first.
3. Present the facts as terse bullets ready to paste into a resource note.

Ask me to confirm before proceeding.

---

## General Rules

- Walk through each pass one at a time; wait for my confirmation before moving to the next.
- Never move, create, or modify a file without my explicit go-ahead.
- Ask about anything ambiguous — do not assume.
- Keep all output concise.
