---
name: review
description: 'Use whenever the user asks to look at code someone wrote, in any repository. Triggers include "review", "review this", "code review", "look at my changes", the same ask in any other language, and the word review followed by nothing but a GitHub pull request URL, a PR number, a branch name, a file path or a pasted diff. A bare link after "review" counts: load this skill before fetching the link. Writes the full review in the report language set in LANGUAGE.md: what the change solves, a map of how the changed files hang together with the order to read them in, then findings with line numbers, the input, the real output and the fix. Closes every finding with a short English comment ready to paste on that line.'
---

# Review code

MUST, MUST NOT, SHOULD, SHOULD NOT and MAY below carry their RFC 2119 meaning.
MUST and MUST NOT are hard rules. SHOULD and SHOULD NOT can be broken only with
a reason you state in the review. MAY is free choice.

Every finding MUST be understandable by someone outside this repository. Jargon,
internals and "consider refactoring" MUST NOT appear.

## What language to write in

Two languages are in play, and you MUST keep them apart.

- **The report language**: parts 1 to 4, the long text only the user reads.
  Read `LANGUAGE.md` next to this file and use the language named there. No such
  file, or it names nothing? Write English.
- **English**: part 5 and every comment block meant to be pasted on the PR. The
  whole team reads a PR, so those stay English whatever the report language is.

The user asked for a different language in this conversation? Their ask wins,
and you MUST say nothing about it.

The examples in this skill are written in English. Copy their shape, and write
your own words in the report language. The bold labels inside a finding,
**In short**, **When it happens** and the rest, get translated along with
everything else.

## How to write every line

Before you write the first line of the review, you MUST load the `writing-style`
skill and follow it. It sits in the same skills folder as this file, at
`writing-style/SKILL.md`. It holds the
rules: one idea per sentence, plain words a 12 year old knows, no dash between
words, one example per sentence, no "never", no padding, and the checklist to
run before you send. They cover every word of the review, parts 1 to 5, both
languages. Load it once, unless it is in context already.

Every rule below is a MUST on top of that skill. These are the parts only a
review needs.

- The first line of a finding gives the whole point. Reading stops there and the
  person still knows what is broken.
- Nothing rests on a finding above it. Each one stands on its own, because the
  person reads it on a line in GitHub with nothing else around it.
- Writing the report in a language other than English? The `writing-style` skill
  ends with a section on that. Its bans hold in every language, and the filler
  connectors are the first thing to cut.
- A count beats a pile of names: "`OrderRow` and 2 more like it".

Before you send, read every sentence once. Had to go back to understand it?
Split it.

## 1. Find what to review

You MUST NOT ask when the target is obvious. Pick in this order:

1. The user named a file, a PR number or a branch. Use that.
2. Uncommitted changes: `git status --short`, then `git diff` and
   `git diff --staged`.
3. Otherwise the branch: `git diff origin/HEAD...HEAD`.

For a PR: `GH_PAGER=cat gh pr diff <number>`. If `origin/HEAD` is unset, get the
base with
`GH_PAGER=cat gh repo view --json defaultBranchRef -q .defaultBranchRef.name`.
You MAY ask the user only when none of that finds anything.

The target is a branch or a PR? You MUST read
[references/getting-the-code.md](references/getting-the-code.md) now. It holds
the worktree steps, the rule about the user's own checkout, and when running the
code is allowed. Uncommitted changes in the open repo need none of that.

## 2. Read the repo rules first

You MUST read `CONTRIBUTING.md`, `REVIEW.md`, `AGENTS.md`, `CLAUDE.md`,
`.github/copilot-instructions.md`, and any skill or doc they point to. Repo
rules beat your habits: you MUST NOT flag what the repo requires, and when a
common convention clashes with a repo rule you MUST follow the rule and say in
one line that they clash.

## 3. Read enough to trace the flow, and map it as you go

For each suspicious line you MUST answer this: what does a person do in the
product to make this line run? Follow the callers up to a button, a page load, a
scheduled job, an API request, a CLI command or a test. Cannot trace it? You
MUST say so in the finding, and you MUST NOT invent a path.

