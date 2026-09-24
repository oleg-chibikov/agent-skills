# Pointing at the right line

You MUST read this when the review target is a GitHub PR, or when a finding
lands on a line the diff does not touch.

## The link to the line in the PR

The user reads the finding, then goes to the PR to leave the comment. Make that
one click. Every link under a heading and every "comment on the PR" line MUST
carry two halves: the workspace link, which opens the file in the editor, and a
link into the PR, which lands on that line of the diff with its comment box.

```markdown
[path/to/file.ts:42](path/to/file.ts#L42) · [in the PR](https://github.com/OWNER/REPO/pull/123/files#diff-<anchor>R42)
```

A `blob/<sha>/path#L42` permalink MUST NOT be used. It drops the reader out of
the review onto a read-only file, with no way to comment from there.

The anchor is `diff-` plus the sha256 of the file path, then the side and the
line: `R42` on the new side, `L42` on the removed side, the first line for a
range or a block.

```sh
printf '%s' 'path/to/file.ts' | shasum -a 256 | cut -d' ' -f1
```

`OWNER/REPO` and the number come from the PR, read once:

```sh
GH_PAGER=cat gh pr view <number> --json url -q .url
```

GitHub collapses a large file, so the anchor can land on the file rather than
the line. The reader expands it, still cheaper than leaving the PR.

The finding sits in a file the PR does not touch? Then the diff has no anchor
for it: link `blob/HEAD_SHA/path#L42` and say in the finding that the file is
outside the PR.

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
