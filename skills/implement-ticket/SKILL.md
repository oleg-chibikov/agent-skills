---
name: implement-ticket
description: 'Use when the user asks to do, implement, fix, pick up or work on a ticket, in any repository and in any language: "do PROJ-123", "implement this ticket", "pick up EX-42", "сделай тикет", a Jira link plus "do it". Reads the ticket, makes the smallest change that does what it asks in a new worktree off the latest main or master, in clean code split into modules, commits each step on its own with the ticket key per the repo rules, opens a PR through the create-pr skill, then moves the ticket to In Review.'
---

# Implement a ticket

Read the ticket, make the smallest change that does what it asks, ship it as a
PR, move the ticket to In Review.

## 1. Read the ticket

The key comes from the user's message or link: `PROJ-123`. No key? Ask for it.

Read it through the Jira tool the agent has, the Atlassian MCP server or
`acli`:

```bash
acli jira workitem view PROJ-123 --fields summary,description,status,comment
```

Read the summary, the description, the acceptance criteria and every comment.
A comment often changes the ask.

Open every link the ticket carries: a Figma frame, a doc, a thread. Keep the
URLs, the PR MUST link them.

- The ask MUST be clear before the first edit. Unclear? Ask the user one
  question and wait.
- A ticket that needs a redesign or spans several features SHOULD stop here.
  Propose a split and wait.

## 2. Read the repo rules

Repo rules MUST win over this skill. Read, when present:

- `AGENTS.md`, `CLAUDE.md`, `CONTRIBUTING.md`, `.github/copilot-instructions.md`.
- `git log --oneline -15` for the commit message shape and the ticket prefix.
- `git branch -r --sort=-committerdate | head -15` for the branch name shape.
- The check commands in `package.json`, a `Makefile` or the CI config.

## 3. Worktree

The work MUST happen in a new worktree off the latest default branch, `main` or
`master`. The user's checkout stays as it is, uncommitted files included.

The worktree MUST sit next to the main repo folder, named
`<repo>-<branch>`. The path comes from the main repo, so a start in a
subfolder or in another worktree lands in the same place.

Every `gh` MUST carry the `GH_PAGER=cat` prefix, or it opens a pager and hangs.

```bash
remote=$(git remote | grep -qx origin && echo origin || git remote | head -1)
default=$(GH_PAGER=cat gh repo view --json defaultBranchRef -q .defaultBranchRef.name)
git fetch "$remote" "$default"
main=$(dirname "$(git rev-parse --path-format=absolute --git-common-dir)")
dir="$(dirname "$main")/$(basename "$main")-<branch>"
git worktree add -b <branch> "$dir" "$remote/$default" && cd "$dir"
```

- The branch name MUST carry the ticket key in the shape the repo uses. No
  shape to copy? `proj-123-short-slug`.
- The branch or the folder already exists? Stop and ask, it may hold someone's
  work.
- Install the dependencies in the worktree with the repo's own command before
  the first check.
- Every command from here on MUST run inside the worktree.

## 4. Plan

Read the code the ticket touches before planning. Find the module that owns
the behaviour, its callers, its tests.

Write the plan in the chat, then start without asking:

1. One line on what changes for the person using it.
2. The files to touch, each with what changes in it.
3. The commits, in order, one line each.

## 5. Write the change

### Low blast radius

- The change MUST do what the ticket asks and nothing else. No renames, no
  reformatting, no fixes to nearby code.
- A public API, a shared config, a schema or a dependency MUST NOT change
  unless the ticket needs it. When it must, the plan names it.
- A new package SHOULD NOT go in. The repo or the language usually does the
  job already.
- Deleting SHOULD beat adding. Look for code the change lets you remove and a
  helper the repo already has.
- Something broken outside the ticket goes in the final report, untouched.

### Clean code, split into modules

- One module, one job. Code with a job of its own SHOULD get its own file
  rather than grow a file that does something else.
- New code MUST follow its neighbours: folder layout, naming, error handling,
  where tests sit.
- A function SHOULD do one thing, with a name that says what.
- Dead code, commented-out code and a `TODO` MUST NOT go in.
- A code comment follows the `writing-style` rules for code comments.

### Tests

A test SHOULD cover the behaviour the ticket changes, written the way the
repo's tests next to it are written. The repo has no tests for that area? Say
so in the report rather than build a test setup.

## 6. Commit

Commits SHOULD be separate, one per step a reviewer can read on its own:

- a new module with its tests,
- wiring it into the caller,
- removing the code it replaces.

Each commit SHOULD leave the repo building and its checks passing. Two steps
that only build together go in one commit.

- The message MUST follow the repo convention and carry the ticket key the way
  the log does. No convention? `PROJ-123: <imperative line>`.
- Stage only the files of this step with `git add <files>`. `git add -A` and
  `git add .` MUST NOT be used.
- Hooks MUST run. `--no-verify` and `--amend` MUST NOT be used.

```text
PROJ-123: add the upload size check
PROJ-123: reject photos over 25 MB in the upload form
PROJ-123: drop the old 5 MB check
```

Load the `writing-style` skill before the first message, unless it is in
context.

## 7. Check

Run the repo's checks over the change before the PR: typecheck, lint, the
tests of the touched modules. A failing check MUST be fixed before the PR. The
fix goes in the commit of the step it belongs to only when nothing is pushed
yet, as a new commit otherwise.

A check that already fails on the default branch SHOULD go in the report and
stay as it is.

## 8. Open the PR

Load the `create-pr` skill and follow it in create mode. The ticket key is the
first line of the body, as that skill says.

## 9. Move the ticket to In Review

List the transitions the ticket offers now through the Atlassian MCP server.
With `acli`, pass the target status by name:

```bash
acli jira workitem transition --key PROJ-123 --status "In Review"
```

The target is the review status of that project: "In Review", "Code Review",
"Code complete" or close to it. Pick it by name from the list.

- Not offered from the current status? Move to "In Progress" first, then try
  again.
- Still not offered? Stop, report the current status and the transitions the
  ticket offers.
- No other field on the ticket SHOULD change.

## 10. Report back

1. The PR link and title.
2. The ticket key and its new status.
3. The worktree path.
4. The commits, one line each.
5. Anything noticed and left alone, one line each.

## Guardrails

- A force push, a rebase or an amend MUST NOT happen.
- A push to the default branch MUST NOT happen. Stop and say so.
- Files outside the change MUST be left alone, staged or not.
- The ticket MUST NOT move before the PR is open.
- The worktree MUST stay on disk. Removing it is the user's call.