While you read, you MUST build the map: which changed file calls which, what
each one is for, which one carries the idea of the change. It is part 2 of the
answer, so collect it now.

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
5. **Wrong shape for the job**, below. You MUST check it every time, even when
   every line is correct.
6. **Already written somewhere**, below. You MUST check it every time too.
7. **Style**. You MUST NOT flag it unless the repo asks for it in writing.

You MUST say when a file is fine. Silence reads as "not reviewed".

### Wrong shape for the job

You MUST start from the task: read the PR description, the linked issue and the
tests, and say in one sentence what the change has to achieve. Then ask:

- Does the design achieve all of it? Name the part of the task it misses.
- Is anything here for a problem nobody has: a flag with one value, an
  abstraction with one implementation, a field nothing reads? Say what it costs
  to carry.
- Is the work in the right place? A check that belongs on the server sitting in
  the browser, logic in a component every other screen will need, a package
  reaching into another package's internals.
- Would a plainer version do the same? Describe it in two or three sentences,
  with the file it would live in. Nothing plainer in mind? You MUST say the
  shape is fine and move on.
- Does it match how this repo does the same kind of thing elsewhere? You MUST
  link one existing example.

A finding here MUST carry a cost: what breaks, what gets slower, what the next
person has to read. "This could be cleaner" MUST NOT be written as a finding.

### Already written somewhere

Before you accept a new helper, parser, formatter, date maths, deep clone, sort,
debounce, retry or validation, you MUST look:

- You MUST grep the repo for the behaviour and for the obvious names, including
  the shared packages folder and any internal utils package.
- You MUST check `package.json` and the lockfile: the library may already be a
  dependency, paid for and used elsewhere.
- You MUST check the platform: `Intl`, `structuredClone`, `URL`,
  `URLSearchParams`, `AbortController`, `Object.groupBy`, `toSorted`. You MUST
  honour the repo's baseline rule.

The finding MUST name the exact replacement: the file and export with a link, or
the package and function. "Probably something in lodash" MUST NOT be written as
a finding. You MUST say how many lines go away and how many copies of this logic
the repo stops carrying. You MUST say why a copy is a risk beyond the line
count: the two versions drift, and a bug fixed in one stays in the other. A
dependency the repo does not have yet stays a question: you MUST say what it
weighs and let the author decide. The duplicate is simpler than the shared one,
or the shared one drags in something heavy? You MUST say that and leave the code
alone.

### Second pass: chew each finding through

The first pass finds suspects. You MUST NOT write the review off it. Take each
one and get to the point where you can show the problem happening:

- You MUST write down the exact input that triggers it.
- You MUST work out what comes out, by reading the code with that input in hand,
  line by line. Most findings end here, and that is the cheapest place to end.
- Still unsure after reading, and the finding depends on the answer? You MUST
  run the smallest piece, the way
  [references/getting-the-code.md](references/getting-the-code.md) says, paste
  what came back and say you ran it. Doubt about what a library or a compiler
  does with an odd input is the usual reason.
- You MUST count how often it can happen in this repo today: grep, call sites, a
  number. This is reading too, no run needed.
- You MUST write the fix out. A message or a string means the replacement text
  itself.
- You MUST drop the finding if it cannot happen, and say in one line that you
  looked and it is fine.

A finding that survives this reads as obvious. One that skips it reads as a
guess, and the author treats it as one.

## 5. Output format

The answer MUST have five parts in this order: the summary, the map, the count,
the findings, the comment for the author. Nothing else MUST appear, no closing
summary.

Parts 1 to 4 MUST be written **in the report language**, whatever language the
user or the code used. Part 5 MUST be written **in English**, and so MUST the
comment block that closes every finding in part 4.

### Part 1: what this change is about (report language)

You MUST write it for someone who has never heard of this product or this code.
Three to five sentences. Bullets, file names, type names and function names MUST
NOT appear. Order: what was wrong or missing before as a person would notice it,
what happens instead now, where in the product it shows up. Cannot tell what
problem the change solves? You MUST say that first and ask, because guessing
here poisons the rest of the review.

