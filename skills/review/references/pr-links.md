# Pointing at the right line

Read this when the review target is a GitHub PR, or when a finding lands on a
line the diff does not touch.

## The link to the line in the PR

The user reads the finding, then goes to GitHub to leave the comment. Make that
one click. Every link under a heading and every "comment on the PR" line MUST
carry two halves: the workspace link, which opens the file in the editor, and
the PR link, which lands on that line in the diff.

```markdown
[path/to/file.ts:42](path/to/file.ts#L42) · [in the PR](https://github.com/OWNER/REPO/pull/7/files#diff-HASHR42)
```

`HASH` is the SHA-256 of the path as the repository spells it, and the letter in
front of the number is the side of the diff: `R` for an added line, `L` for a
removed one. Work the hash out once per file, and reuse it for every finding in
that file:

```sh
printf '%s' 'path/to/file.ts' | shasum -a 256 | cut -d' ' -f1
```

`OWNER/REPO` and the number come from the PR itself:
`GH_PAGER=cat gh pr view <number> --json url -q .url`.

Reviewing a branch, a pasted diff or uncommitted work, with no PR to point at?
Then the second half MUST be left out and the workspace link stands alone.

## Where the comment goes

GitHub takes an inline comment only on a line the diff touches. You MUST work
that out before writing the target:

- Line is in the diff: you MUST name it, and say added (green) or removed (red).
  Every line of a new file is added.
- Line is untouched: you MUST say so, name the nearest changed line to hang it
  on, and open the comment with the real location, "a line up, at
  `report.ts:55`, ...".
- Two files: the comment MUST go on the one the author has to edit, and the text
  MUST name the other.
- Nothing fits: the comment MUST go in part 5 instead, and you MUST put it
  there.
