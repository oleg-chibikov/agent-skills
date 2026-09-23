# Pointing at the right line

You MUST read this when the review target is a GitHub PR, or when a finding
lands on a line the diff does not touch.

## The link to the line in the PR

The user reads the finding, then goes to GitHub to leave the comment. Make that
one click. Every link under a heading and every "comment on the PR" line MUST
carry two halves: the workspace link, which opens the file in the editor, and
the GitHub link, which lands on that line.

```markdown
[path/to/file.ts:42](path/to/file.ts#L42) · [on GitHub](https://github.com/OWNER/REPO/blob/HEAD_SHA/path/to/file.ts#L42)
```

The second half points at the file at the head commit of the PR: `#L42` for one
line, `#L42-L50` for a range, and the first line when the finding covers a
block. A `/files#diff-<hash>R42` anchor MUST NOT be used, GitHub loads the diff
lazily and collapses large files, so the anchor lands nowhere.

`OWNER/REPO` and the head commit come from the PR, read once:

```sh
GH_PAGER=cat gh pr view <number> --json url,headRefOid -q '.url, .headRefOid'
```

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
- **Nothing fits**: the finding stays in the report and gets no comment. Say so
  on its "Comment on" line.
