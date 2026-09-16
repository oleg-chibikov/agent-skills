---
name: create-pr
description: 'Use when the user asks to open, create, raise or update a pull request, write a PR description, or fill in a PR body, in any repository. Produces a short PR description with three sections (problem, solution, packages picked or rejected) in plain language anyone can follow, then creates or updates the PR with gh.'
---

# Create a pull request

Two modes. Pick by what the user asked for.

- **Describe only**: write the title and body, show them, stop.
- **Create/update**: write them, then run `gh` to open the PR or edit an
  existing one.

If the user just says "make a PR", use create mode.

## 1. Collect the facts

Never guess what the change does. Read it.

```bash
git rev-parse --abbrev-ref HEAD                  # current branch
git log --oneline origin/HEAD..HEAD              # commits on this branch
git diff --stat origin/HEAD...HEAD               # files touched
git diff origin/HEAD...HEAD                      # the actual change
GH_PAGER=cat gh pr view --json number,title,body # PR already open?
```

If `origin/HEAD` is not set, find the base branch with
`GH_PAGER=cat gh repo view --json defaultBranchRef -q .defaultBranchRef.name`.

Also check:

- A PR template: `.github/pull_request_template.md` or files under
  `.github/PULL_REQUEST_TEMPLATE/`.
- The repo's commit and PR rules: `CONTRIBUTING.md`, `AGENTS.md`, `CLAUDE.md`.
- An issue id in the branch name or commits (`PROJ-123`, `JIRA-123`, `#42`).

Repo rules win over this skill. If the repo has a template, keep its required
parts (checkboxes, headings it demands) and put the three sections below inside
it.

## 2. Title

Follow the repo's commit convention. Common ones:

- `PROJ-123: add page pattern examples` (issue id prefix)
- `feat(auth): add page pattern examples` (conventional commits)

No convention in the repo? Use one short sentence in the imperative: what the
change does, not how.

## 3. Body

Exactly these three sections, in this order. Keep the whole body under about 25
lines.

```markdown
## What problem this solves

<Who was hurting and how. One to three sentences. Name the symptom a person
could see, not the internals.>

## How it works now

<What the change does, in order. Two to five bullets. Say the behaviour, then
the file only if it helps.>

## Packages

<Every dependency this change adds, one line each: the name, what it does for
us, its size. Then the ones you looked at and turned down, one line each, with
the reason. Nothing added? Write "No new packages." and, if a well known
package would have fit, say why you wrote it by hand instead.>
```

### What belongs in Packages

Only third party code the change now depends on, or would have: npm packages,
and a new peer or dev dependency counts too.

Leave out the repo's own tooling. Nobody needs to read that the tests run on
Vitest, that Nx builds the project, or that the linter passes. Same for MCP
servers, editors and agents: how the code got written is not part of the
change.

Check the real diff for this section: `git diff origin/HEAD...HEAD -- '**/package.json' 'package.json'`.
Do not claim a package was added when the manifest says otherwise.

For a turned-down package, give the reason in a few words: size, it is
unmaintained, its licence, it drags in a lot, the repo already has something
that does the job, or the hand-written version is ten lines.

Examples:

- "`date-fns` 3.6, 2 kB after tree shaking, formats the due dates."
- "Turned down `moment`: 70 kB and no tree shaking."
- "No new packages. `lodash.groupby` would have done it, but `Object.groupBy`
  ships in every browser we support."

## 4. How to write it

Anyone should get it on the first read, even with zero context on this codebase.

- Shortest wording that stays clear. One idea per sentence.
- Plain everyday words. Explain a term the first time it shows up.
- Say what a thing does before naming what it is called.
- Be concrete: the number, the file, the command, what a user sees.
- No em dash and no double hyphen. Use a comma, a period, or two sentences.
- Say it straight, in the positive. Never "it's not X, it's Y".
- No AI filler: "Great question", "Let's dive in", "In conclusion", emoji,
  rule-of-three lists for their own sake.
- Mark a guess as a guess.

Before you post, reread the body once and cut every word the reader can do
without.

Full rules, if the file exists: `~/.agents/writing-style.instructions.md`.

## 5. Create or update the PR

Always prefix `gh` with `GH_PAGER=cat`, otherwise it opens a pager and hangs.

Push first if the branch has no upstream:

```bash
git push -u origin HEAD
```

New PR:

```bash
GH_PAGER=cat gh pr create --base <base> --title "<title>" --body-file <file>
```

Write the body to a temp file rather than passing it inline, so newlines and
backticks survive.

Existing PR:

```bash
GH_PAGER=cat gh pr edit --title "<title>" --body-file <file>
```

Add `--draft` only if the user asked for a draft.

After a rebase or force push, `gh pr view --json mergeable` can report a stale
conflict. Any edit resets it, so re-query once if the answer looks wrong.

## 6. Report back

One or two lines: the PR link and the title. Nothing else.

## Guardrails

- Do not push or open a PR on a protected or default branch. Stop and say so.
- Do not invent a problem statement. If the diff does not tell you why the
  change exists, ask the user one question.
- Do not force push, amend published commits, or use `--no-verify`.
- Leave unrelated staged or untracked files alone.

## Example body

```markdown
## What problem this solves

Uploading a photo over 5 MB failed with a blank screen. People retried the same
file several times and then gave up, so support got about 30 tickets a week.

## How it works now

- Files up to 25 MB upload. The old cap was 5 MB.
- Anything larger shows the size limit and the file's own size, so the person
  knows what to do next.
- The upload button stays disabled while a file is in flight, which stops the
  double submits behind half the tickets.

## Packages

- `browser-image-compression` 2.0, 12 kB, shrinks a photo in the browser
  before it goes up.
- Turned down `sharp`: it only runs on the server, and the point here is to
  cut the upload before it starts.
- Turned down `filesize`: printing "25 MB" is three lines of our own code.
```
