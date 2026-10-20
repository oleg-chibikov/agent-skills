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
  left in it. A search of every comment for `never` and `nothing`, and their
  twins in any other language, comes back empty.
- Reading settled it: a couple of runs at most, no full build, install or suite.
- The summary says what was wrong and what happens now, with no code words.
  The table sits above the findings, every row matching one below.
- Part 2 has a user flow and a code flow in `mermaid` blocks, each with an
  `Open the diagram` link. Every code node says what the file does.
- Every finding: a line link, the flow, the real thing that comes out with its
  evidence marker in brackets, the fix. No finding rests on "could" alone.
- The four parts went on screen before the second round, and the second round
  came before the posting offer. Its findings carry on the numbering.
- The answer ends with an offer to post the comments, next to a choice that
  skips it. Search the answer for `- [`: a markdown checkbox means the picker
  tool was skipped.
- No comment went on the PR before the user asked for it and picked a version.
- Every link in the report shows its line number in the visible text, as
  `[file.ts:42](path/to/file.ts#L42)`. Search the answer for `](` and check each
  one: a visible text with no `:42` is the mistake to fix before sending.
- Reviewing a PR? Every link under a heading and every "comment on the PR" line
  carries the `· [in the PR](…)` half, `pull/<number>/files#diff-<anchor>R42`.
  Search for `/blob/`: it stands only for a file the PR leaves untouched.
- Every finding names one real case and keeps it to the end, quotes the value it
  produces, and explains each code name in plain words the first time.
- Every per-finding comment: one doubt and one ask, under 40 words, no
  headings, lists, fenced code, run tallies or damage. It starts with `nit: `
  where it is one, and `blocker: ` on a sure blocker alone. Outside `Assertive:`
  it opens unsure or asks, even about a checked fact. No hedge phrase shows up
  in two findings.
- Every finding carries a shorter comment under `Shorter:` and the short one
  with no hedge under `Assertive:`, all with the same ask.
- Every per-finding comment leads with the problem in plain words, not a chain
  of function or call names. A name or snippet shows up only where the plain
  sentence alone couldn't point at the spot.
- You checked whether the repo or a dependency already does this, and the second
  round checked the shape against the task. Found no match? Say so in one line.
- The reviewed branch is still checked out, the user's own checkout is as you
  found it, and the answer says where the code sits.
- No item on the list is something the repo rules told you to do, and a person
  outside the team could act on any finding.
