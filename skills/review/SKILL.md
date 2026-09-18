---
name: review
description: 'Use only when the user explicitly asks to review a pull request: "review this PR", "code review", "review" plus a PR link or PR number, or the same in another language.'
---

# Review code

Every finding MUST be usable by someone outside this repository. Jargon,
internals and "consider refactoring" MUST NOT appear.

## What language to write in

Two languages, kept apart:

- **Report language**: the four parts of the report, the text only the user
  reads. It MUST come from `LANGUAGE.md` next to this file. No file, or it names
  nothing? English.
- **English**: every comment meant for the PR MUST be in English. The whole team
  reads a PR.

This overrides `writing-style`'s "answer in the language the user wrote in" for
the report. A one-line ask like "review PR 42" carries no language choice of
its own, so `LANGUAGE.md` still wins. Only an explicit ask in this conversation,
such as "write it in English" or "in Russian please", changes it, and it wins
silently, no comment about it.

The examples here are English. Their shape MUST be copied, with your own words
in the report language. The headings go over too: **Who hits it**, **Now**,
**Comes out**, **Costs**, and the findings table headings.

## How to write every line

You MUST load the `writing-style` skill before the first line, from
`writing-style/SKILL.md` in this skills folder, once per review. It carries
every rule about words and layout, and the checklist to run before sending.

Two rules are the review's own, on top of it:

- The first line of a finding MUST give the whole point, so reading can stop
  there.
- Each finding is read alone, on its own line in GitHub, so it MUST NOT rest on
  a finding above it.

## 1. Find what to review

You MUST NOT ask when the target is obvious. Pick in this order:

1. The user named a file, a PR number or a branch. Use that.
2. Uncommitted changes: `git status --short`, then `git diff` and
   `git diff --staged`.
3. Otherwise the branch: `git diff "$base"...HEAD`.

`$base` is the branch this one came off. The remote is `origin` almost
everywhere, and on a fork or a mirror it is not, so read its name:

```sh
remote=$(git remote | grep -qx origin && echo origin || git remote | head -1)
base=$remote/$(GH_PAGER=cat gh repo view --json defaultBranchRef \
  -q .defaultBranchRef.name)
```

For a PR: `GH_PAGER=cat gh pr diff <number>`. You MAY ask the user only when
none of that finds anything.

Target is a branch or a PR? You MUST read
[references/getting-the-code.md](references/getting-the-code.md) now, for the
worktree steps, the user's own checkout and when running the code is allowed.
Uncommitted changes in the open repo need none of it.

## 2. Read the repo rules first

You MUST read `CONTRIBUTING.md`, `REVIEW.md`, `AGENTS.md`, `CLAUDE.md`,
`.github/copilot-instructions.md`, and any skill or doc they point to. Repo
rules beat your habits. What the repo requires MUST NOT be flagged. Where a
common convention clashes with a repo rule, the rule wins, and one line says
they clash.

## 3. Trace the flow, map it as you go

For each suspicious line, answer: what does a person do in the product to make
this line run? The diff and the files already open answer it most of the time,
and one step up to the caller answers the rest. Still unclear after that step?
Say so in the finding and move on. A path MUST NOT be invented, and chasing
callers across the repo waits for step 5.

Build the map while you read: which changed file calls which, what each is for,
which one carries the idea. That is part 2 of the answer.

## 4. What to look for

In this order of importance:

1. **Breaks for the user**: wrong result, crash, data loss, lost input, stuck
   spinner, a forgotten case (empty list, no network, slow reply, two clicks in
   a row).
2. **Security**: anything from the OWASP Top 10. Unescaped user input, secrets
   in code or logs, a missing permission check, an open redirect, a query built
   by string concatenation.
3. **Money and speed**: work repeated in a loop, a request per item, a file read
   on every render, an unbounded list held in memory.
4. **Will bite later**: a silent `catch`, a `TODO` that hides a known bug, two
   sources of truth for the same value, a test that cannot fail.
5. **Wrong shape for the job**, does the design fit the task at all.
6. **Already written somewhere**, does the repo or a dependency do this today.
7. **Style**. It MUST NOT be flagged unless the repo asks for it in writing.