```markdown
## What this change is about

The Save button on the profile page used to wipe the name field straight away,
before the server had agreed to store the new name. When saving failed the typed
name was gone, and the person had to type it again with nothing explaining why.
Now the text stays on screen until the server confirms, and comes back if saving
failed. You see it in Settings, on the Profile tab, on the Save button.
```

### Part 2: the map and the reading order (report language)

How the changed files hang together, and in which order to open them. Someone
reading the PR in GitHub's alphabetical order understands it last; this part
saves them that. Three pieces, all required:

1. **One sentence per file**, in plain words. Files that belong together MUST be
   grouped and named as a group.
2. **A plain text tree** in a fenced block marked `text`. Mermaid and any other
   drawing format MUST NOT be used: chat windows render them as an empty box.
   The tree MUST start from the file that pulls the others in, branch with
   `├──` and `└──`, and carry a short note after the file name when what travels
   along that edge is the point. It MUST mark the files the PR adds and the ones
   nothing calls yet. It MUST hold the changed files plus the existing ones they
   touch, nothing more, and MUST stay under about twelve lines. Below three
   files you MUST skip the tree.
3. **The reading order**, numbered, one line each, saying why the file comes at
   that point. It MUST start where the data starts or where the simplest piece
   is, and end where it all ties together. Tests and config MUST go last.

One file and a test? You MUST write one line saying the map is not needed.

````markdown
## How the files hang together

`import-csv.ts` reads the uploaded file and pulls the rows out of it. It leans
on two new helpers: one parses a single row, the other turns it into a record.
The outcome travels in `Result`, which this PR taught to carry warnings. Tests
and build config form their own group, they only pull the new files into the
run.

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

### Part 3: the count (report language)

One line, required: how many files you read and how many findings, split by
severity.

### Part 4: the findings (report language)

You MUST sort by severity and number them. Three levels: blocker, should fix,
nit. Write the label in the report language.

The size of the fix says nothing about the severity, and calling something a nit
tells the author to ignore it. So a nit MUST mean the code behaves the
same either way and nothing can rot if it stays in for a year: formatting, a
name, a shorter way to write the same expression. Anything that can silently
drift or mislead later is "should fix", even when the fix is one line:
duplication, code nothing calls, a path with no test, a comment or doc that says
what the code does not do, a swallowed error, a value hardcoded in two places, a
third party's token where the project has its own. Torn between two levels? Take
the higher one. The repo's own scale wins when it has one.

You MUST chew every finding through. The reader knows nothing about this code
and will not go looking: the example, the numbers and the fix MUST all sit in
the finding itself. Write it as if they have to apply the fix today without
opening anything else.

#### Carry one real case through the whole finding

A finding written about the code in general reads as fog. The same finding
written about one named thing reads as obvious. You MUST pick one case out of
the repo and carry it from "When it happens" to "How to fix it", the same
case every time.

- **Pick a case that exists.** A real component, a real file, a real input you
  found while reading. An invented `Foo` MUST NOT appear.
- **Say what the thing is before you name it.** "Take `parseRow`, which reads
  one row out of the uploaded file." One short explanation the first time, then
  the name alone.
- **Show the value going in and the value coming out**, as two small blocks or
  one block and one sentence. The reader MUST see the difference without
  working it out.
- **Say what the result says, and what it does not say**, in the words of the
  person who will read that result. "The page says 40 rows imported. That two of
  them came out shifted, the page says nowhere."
- **Then give the number**: how many more cases look like this one. The case
  makes it real, the number makes it worth fixing.

Feels too obvious while you write it? That is the target. The author reads the
finding once, on a line, with the rest of the PR in their head.

Bad, and why:

```markdown
**What comes out.** The field is filled while the row is parsed, but it never
reaches the assembled record, because assembly only takes four fields.
```

Names no case, quotes no value, and asks the reader to picture it. Same finding
with one real case carried through:

```markdown
**When it happens.** Take `parseRow`, which reads one row of the file. The file
has a row with a comma inside quotes: `12,"Smith, John",ok`.

**What comes out.** Walked the code with that input. The parser returns:

{ id: "12", name: "\"Smith", status: " John\"" }

The name is cut in two and the status swallowed the second half of it. The page
says 40 rows imported. That two of them are broken, it says nowhere.
```

