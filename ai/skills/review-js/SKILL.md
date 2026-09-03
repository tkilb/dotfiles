---
name: review-js
description: >-
  Activate when asked to audit or fix JavaScript/TypeScript (including
  JSX/TSX) code quality. Use when the user wants unused
  variables/imports/exports removed, console.log/debugger statements
  cleaned up, loose equality or var usage fixed, dead/unreachable code
  found, empty catch blocks or unhandled promises flagged, event
  listener/timer cleanup checked, magic numbers named, shadowed variables
  found, complex functions flagged, or React hook dependency arrays
  checked.
---

# Review JS

## Overview

Audits JavaScript/TypeScript (including JSX/TSX) for common code-quality
issues: dead code, unsafe patterns, and maintainability hazards. Reports
findings and lets the user choose which to fix.

## Scope

**This skill covers:**
- `.js`, `.jsx`, `.ts`, `.tsx` files
- **Unused imports/exports** — imported bindings never referenced in the
  file, and named exports never imported anywhere else in the repo
- **Unused local variables/parameters** — declared but never read
- **Leftover `console.log`/`debugger` statements** — debug artifacts that
  shouldn't ship
- **Loose equality** — `==`/`!=` instead of `===`/`!==` (except deliberate
  `== null` checks, which are idiomatic and should not be flagged)
- **`var` instead of `let`/`const`**
- **Unreachable code / dead commented-out code blocks** — code after
  `return`/`throw`/`break`/`continue` that can never execute, and large
  commented-out code blocks (not comments that are documentation)
- **Empty/swallowed catch blocks** — `catch (e) {}` or catch blocks that
  only do something like `catch (e) { console.log(e) }` without real
  handling or rethrow
- **Unhandled promises / missing await** — floating promises (a call
  returning a Promise with no `await`, `.then`, `.catch`, or explicit
  `void`/fire-and-forget comment), and `async` functions called without
  awaiting where the result or errors matter
- **Uncleaned event listeners/intervals/timeouts** — `addEventListener`,
  `setInterval`, `setTimeout` (long-lived), or subscriptions set up without
  a corresponding `removeEventListener`/`clearInterval`/`clearTimeout`/
  unsubscribe (especially inside React `useEffect`, class lifecycle
  methods, or module-level setup)
- **Magic numbers/strings** — repeated or non-obvious literal values that
  should be named constants (excludes obvious values like `0`, `1`, `-1`,
  array indices, and single-use trivial literals)
- **Shadowed variable names** — inner-scope declarations that reuse an
  outer-scope name, risking confusion or bugs
- **Overly long/complex functions** — high cyclomatic complexity, deep
  nesting (arbitrary but consistent threshold: flag functions >~50 lines
  or >~4 levels of nested conditionals/loops as candidates for splitting)
- **Duplicate/redundant imports** — multiple import statements from the
  same module path that could be merged
- **React hook dependency issues** — `useEffect`/`useMemo`/`useCallback`
  dependency arrays missing referenced values, or including unnecessary
  ones (only applies to files using React hooks)
- **Unstable references in dependency arrays** — before adding a value to
  a `useEffect`/`useMemo`/`useCallback` dependency array (e.g. to satisfy
  `react-hooks/exhaustive-deps`), check whether that value is actually a
  *stable* reference. Objects/functions returned fresh on every render
  (e.g. a custom hook that returns a new object literal like
  `{ set, remove, value }` without `useMemo`/`useCallback`, or an inline
  object/array/handler defined in the render body) will make the effect
  re-run every render if added directly to the deps array — silently
  defeating the "only run when X changes" intent, even though ESLint's
  `exhaustive-deps` rule considers it satisfied. When this happens: trace
  the value back to its source (check the hook/library implementation if
  possible) and prefer depending on a stable primitive derived from it
  (e.g. depend on `pageName`, not on `pageNameStorage`, if `pageNameStorage`
  is a fresh object each render), or wrap the source in `useMemo`/
  `useCallback` if you control it, rather than blindly satisfying the lint
  rule by adding the unstable reference.

**This skill does NOT cover:**
- Formatting/style (semicolons, quote style, indentation) — defer to
  Prettier/ESLint if configured
- CSS-in-JS design-token/unit issues — see the `review-css` skill for that
- Security vulnerabilities (e.g. XSS, injection) — not this skill's focus;
  flag obvious ones in passing but don't do a full audit
- Type-safety issues in TypeScript (e.g. `any` usage, missing types) unless
  incidentally spotted
- Introducing new tests or refactoring architecture

## Prerequisites

