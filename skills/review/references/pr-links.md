# Pointing at the right line

You MUST read this when the review target is a GitHub PR, or when a finding
lands on a line the diff does not touch.

## The link to the line in the PR

The user reads the finding, then goes to GitHub to leave the comment. Make that
one click. Every link under a heading and every "comment on the PR" line MUST
carry two halves: the workspace link, which opens the file in the editor, and
the PR link, which lands on that line in the diff.

```markdown
[path/to/file.ts:42](path/to/file.ts#L42) · [in the PR](https://github.com/OWNER/REPO/pull/7/files#diff-HASHR42)
```

`HASH` is the SHA-256 of the path as the repository spells it. The letter in
front of the number is the side of the diff: `R` for an added line, `L` for a
removed one. Work the hash out once per file and reuse it for every finding in
that file:

```sh
printf '%s' 'path/to/file.ts' | shasum -a 256 | cut -d' ' -f1
```

`OWNER/REPO` and the number come from the PR:
`GH_PAGER=cat gh pr view <number> --json url -q .url`.

Reviewing a branch, a pasted diff or uncommitted work, with no PR to point at?
Drop the second half. The workspace link stands alone.

## Where the comment goes

GitHub takes an inline comment only on a line the diff touches. That MUST be
worked out before writing the target:

- **In the diff**: name the line, and say added (green) or removed (red). Every
  line of a new file is added.
- **Untouched**: say so, name the nearest changed line to hang it on, and open
  the comment with the real location, "a line up, at `report.ts:55`, ...".
- **Two files**: the comment goes on the one the author has to edit, and names
  the other.
- **Nothing fits**: the comment goes in part 5 instead. Put it there.