You MUST read [references/deeper-checks.md](references/deeper-checks.md) at this
step for 5 and 6. They run on every review.

A file that is fine MUST be named as fine. Silence reads as "not reviewed". It
goes in the one "Clean:" line under the findings table.

Each finding SHOULD be worked out from the diff and the files around it, no
further. A finding you can't pin down stays in, marked for what it is. Step 5 is
where the digging happens, on the ones the user picks.

## Output format

Four parts MUST come in this order: the summary, the map, the findings table,
the findings. Then the one offer from step 5. Nothing else, no closing summary.

All four MUST go in the report language, whatever language the user or the code
used. Every comment block inside part 4 goes in English.

The review is built to be scanned. "Shape on the page" in `writing-style`
governs every part: the point in bold at the front of a bullet, a list wherever
three things line up, no paragraph over three lines, no recap. A reader who sees
only the bold text MUST come away knowing what is broken.

The fixed labels are the review's own exception. **Before**, **Now**, **Where**
in part 1 and the four labels of a finding MUST be headings, one level under the
heading they sit in, with their text on the lines below. A label glued to the
front of a sentence reads as part of it.

### Part 1: what this change is about (report language)

It MUST read for someone who has not heard of this product or this code. Three
`###` headings, one or two sentences under each:

- **Before**, what was wrong or missing, as a person would notice it.
- **Now**, what happens instead.
- **Where**, the place in the product it shows up.

File names, type names and function names MUST stay out. Cannot tell what
problem the change solves? Say that first and ask. Guessing here poisons the
rest.

```markdown
## What this change is about

### Before

The Save button on the profile page wiped the name field before the server had
agreed to store the new name. A failed save lost the typed name, with nothing on
screen explaining why.

### Now

The text stays until the server confirms, and comes back if the save failed.

### Where

Settings, the Profile tab, the Save button.
```

### Part 2: the map and the reading order (report language)

How the changed files hang together, and in which order to open them. GitHub
shows them alphabetically, so this part saves the reader that. Three pieces MUST
be there:

1. **One bullet per file**, the name in bold, then one plain sentence on what it
   is for. Files that belong together share one bullet and are named as a group.
   No prose here.
2. **A plain text tree** in a fenced block marked `text`. Mermaid MUST NOT be
   used: chat windows render it as an empty box. Start from the file that pulls
   the others in, branch with `├──` and `└──`, and add a short note after a file
   name when what travels along that edge is the point. Mark the files the PR
   adds and the ones nothing calls yet. Hold the changed files plus the existing
   ones they touch, nothing more, under about twelve lines. Below three files,
   skip the tree.
3. **The reading order**, numbered, one line each, saying why the file comes at
   that point. Start where the data starts or where the simplest piece is, end
   where it ties together. Tests and config last.

One file and a test? Write one line saying the map is not needed.

````markdown
## How the files hang together

- **`import-csv.ts`** reads the uploaded file and pulls the rows out of it. It
  leans on the two new helpers below.
- **`parse-row.ts`, `to-record.ts`** parse one row and turn it into a record.
- **`result.ts`** carries the outcome. This PR taught it to hold warnings.
- **Tests and build config** only pull the new files into the run.

```text
import-csv.ts (new)  the main file of the PR
├── parse-row.ts (new)        parses one row
├── to-record.ts (new)        turns it into a record
└── result.ts                 warnings were added here
    └── collect-results.ts (unchanged)   carries them to the output

importButton (next PR) ···> import-csv.ts   nothing calls it yet
```

Reading order:

1. `result.ts`, to see what a warning is. It turns up everywhere after that.
2. `to-record.ts` and `parse-row.ts`, small and self contained, read them with
   their tests.
3. `import-csv.ts`, the main file of the PR, the rest exists for it.
4. `collect-results.ts`, unchanged, but this is where you see whether the
   warnings reach the output.
5. The test and lint config, last, they only wire the new files in.
````

### Part 3: the findings table (report language)

One row per finding. The table MUST sit above the findings, so the verdict fits
on one screen, even when there is a single finding.

- **#** matches the finding below.
- **Severity** is the word used in the heading.
- **Where** is the file and line in backticks, file name only, no path.
- **What** is the symptom in under about 10 words, lowercase, no full stop.