- Before scanning, **always** ask the user (do not assume) which scope to
  audit:
  1. **Local changes only** — diff of uncommitted/staged changes plus the
     current local branch vs. the **local** `main`/`master` branch (e.g.
     `git diff main...HEAD -- '*.js' '*.jsx' '*.ts' '*.tsx'`). Never fetch
     or diff against `origin/main` — this must stay offline/local only.
  2. **Whole codebase** — every matching file in the repo.
- If the repo has an existing ESLint config, check it first — some of
  these checks (`no-unused-vars`, `eqeqeq`, `no-console`,
  `react-hooks/exhaustive-deps`, etc.) may already be enforced there. Note
  which checks are already covered by linting vs. which need manual
  review, to avoid duplicate/conflicting noise.

## Examples

### Example 1: Local-changes scan

**Scenario:** User asks to "check my JS changes for issues."

1. Confirm scope with the user: local diff vs. local `main` (not
   `origin/main`).
2. Get changed files: `git diff --name-only main...HEAD -- '*.js' '*.jsx' '*.ts' '*.tsx'`.
3. Check if an ESLint config exists (`.eslintrc*`, `eslint.config.*`); if
   so, note which of the checks below it likely already covers.
4. For each changed file, review the changed hunks
   (`git diff main...HEAD -- <file>`) for each item in Scope above.
5. Report findings as a table (file, line, issue, snippet, suggested fix).
6. Ask the user which flagged issues to fix; apply only confirmed fixes.

### Example 2: Whole-codebase scan

**Scenario:** User asks for a full JS audit.

1. Confirm scope: whole codebase.
2. `rg`/`fd` for all `.js`/`.jsx`/`.ts`/`.tsx` files (respecting
   `.gitignore` — skip `node_modules`, build output, generated files).
3. Apply the same rule set as Example 1 across every match.
4. Because volume is likely high, group the report by category (unused
   code, equality, var usage, dead code, error handling, promises,
   cleanup/leaks, magic values, shadowing, complexity, duplicate imports,
   hook deps) with counts, then list details per file.
5. Ask the user whether to fix all, fix by category, or just report.

### Example 3: Violation report format

```
| File              | Line  | Category         | Issue                                   | Suggested Fix                          |
|--------------------|-------|------------------|-------------------------------------------|-----------------------------------------|
| src/utils.js       | 4     | unused_import    | `debounce` imported but never used        | remove import                          |
| src/api.js         | 22    | loose_equality   | `if (status == 200)`                      | use `===`                              |
| src/widget.jsx     | 58    | cleanup_leaks    | `addEventListener('resize', ...)` in useEffect with no cleanup | return cleanup fn that removes listener |
| src/parser.ts      | 101   | empty_catch      | `catch (e) {}` swallows parse errors      | log or rethrow                         |
| src/legacy.js      | 14    | var_keyword      | `var count = 0;`                          | use `let`/`const`                      |
```

### Example 4: Unhandled promise / missing await

```js
function saveUser(user) {
  api.save(user); // flag: floating promise — no await/.then/.catch, errors silently lost
}
```
Suggested fix: `await api.save(user)` (and mark the enclosing function
`async`), or explicit `.catch(handleError)` if fire-and-forget is
intentional — confirm intent with the user before "fixing" this, since
fire-and-forget may be deliberate.

### Example 5: React hook dependency issue

```jsx
useEffect(() => {
  fetchData(userId);
}, []); // flag: `userId` used inside but missing from dependency array
```

### Example 6: Unstable reference in dependency array

```jsx
const storage = useSessionStorage("pageName"); // hook returns a NEW
                                                 // { set, remove, value }
                                                 // object every render

useEffect(() => {
  storage.set(pageName);
}, [pageName, storage]); // flag: `storage` is a fresh reference each
                          // render, so this effect actually re-runs every
                          // render, not just when `pageName` changes —
                          // even though exhaustive-deps is satisfied
```
Suggested fix: depend on the stable primitive only, and document why the
unstable value is intentionally omitted:
```jsx
useEffect(() => {
  storage.set(pageName)
  // storage is a new object every render (hook doesn't memoize its
  // return value), so only pageName is a meaningful dependency here.
  // eslint-disable-next-line react-hooks/exhaustive-deps
}, [pageName])
```

## References

- [../../AGENTS.md](../../AGENTS.md) — repo-wide agent conventions
  (linker/syncer patterns, `ai/` directory purpose)
- [../AGENTS.md](../AGENTS.md) — shared AI agent config conventions this
  skill's directory follows
- [../review-css/SKILL.md](../review-css/SKILL.md) — sibling skill for
  CSS/SCSS design-token and unit compliance
