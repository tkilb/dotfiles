---
name: review-css
description: >-
  Activate when asked to audit or fix CSS, SCSS, or CSS-in-JS
  (styled-components/emotion) for design-system compliance. Use when the
  user wants px-only units (no rem/em), or wants hardcoded colors, fonts,
  font weights, line heights, shadows, or border radii replaced with design
  tokens (SCSS variables or CSS custom properties).
---

# Review CSS

## Overview

Audits CSS, SCSS, and CSS-in-JS (styled-components / emotion) for
design-system compliance. Enforces `px` as the only acceptable length unit
and requires design tokens (SCSS `$variables` or CSS custom properties,
i.e. `var(--token)`) for colors, fonts, font weights, line heights, box
shadows, and border radius — hardcoded values (hex/rgb/hsl colors, bare
font names, numeric weights, unitless/px line-heights, literal shadow
strings, literal radius values) are never acceptable for those properties.

## Scope

**This skill covers:**
- `.css` and `.scss` files
- CSS-in-JS template literals in `styled-components` and `emotion`
  (`styled.div\`...\``, `css\`...\``, `createGlobalStyle\`...\``, etc.)
- Enforcing `px` as the only length unit — `rem` and `em` are always
  flagged as violations, with a suggested `px` equivalent
- Requiring a design token (SCSS `$var` or `var(--custom-property)`) for:
  - `color`, `background`, `background-color`, `border-color`, and any
    other property taking a color value — hex (`#fff`), `rgb()`, `rgba()`,
    `hsl()`, and named colors are all violations
  - `font-family` — bare font stacks are violations
  - `font-weight` — bare numeric or keyword weights (`700`, `bold`) are
    violations
  - `line-height` — bare numeric/unit values are violations
  - `box-shadow` — literal shadow definitions are violations
  - `border-radius` — literal radius values are violations
- Searching the target repo for an existing token that already matches a
  flagged hardcoded value, before suggesting a new one be created

**This skill does NOT cover:**
- General CSS linting (property ordering, formatting, vendor prefixing)
  unrelated to units/tokens
- Accessibility/contrast auditing
- Layout, responsiveness, or specificity/cascade review
- Introducing new design tokens automatically — the skill flags and
  suggests, but token creation/naming decisions are confirmed with the
  user
- Any repo that has no notion of design tokens at all (flag this to the
  user rather than inventing a token system)

## Prerequisites

- Before scanning, **always** ask the user (do not assume) which scope to
  audit:
  1. **Local changes only** — diff of uncommitted/staged changes plus the
     current local branch vs. the **local** `main`/`master` branch (e.g.
     `git diff main...HEAD` and `git diff --stat`/`git diff`). Never fetch
     or diff against `origin/main` — this must stay offline/local only.
  2. **Whole codebase** — every matching file in the repo.
- Before flagging hardcoded values as violations, locate the repo's
  existing token source(s) so suggestions reference real tokens instead of
  inventing new ones. Look for (in rough priority order):
  - SCSS variable/partial files (e.g. `_variables.scss`, `_tokens.scss`,
    `styles/tokens/*.scss`)
  - `:root { --token-name: ...; }` blocks defining CSS custom properties
  - A theme/tokens JS/TS object consumed by `styled-components`/`emotion`
    (e.g. `theme.js`, `tokens.ts`)
  - If no token source is found, tell the user explicitly rather than
    guessing a convention.

## Examples

### Example 1: Local-changes scan

**Scenario:** User asks to "check my CSS changes for issues."

1. Confirm scope with the user: local diff vs. local `main` (not
   `origin/main`).
2. Get changed files: `git diff --name-only main...HEAD -- '*.css' '*.scss'`
   (plus any CSS-in-JS files touched, filtered via `git diff --name-only`
   against JS/TS extensions and checked for `styled-components`/`emotion`
   usage).
3. For each changed file, review only the changed hunks
   (`git diff main...HEAD -- <file>`) for:
   - Any `rem`/`em` unit → flag, suggest `px` equivalent (e.g. `1.5rem` →
     `24px` assuming a 16px base, but confirm the base with the user if
     unclear).
   - Any hex/rgb/hsl color → search token source for a matching value;
     report the matching token name if found, otherwise flag as
     "no matching token — needs one created."
   - Any hardcoded `font-family`, `font-weight`, `line-height`,
     `box-shadow`, `border-radius` → same token search/flag process.
4. Report findings as a table (file, line, issue, current value, fix).
5. Ask the user which flagged issues to fix; apply only confirmed fixes.

### Example 2: Whole-codebase scan

**Scenario:** User asks for a full CSS audit.

1. Confirm scope: whole codebase.
2. `rg` (or `fd`) for all `.css`/`.scss` files, plus JS/TS files containing
   `styled-components`/`emotion` usage.
3. Apply the same rule set as Example 1 across every match.
4. Because volume is likely high, group the report by violation type
   (units, colors, fonts, font-weights, line-heights, shadows, radii) with
   counts, then list details per file.
5. Ask the user whether to fix all, fix by category, or just report.

### Example 3: Violation report format

```
| File                  | Line | Property      | Value        | Issue                          | Suggested Fix           |
|-----------------------|------|---------------|--------------|---------------------------------|--------------------------|
| src/Button.scss       | 12   | font-size     | 1.25rem      | rem not allowed (px only)       | 20px                     |
| src/Button.scss       | 14   | color         | #2563eb      | hardcoded hex, no token match   | needs new $color-* token |
| src/Card.scss         | 8    | border-radius | 4px          | hardcoded, matches $radius-sm   | $radius-sm               |
| src/Modal.jsx (styled)| 22   | box-shadow    | 0 2px 4px #0002 | hardcoded, no token match    | needs new $shadow-* token|
```

### Example 4: CSS-in-JS detection

**Scenario:** A `styled-components` file has hardcoded values inside a
template literal.

```js
const Card = styled.div`
  border-radius: 8px;      /* flag: literal — check for matching $radius token */
  color: #333;             /* flag: hex color — no token accepted */
  line-height: 1.4rem;     /* flag: rem unit AND hardcoded line-height */
`;
```
Treat the template literal contents as CSS for rule purposes — same
detection and reporting rules as `.scss`/`.css` apply.

## References

- [../../AGENTS.md](../../AGENTS.md) — repo-wide agent conventions
  (linker/syncer patterns, `ai/` directory purpose)
- [../AGENTS.md](../AGENTS.md) — shared AI agent config conventions this
  skill's directory follows