Under the table, one line names the changed files with nothing to flag. Row
counts and file counts MUST stay out: the table shows them.

Nothing to flag anywhere? The table goes, and one line replaces it: what the
change does well, and that it is good to go.

```markdown
## Findings

| #   | Severity   | Where             | What                                                  |
| --- | ---------- | ----------------- | ----------------------------------------------------- |
| 1   | Blocker    | `SaveName.tsx:42` | the typed name is lost when the save is slow          |
| 2   | Should fix | `profile.ts:88`   | the save error is swallowed, so the page stays silent |
| 3   | Nit        | `SaveName.tsx:20` | nothing reads the `isLoading` flag                    |

Clean: `result.ts`, `collect-results.ts`, the test config.
```

### Part 4: the findings (report language)

They follow under that table, in the same `## Findings` section, one `###`
heading each. Sort by severity and number them, and the numbers MUST match the
table. Three levels: blocker, should fix, nit, written in the report language.

The size of the fix says nothing about the severity, and a nit tells the author
to ignore it. So:

- **Nit**: the code behaves the same either way and nothing rots in a year.
  Formatting, a name, a shorter way to write the same expression.
- **Should fix**: anything that can silently drift or mislead later, even when
  the fix is one line. Duplication, code nothing calls, a path with no test, a
  comment that says what the code does not do, a swallowed error, a value
  hardcoded twice, a third party's token where the project has its own.
- Torn between two levels? The higher one MUST win, and the repo's own scale
  beats both when it has one.

The reader knows nothing about this code and will not go looking. The example,
the numbers and the fix all MUST sit in the finding.

#### Carry one real case through the whole finding

A finding about the code in general reads as fog. One real case out of the repo,
rather than an invented `Foo`, MUST run from "Who hits it" to the fix:

- Say what the thing is before naming it: "`parseRow` reads one row of the
  uploaded file." One explanation, then the name alone.
- Show the value going in and the value coming out, quoted.
- Say what the result tells the reader, and what it leaves out, in the reader's
  own words: "the page says 40 rows imported, and says nowhere that two came
  out shifted."
- Close it with how you know, in brackets: `(read the diff)` on the first pass,
  `(walked the code with that input)` or `(ran it)` after step 5.
- Then how often it happens, once step 5 has counted it.

```markdown
#### Who hits it

`parseRow` reads one row of the uploaded file. This file has a row with a comma
inside quotes: `12,"Smith, John",ok`.

#### Comes out

`{ id: "12", name: "\"Smith", status: " John\"" }`. The name is cut in two and
the status swallowed the second half. The page says 40 rows imported, and says
nowhere that two of them are broken. (read the diff)
```

#### The shape of a finding

Someone in a hurry reads it on a line in GitHub. Four `####` blocks MUST sit
between the opening line and the fix, about 25 lines in total including the
code. Anything that does not fit gets cut.

A nit MUST skip this shape: the heading, the link, and one line saying what and
where, fix inline if it's short. No four blocks, no separate fix block.

````markdown
### 1. Blocker: the typed name is lost when the server is slow

