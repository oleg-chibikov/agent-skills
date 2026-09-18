---
name: review
description: 'Use only when the user explicitly asks to review a pull request: "review this PR", "code review", "review" plus a PR link or PR number, or the same in another language.'
---

# Review code

Every finding MUST be usable by someone outside this repository. Jargon,
internals and "consider refactoring" MUST NOT appear.

Every step names the file holding its detail. You MUST read that file when you
reach the step, before writing a line of what the step produces.

## 1. Set the language and the writing rules

- Which language each part comes back in:
  [references/report-language.md](references/report-language.md).
- How every line is written:
  [references/writing-rules.md](references/writing-rules.md).

Both MUST be read before the first line of the review.

## 2. Find what to review

The file, PR or branch the user named, else uncommitted changes, else the branch
against its base. You MUST NOT ask when the target is obvious. The order, the
commands and when you MAY ask are in
[references/find-the-target.md](references/find-the-target.md).

## 3. Read the repo rules first

Repo rules beat your habits, and what the repo requires MUST NOT be flagged. The
files to open are in [references/repo-rules.md](references/repo-rules.md).

## 4. Trace the flow, map it as you go

What a person does to make a suspicious line run, and how the changed files hang
together. How far to chase it is in
[references/trace-the-flow.md](references/trace-the-flow.md).

## 5. Look for what matters

Seven things in order, breakage first and style last, plus the two checks that
run on every review:
[references/what-to-look-for.md](references/what-to-look-for.md).

## 6. Write the report

Four parts in this order, each with its own file:

1. What this change is about:
   [references/part-1-summary.md](references/part-1-summary.md).
2. The map and the reading order:
   [references/part-2-map.md](references/part-2-map.md).
3. The findings table:
   [references/part-3-table.md](references/part-3-table.md).
4. The findings:
   [references/part-4-findings.md](references/part-4-findings.md), plus
   [references/finding-shape.md](references/finding-shape.md) for the blocks
   each one is built from.

The rules holding over all four, and what MUST NOT be added to them, are in
[references/report-shape.md](references/report-shape.md). Read it before part 1.

## 7. Offer the deep dive

The report MUST close with one offer: which findings to dig into. The choices,
what digging into one means and how the finding comes back are in
[references/deep-dive.md](references/deep-dive.md).

## 8. Offer to post the comments

Nothing goes on the PR until the user asks for it. The offer, the question that
comes before the first call and the `gh` call per comment are in
[references/posting-comments.md](references/posting-comments.md).

## 9. Before you send

You MUST read
[references/final-checklist.md](references/final-checklist.md) and run it over
the whole answer. Nothing goes out before that.
