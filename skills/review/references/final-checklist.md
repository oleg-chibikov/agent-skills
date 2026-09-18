# Before you send

You MUST read this when the review is written and before it goes out.

Run the `writing-style` final checklist over the whole answer first. Then reread
once and check. Every line below MUST be true before the answer goes out:

- Every sentence went down in one pass. Anything you reread is split, and no
  sentence carries two commas or two ideas.
- No dash joins two parts of a sentence, and no sentence names three things in a
  row. Hyphens only inside a word.
- Every finding opens with the bold line under the link, and that line alone
  says what is broken and what to do. Then the four `####` headings, in order,
  unless it's a nit: one line, no headings.
- Part 1 and every finding carry their labels as headings with the text below,
  no label glued to the front of a sentence.
- The findings table sits above the findings, and every row matches one below.
- No paragraph over three lines, no list over five items. Three facts in a row
  are a list, each point in bold at the front.
- Parts 1 to 4 in the report language from `LANGUAGE.md`, not the language of the
  user's one-line ask, unless they named a language in this conversation. Part 5
  in English with none of the report language left in it, and "never" nowhere.
  In another language, its own version of "never" is gone too.
- Reading settled it, or the run count stayed at a couple at most, no full
  build, install or suite.
- The summary says what was wrong and what happens now, with no code words.
- The map names every changed file, and the reading order says why each comes
  where it does.
- Every finding: a line link, the flow, the real thing that comes out with its
  evidence marker in brackets, the fix, and an English comment block with its
  target line above it. Nothing rests on "could" alone.
- A finding that got the deep dive looks like every other one: same four
  headings, same order, only the marker, the value and the count differ.
- The answer ends with the deep dive checkbox list, every box unticked, one per
  finding with its number and its table text, plus the "all of them" box.
- Every link in parts 1 to 4 shows its line number in the visible text, as
  `[file.ts:42](path/to/file.ts#L42)`. Search the answer for `](` and check each
  one: a visible text with no `:42` is the mistake to fix before sending.
- Reviewing a PR? Every link under a heading and every "comment on the PR" line
  carries the `· [in the PR](…)` half, with that file's path hash and the side
  letter, `R` or `L`, in front of the number.
- Every finding names one real case and keeps it to the end, the value it
  produces is quoted, and every code name got one plain explanation the first
  time it appeared.
- Every per-finding comment: one doubt and one ask, under 40 words, no
  headings, no lists, no fenced code, no run tallies, no paragraph on the
  damage. Every nit starts with `nit: `, and the hedge matches what you checked.
- Every finding carries a second, shorter comment under `Shorter:`, the same
  ask with the mechanism and the aside cut out.
- Every per-finding comment leads with the problem in plain words, not a chain
  of function or call names. A name or snippet shows up only where the plain
  sentence alone couldn't point at the spot.
- You checked the shape against the task, and whether the repo or a dependency
  already does this. Found nothing? Say so in one line.
- The summary comment is paste ready and carries every blocker.
- The reviewed branch is still checked out, the user's own checkout is as you
  found it, and the answer says where the code sits.
- Nothing on the list is something the repo rules told you to do, and a person
  outside the team could act on any finding.