Each finding MUST look exactly like this:

````markdown
### 1. Blocker: the typed name is lost when the server is slow

[src/features/profile/SaveName.tsx:42](src/features/profile/SaveName.tsx#L42) · [in the PR](https://github.com/acme/shop/pull/7/files#diff-2f0b8aR42)

**In short.** The name field clears before the server answers. The name is
lost. Clear it after the answer.

**When it happens.** A person opens Settings, types a new name and presses
Save. Nothing else reaches this code.

**What the code does now.** Clears the field right after the press, without
waiting for the server.

```tsx
setName(""); // line 42, called before saveName
await saveName(name);
```

**What comes out.** The server answers two seconds later, or fails. The field
is already empty: the typed name is neither on screen nor on the server. No
message either.

**Why it is a problem.** The person thinks it saved, leaves the page and loses
the data. On a slow network this is every second try.

**How to fix it.** Clear the field after the confirmation, and leave the text
alone on error.

```tsx
const saved = await saveName(name);
if (saved.ok) setName("");
```

**Comment goes on** → [src/features/profile/SaveName.tsx:42](src/features/profile/SaveName.tsx#L42) · [in the PR](https://github.com/acme/shop/pull/7/files#diff-2f0b8aR42),
line 42, added in this PR, the green side of the diff.

```markdown
this clears the input before saveName comes back - if the save fails the typed
name is gone. can we clear it after the call resolves ok?
```
````

Rules for each part:

- **Heading**: severity, then the symptom a person could see. It MUST NOT be the
  cause or the file name.
- **Link**: the line right under the heading, before any prose. The visible
  text MUST end in `:42`, so the person sees the line without hovering. Copy
  this shape, both halves, every time:

  ```markdown
  [path/to/file.ts:42](path/to/file.ts#L42) · [in the PR](https://github.com/OWNER/REPO/pull/7/files#diff-HASHR42)
  [path/to/file.ts:42-48](path/to/file.ts#L42-L48) · [in the PR](https://github.com/OWNER/REPO/pull/7/files#diff-HASHR42)
  ```

  The second half is built the way
  [references/pr-links.md](references/pr-links.md) says, and it MUST be there on
  every finding when the target is a PR.

  Bad, and the one mistake that keeps happening: `[path/to/file.ts](path/to/file.ts#L42)`.
  The number is in the target and the reader sees none of it. An editor rule
  saying the visible text must equal the path applies to a link with no line
  number; this link has one, so the number stays in the text. Same shape for
  every link inside a finding: `[README.md:139](path/to/README.md#L139)`.

  The path is workspace relative. A file name in backticks MUST NOT appear, and
  "line 42" as plain text MUST NOT appear. Two places MUST get two links, each
  with its own number.
- **In short**, the opening line: two or three short sentences, the whole finding
  in a nutshell.
  What breaks, then what to do. A person who reads only this line MUST already
  know what is wrong. Code words MUST NOT appear here.
- **When it happens**: the steps in the product, in order, starting from
  something a person sees. For a job or a CLI, what starts it and when.
  Reachable only from a test? You MUST say that.
- **What the code does now**: the behaviour in a sentence or two, plus the few
  lines that do it, quoted. Type names, framework words and "the reducer
  dispatches" MUST NOT appear.
- **What comes out**: the actual value, string, screen or error text, worked out
  by reading the code with the input in hand. Quote it. A summary of it
  ("the field is lost", "the link does not save") MUST NOT stand in for the value
  itself. You MUST say how you know: "walked the code with that input", or
  "ran it, this came back" when reading left doubt. A finding without a
  concrete outcome MUST NOT be sent.
- **Why it is a problem**: what the person or the business loses, and how often.
- **How to fix it**: the idea in words, then the code, up to roughly ten lines.
  For a message or a string, the exact replacement text. Unsure the fix is
  right? You MUST give the idea and name what needs checking.
- **Where the comment goes**: required line right above the comment block. The
  file and line in the same two-link shape as under the heading, the number
  again in words, and whether the line is in the diff. The user clicks the PR
  link, sees the line and types. They MUST NOT have to work out where to click.
- **Comment for the PR**: required on every finding, nits included.

Three or more shapes of code hit the same line? You MUST list them and say which
one is the surprising one. Numbers beat adjectives in the report text: "two of
the eleven components", "every build", "checked all 26 call sites". The raw
counters MUST stay there; the comment on the line MUST carry at most one number,
in a sentence.

### The two halves of a line link

Reviewing a GitHub PR, or landing a comment on a line the diff does not touch?
You MUST read [references/pr-links.md](references/pr-links.md) before you write
the first link. It holds how the `· [in the PR](…)` half is built, and the rules
for a line GitHub will refuse a comment on.

### Writing the per-finding comment

You MUST read [references/comment-style.md](references/comment-style.md) before
you write the first comment block, and keep it in context until the last one is
done. One or two sentences, mostly a question, no headings and no fenced code.
The file holds the house style and the examples to copy.

### Part 5: the summary comment for the author (English)

One fenced block the user pastes into the PR as the overall comment, with
nothing to edit afterwards: the report language, "here is the comment", and
notes to the user MUST NOT appear inside it.

The same review, shorter, aimed at a colleague who knows the codebase. It MUST
stay under 15 lines. It MUST carry blockers and "should fix" only; nits go in a
single trailing line or get dropped. It MUST keep the file and line on every
point and keep the fix, and it MUST drop the walkthrough unless the path is the
surprising part. This block MAY use bold severity labels; the per-finding
comments MUST NOT.

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

If the change is good, the comment MUST still be written: say what it does well
in one line and approve it.

## 6. Language

"How to write every line" at the top of this skill holds here too. So does the
`writing-style` skill, for every
word of the review, in both languages. Its ban on "never", the dash
between words and inflated words like "surface" or "semantics" holds in the
findings, the per-finding comments and the summary comment alike. On top of
that:

- Parts 1 to 4 MUST be in the report language from `LANGUAGE.md`, part 5 and
  every per-finding comment inside part 4 MUST be English, whatever language the
  user wrote in. Asked for one language only? You MUST obey and say nothing
  about it.
- You MUST say what is broken in plain words. You MUST NOT soften a blocker into
  a suggestion, it hides the problem.

## 7. Before you send

You MUST run the final checklist of the `writing-style` skill over the whole
answer first. Then reread once and check:

- Every sentence went down in one pass. Anything you had to reread is split, and
  no sentence carries two commas or two ideas.
- No dash joins two parts of a sentence anywhere, and no sentence names three
  things in a row. Hyphens appear only inside a single word.
- Every finding opens with the short line, **In short** in the example, and that
  line alone says what is broken and what to do.
- Parts 1 to 4 in the report language, part 5 in English with none of the report
  language left in it, and the word "never" nowhere. Writing the report in
  another language? Its own version of "never" is gone too.
- The summary says what was wrong before and what happens now, with no code
  words in it.
- The map names every changed file, and the reading order says why each file
  comes where it does.
- Every finding: a line link, the flow, the real thing that comes out, the fix,
  and an English comment block with its target line above it. Nothing rests on
  "could" alone.
- Every link in parts 1 to 4 shows its line number in the visible text, as
  `[file.ts:42](path/to/file.ts#L42)`. Search the answer for `](` and check each
  one: a visible text with no `:42` in it is the mistake to fix before sending.
- Reviewing a PR? Every link under a heading and every "comment on the PR" line
  carries the `· [in the PR](…)` half too, with the hash of that file's path and
  the right side letter, `R` or `L`, in front of the number.
- Every finding names one real case and keeps it to the end, the value it
  produces is quoted, and every code name got one plain explanation the first
  time it appeared.
- Every per-finding comment: one or two sentences, mostly a question, no
  headings, no lists, no fenced code, no run tallies, no paragraph explaining
  the damage. Every nit starts with `nit: `, and the hedge matches what you
  actually checked.
- You checked the shape of the solution against the task, and whether the repo
  or a dependency already does this. Found nothing? Say so in one line.
- The summary comment is paste ready and carries every blocker.
- The reviewed branch is still checked out, the user's own checkout is as you
  found it, and the answer says where the code sits.
- Nothing on the list is something the repo rules told you to do, and a person
  outside the team could act on any finding.