[src/features/profile/SaveName.tsx:42](src/features/profile/SaveName.tsx#L42) · [in the PR](https://github.com/acme/shop/pull/7/files#diff-2f0b8aR42)

**The name field clears before the server answers, so a failed save loses what
the person typed. Clear it after the answer.**

#### Who hits it

A person opens Settings, types a new name and presses Save. Nothing else reaches
this code.

#### Now

Line 42 empties the field, then waits for the server:
`setName(""); await saveName(name);`

#### Comes out

The server answers two seconds later, or fails. The field is already empty, so
the typed name is neither on screen nor on the server, and no message appears.
(read the diff)

#### Costs

The person thinks it saved, leaves the page and loses the data. On a slow
network this is every second try.

Fix, clear the field after the confirmation and leave the text alone on error:

```tsx
const saved = await saveName(name);
if (saved.ok) setName("");
```

**Comment on** [src/features/profile/SaveName.tsx:42](src/features/profile/SaveName.tsx#L42) · [in the PR](https://github.com/acme/shop/pull/7/files#diff-2f0b8aR42),
line 42, added in this PR, the green side of the diff.

```markdown
this clears the input before saveName comes back - if the save fails the typed
name is gone. can we clear it after the call resolves ok?
```

Shorter:

```markdown
clears the input before saveName comes back, so a failed save loses the name.
clear it after it resolves ok?
```
````

Part by part:

- **Heading**: severity, then the symptom a person could see, not the cause or
  the file name.
- **Link**: it MUST sit right under the heading, both halves, every time:

  ```markdown
  [path/to/file.ts:42](path/to/file.ts#L42) · [in the PR](https://github.com/OWNER/REPO/pull/7/files#diff-HASHR42)
  ```

  The visible text MUST end in `:42`, so the line shows without hovering.
  Writing `[path/to/file.ts](path/to/file.ts#L42)` puts the number in the
  target, where the reader doesn't see it, that's the mistake to avoid. Path is
  workspace relative, no backticks. The second half MUST be built the way
  [references/pr-links.md](references/pr-links.md) says, on every finding when
  the target is a PR.

- **The opening line**, bold, under the link: what breaks, then what to do.
  Someone who reads only this line MUST know what is wrong.
- **Who hits it**: the steps in the product, in order, from something a person
  sees. Reachable only from a test? Say so.
- **Now**: what the code does, one sentence, with the line in backticks. Over
  three lines of code, it moves to its own fenced block.
- **Comes out**: the actual value, quoted, not a summary, then the evidence
  marker in brackets. A finding without a concrete outcome and a marker MUST
  NOT be sent.
- **Costs**: what the person or the business loses, and how often. No count
  until step 5 has grepped one? Say what it turns on instead.
- **Fix**: one line of words, then the code, up to roughly ten lines. Unsure?
  Give the idea and name what needs checking.
- **Comment on**: the line above the comment block, same two-link shape, and
  whether the line is in the diff.
- **Comment for the PR**: it MUST be there on every finding, nits included. Two
  blocks, the second under a bare `Shorter:` line, saying the same thing with
  the explaining cut out. The user picks one.

Those headings MUST come in that order with nothing added. A fifth one means two
findings.

### The two halves of a line link

Reviewing a GitHub PR, or landing a comment on a line the diff does not touch?
You MUST read [references/pr-links.md](references/pr-links.md) before the first
link: how the `· [in the PR](…)` half is built, and the rules for a line GitHub
refuses a comment on.

### Writing the per-finding comment

You MUST read [references/comment-style.md](references/comment-style.md) before
the first comment block, and keep it in context until the last one is done. One
sentence of doubt and one ask, under 40 words, then the same thing halved as a
second block. No headings, no fenced code.

## 5. Offer the deep dive

Parts 1 to 4 are the first pass, read off the diff. Digging into all of it costs
more than most of it is worth, so let the user spend that time where they want
it. The answer MUST close with the offer, in the report language, one choice per
finding plus an "all of them" choice. Each choice MUST carry the same number and
the same short text as the findings table, so the user picks without scrolling
back.

You MUST read [references/pick-lists.md](references/pick-lists.md) before
writing the offer: how to put the choices on screen, and why a markdown checkbox
MUST NOT be used.

Over five findings? Give a choice to the blockers and the "should fix" ones, and
one choice for all the nits together.

The user picks? Then, for each finding named:

- Trace the callers up to a button, a page load, a job, an API request or a CLI
  command, and name the entry point.
- Pick the exact input that triggers it, read the code with that input in hand,
  and quote what comes out.
- The verdict still hangs on an answer reading can't give? Run the smallest
  piece that settles it, the way
  [references/getting-the-code.md](references/getting-the-code.md) says.
- Grep how often it happens in this repo today: a number, not a guess.
- It turns out it can't happen? Say the finding is dropped, and why.

Then reissue that finding whole, in the shape part 4 gives it, with its table
row and its comment block. Same four headings, same order. What changes is what
they say: the evidence marker, the real value, the count, and the severity when
the answer moved it. A deep dived finding and a first pass one MUST look the
same on the page.

## 6. Before you send

You MUST read
[references/final-checklist.md](references/final-checklist.md) and run it over
the whole answer. Nothing goes out before that.
