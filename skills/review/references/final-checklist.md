# Before you send

You MUST read this when the review is written and before it goes out.

Run the `writing-style` final checklist over the whole answer first. Then reread
once and check. Every line below MUST be true before the answer goes out:

- Every sentence went down in one pass. Anything you reread is split, and no
  sentence carries two commas or two ideas.
- No dash joins two parts of a sentence, and no sentence names three things in a
  row. Hyphens only inside a word.
- Every comment, tagged `C1` and ending in `Explanation: E1`, sits in
  `## Comments` above `## Explanations`. Both follow the table's order.
- Every explanation opens with a bold line saying what breaks and what to do.
  Then the four `####` headings in order. A nit gets one line, no headings.
- Part 1 and every finding carry their labels as headings with the text below,
  no label glued to the front of a sentence.
- No paragraph over three lines, no list over five items. Three facts in a row
  are a list, each point in bold at the front.
- The whole report is in the report language from `LANGUAGE.md`, not the
  language of the user's one-line ask, unless they named one in this
  conversation. Every comment block is English, with none of the report language
  left in it. "Never", and its version in any other language, is gone.
- Reading settled it, or the run count stayed at a couple at most, no full
  build, install or suite.
- The summary says what was wrong and what happens now, with no code words.
  The table sits above the findings, every row matching one below.
- The map names every changed file, and the reading order says why each comes
  where it does.
- Every finding: a line link, the flow, the real thing that comes out with its
  evidence marker in brackets, the fix. Nothing rests on "could" alone.
- A deep dived finding looks like the rest: same four headings, same order.
  Only the marker, the value and the count differ.
- The four parts went on screen before the second round, and the second round
  came before the posting offer. Its findings carry on the numbering.
- The answer ends with an offer to post the comments, next to a choice that
  skips it. The deep dive comes last: one choice per finding with its number and
  its table text, then all of them and nothing more. Search the answer for
  `- [` : a markdown checkbox means the picker tool was skipped.
- Nothing went on the PR before the user asked for it and named the version,
  long or short.
- Every link in the report shows its line number in the visible text, as
  `[file.ts:42](path/to/file.ts#L42)`. Search the answer for `](` and check each
  one: a visible text with no `:42` is the mistake to fix before sending.
- Reviewing a PR? Every link under a heading and every "comment on the PR" line
  carries the `· [in the PR](…)` half, `pull/<number>/files#diff-<anchor>R42`.
  Search for `/blob/`: it stands only for a file the PR leaves untouched.
- Every finding names one real case and keeps it to the end, quotes the value it
  produces, and explains each code name in plain words the first time.
- Every per-finding comment: one doubt and one ask, under 40 words, no
  headings, no lists, no fenced code, no run tallies, no paragraph on the
  damage. Every nit starts with `nit: `, and the hedge matches what you checked.
- Every finding carries a second, shorter comment under `Shorter:`, the same
  ask with the mechanism and the aside cut out.
- Every per-finding comment leads with the problem in plain words, not a chain
  of function or call names. A name or snippet shows up only where the plain
  sentence alone couldn't point at the spot.
- You checked whether the repo or a dependency already does this, and the second
  round checked the shape against the task. Found nothing? Say so in one line.
- The reviewed branch is still checked out, the user's own checkout is as you
  found it, and the answer says where the code sits.
- Nothing on the list is something the repo rules told you to do, and a person
  outside the team could act on any finding.
