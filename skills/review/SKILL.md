---
name: review
description: 'Use only when the user explicitly asks to review a pull request: "review this PR", "code review", "review" plus a PR link or PR number, or the same in another language.'
---

# Review code

MUST, MUST NOT, SHOULD, SHOULD NOT and MAY carry their RFC 2119 meaning. SHOULD
breaks only with a reason stated in the review.

Every finding MUST be usable by someone outside this repository. Leave out
jargon, internals and "consider refactoring".

## What language to write in

Two languages, kept apart:

- **Report language**: parts 1 to 4, the text only the user reads. Read
  `LANGUAGE.md` next to this file and use the language named there. No file, or
  it names nothing? English.
- **English**: part 5 and every comment meant for the PR. The whole team reads a
  PR.

This overrides `writing-style`'s "answer in the language the user wrote in" for
parts 1 to 4. A one-line ask like "review PR 42" carries no language choice of
its own, so `LANGUAGE.md` still wins. Only an explicit ask in this conversation,
such as "write it in English" or "in Russian please", changes it, and it wins
silently, no comment about it.

The examples here are English. Copy their shape, write your own words in the
report language. Translate the bold labels too: **Who hits it**, **Now**,
**Comes out**, **Costs**, and the findings table headings.

## How to write every line

Load the `writing-style` skill before the first line, from
`writing-style/SKILL.md` in this skills folder, once per review. It carries
every rule about words and layout, and the checklist to run before sending.

Two rules are the review's own, on top of it:

- The first line of a finding gives the whole point, so reading can stop there.
- Each finding is read alone, on its own line in GitHub. Nothing in it rests on
  a finding above it.

## 1. Find what to review

Don't ask when the target is obvious. Pick in this order:

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

Target is a branch or a PR? Read
[references/getting-the-code.md](references/getting-the-code.md) now, for the
worktree steps, the user's own checkout and when running the code is allowed.
Uncommitted changes in the open repo need none of it.

## 2. Read the repo rules first

Read `CONTRIBUTING.md`, `REVIEW.md`, `AGENTS.md`, `CLAUDE.md`,
`.github/copilot-instructions.md`, and any skill or doc they point to. Repo
rules beat your habits: don't flag what the repo requires, and where a common
convention clashes with a repo rule, follow the rule and say in one line that
they clash.

## 3. Trace the flow, map it as you go

For each suspicious line, answer: what does a person do in the product to make
this line run? Follow the callers up to a button, a page load, a scheduled job,
an API request, a CLI command or a test. Cannot trace it? Say so in the finding.
Don't invent a path.

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
7. **Style**. Don't flag it unless the repo asks for it in writing.

Read [references/deeper-checks.md](references/deeper-checks.md) at this step for
5 and 6. They run on every review.

Say when a file is fine. Silence reads as "not reviewed". It goes in the one
"Clean:" line under the findings table.

### Second pass: chew each finding through

The first pass finds suspects, not findings. For each one, before it goes in
the review:

- Pick the exact input that triggers it, then read the code with that input in
  hand to work out what comes out. This settles most of them.
- Still unsure, and the answer depends on it? Run the smallest piece that
  settles it, the way
  [references/getting-the-code.md](references/getting-the-code.md) says, and
  say you ran it.
- Grep how often it happens in this repo today: a number, not a guess.
- Write the fix out, and drop the finding if it turns out it can't happen.

Skip this and a finding reads as a guess, and the author treats it as one.

## 5. Output format

Five parts in this order: the summary, the map, the findings table, the
findings, the comment for the author. Nothing else, no closing summary.

Parts 1 to 4 go in the report language, whatever language the user or the code
used. Part 5 goes in English, and so does every comment block inside part 4.

The review is built to be scanned. "Shape on the page" in `writing-style`
governs every part: the point in bold at the front of a bullet, a list wherever
three things line up, no paragraph over three lines, no recap. A reader who sees
only the bold text MUST come away knowing what is broken.

### Part 1: what this change is about (report language)

Write it for someone who has not heard of this product or this code. Three
bullets, each one or two sentences:

- **Before**, what was wrong or missing, as a person would notice it.
- **Now**, what happens instead.
- **Where**, the place in the product it shows up.

Leave out file names, type names and function names. Cannot tell what problem
the change solves? Say that first and ask. Guessing here poisons the rest.

```markdown
## What this change is about

- **Before** the Save button on the profile page wiped the name field before the
  server had agreed to store the new name. A failed save lost the typed name,
  with nothing on screen explaining why.
- **Now** the text stays until the server confirms, and comes back if the save
  failed.
- **Where** Settings, the Profile tab, the Save button.
```

### Part 2: the map and the reading order (report language)

How the changed files hang together, and in which order to open them. GitHub
shows them alphabetically, so this part saves the reader that. Three pieces, all
required:

1. **One bullet per file**, the name in bold, then one plain sentence on what it
   is for. Files that belong together share one bullet and are named as a group.
   No prose here.
2. **A plain text tree** in a fenced block marked `text`. No Mermaid: chat
   windows render it as an empty box. Start from the file that pulls the others
   in, branch with `├──` and `└──`, and add a short note after a file name when
   what travels along that edge is the point. Mark the files the PR adds and the
   ones nothing calls yet. Hold the changed files plus the existing ones they
   touch, nothing more, under about twelve lines. Below three files, skip the
   tree.
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

One row per finding, above the findings, so the verdict fits on one screen.
Required, even for a single finding.

- **#** matches the finding below.
- **Severity** is the word used in the heading.
- **Where** is the file and line in backticks, file name only, no path.
- **What** is the symptom in under about 10 words, lowercase, no full stop.

Under the table, one line naming the changed files with nothing to flag. Leave
out how many rows there are or how many files you read: the table shows it.

Nothing to flag anywhere? The table goes, and one line replaces it: what the
change does well, and that it is good to go.

```markdown
## Findings

| # | Severity | Where | What |
| --- | --- | --- | --- |
| 1 | Blocker | `SaveName.tsx:42` | the typed name is lost when the save is slow |
| 2 | Should fix | `profile.ts:88` | the save error is swallowed, so the page stays silent |
| 3 | Nit | `SaveName.tsx:20` | nothing reads the `isLoading` flag |

Clean: `result.ts`, `collect-results.ts`, the test config.
```

### Part 4: the findings (report language)

They follow under that table, in the same `## Findings` section, one `###`
heading each. Sort by severity, number them, and keep the numbers matching the
table. Three levels: blocker, should fix, nit, written in the report language.

The size of the fix says nothing about the severity, and a nit tells the author
to ignore it. So:

- **Nit**: the code behaves the same either way and nothing rots in a year.
  Formatting, a name, a shorter way to write the same expression.
- **Should fix**: anything that can silently drift or mislead later, even when
  the fix is one line. Duplication, code nothing calls, a path with no test, a
  comment that says what the code does not do, a swallowed error, a value
  hardcoded twice, a third party's token where the project has its own.
- Torn between two levels? Take the higher one. The repo's own scale wins when
  it has one.

The reader knows nothing about this code and will not go looking. The example,
the numbers and the fix all sit in the finding.

#### Carry one real case through the whole finding

A finding about the code in general reads as fog. Pick one real case out of the
repo, not an invented `Foo`, and carry it from "Who hits it" to the fix:

- Say what the thing is before naming it: "`parseRow` reads one row of the
  uploaded file." One explanation, then the name alone.
- Show the value going in and the value coming out, quoted.
- Say what the result tells the reader, and what it leaves out, in the reader's
  own words: "the page says 40 rows imported, and says nowhere that two came
  out shifted."
- Then the number: how many more cases look like this one.

```markdown
- **Who hits it** `parseRow` reads one row of the uploaded file. This file has a
  row with a comma inside quotes: `12,"Smith, John",ok`.
- **Comes out** `{ id: "12", name: "\"Smith", status: " John\"" }`. The name is
  cut in two and the status swallowed the second half. The page says 40 rows
  imported, and says nowhere that two of them are broken. Walked the code with
  that input.
```

#### The shape of a finding

Someone in a hurry reads it on a line in GitHub. Four bullets between the
opening line and the fix, and about 25 lines in total including the code.
Anything that does not fit gets cut.

A nit skips this shape: the heading, the link, and one line saying what and
where, fix inline if it's short. No four bullets, no separate fix block.

````markdown
### 1. Blocker: the typed name is lost when the server is slow

[src/features/profile/SaveName.tsx:42](src/features/profile/SaveName.tsx#L42) · [in the PR](https://github.com/acme/shop/pull/7/files#diff-2f0b8aR42)

**The name field clears before the server answers, so a failed save loses what
the person typed. Clear it after the answer.**

- **Who hits it** a person opens Settings, types a new name and presses Save.
  Nothing else reaches this code.
- **Now** line 42 empties the field, then waits for the server:
  `setName(""); await saveName(name);`
- **Comes out** the server answers two seconds later, or fails. The field is
  already empty, so the typed name is neither on screen nor on the server, and
  no message appears. Walked the code with that input.
- **Costs** the person thinks it saved, leaves the page and loses the data. On a
  slow network this is every second try.

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
````

Part by part:

- **Heading**: severity, then the symptom a person could see, not the cause or
  the file name.
- **Link**: right under the heading, both halves, every time:

  ```markdown
  [path/to/file.ts:42](path/to/file.ts#L42) · [in the PR](https://github.com/OWNER/REPO/pull/7/files#diff-HASHR42)
  ```

  The visible text MUST end in `:42`, so the line shows without hovering.
  Writing `[path/to/file.ts](path/to/file.ts#L42)` puts the number in the
  target, where the reader never sees it, that's the mistake to avoid. Path is
  workspace relative, no backticks. Build the second half the way
  [references/pr-links.md](references/pr-links.md) says, required on every
  finding when the target is a PR.
- **The opening line**, bold, under the link: what breaks, then what to do.
  Someone who reads only this line MUST know what is wrong.
- **Who hits it**: the steps in the product, in order, from something a person
  sees. Reachable only from a test? Say so.
- **Now**: what the code does, one sentence, with the line in backticks. Over
  three lines of code, it moves to its own fenced block.
- **Comes out**: the actual value, quoted, worked out by reading the code with
  the input in hand, not a summary. Say how you know: "walked the code with
  that input", or "ran it" when reading left doubt. A finding without a
  concrete outcome MUST NOT be sent.
- **Costs**: what the person or the business loses, and how often.
- **Fix**: one line of words, then the code, up to roughly ten lines. Unsure?
  Give the idea and name what needs checking.
- **Comment on**: the line above the comment block, same two-link shape, and
  whether the line is in the diff.
- **Comment for the PR**: required on every finding, nits included.

Those labels, in that order, nothing added. A fifth bullet means two findings.

### The two halves of a line link

Reviewing a GitHub PR, or landing a comment on a line the diff does not touch?
Read [references/pr-links.md](references/pr-links.md) before the first link: how
the `· [in the PR](…)` half is built, and the rules for a line GitHub refuses a
comment on.

### Writing the per-finding comment

Read [references/comment-style.md](references/comment-style.md) before the first
comment block, and keep it in context until the last one is done. One or two
sentences, mostly a question, no headings and no fenced code.

### Part 5: the summary comment for the author (English)

One fenced block the user pastes into the PR as the overall comment, with
nothing to edit afterwards. Keep the report language, "here is the comment" and
notes to the user out of it.

The same review, shorter, for a colleague who knows the codebase:

- Under 15 lines.
- Blockers and "should fix" only. Nits go in one trailing line, or get dropped.
- The file and line on every point, and the fix.
- No walkthrough, unless the path is the surprise.
- This block MAY use bold severity labels. The per-finding comments MUST NOT.

````markdown
## Comment to leave on the PR

```markdown
Thanks, the retry path is much clearer now. Two things before this goes in.

**Blocker** `src/features/profile/SaveName.tsx:42` clears the input before the
server confirms, so a slow or failing save wipes what the user typed with no
message. Clear it after `saveName` resolves ok, and restore the text on error.

**Should fix** `src/api/profile.ts:88` swallows the error and returns
`undefined`, which is why the failure above is silent. Let it throw, or return
a result the caller can branch on.

Nit: nothing reads the `isLoading` flag in `SaveName.tsx:20`.
```
````

The change is good? Write the comment anyway: one line on what it does well,
and approve it.

## 6. Before you send

Read [references/final-checklist.md](references/final-checklist.md) and run it
over the whole answer. Nothing goes out before that.
