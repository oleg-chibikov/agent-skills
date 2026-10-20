# Reviewing a PR inside a stack

You MUST read this on every PR review, before the first finding. A stack is a
chain of PRs, each one based on the branch of the one below it.

## Find the stack

```sh
GH_PAGER=cat gh pr view <number> --json baseRefName,headRefName,body
GH_PAGER=cat gh pr list --state open --base <headRefName> \
  --json number,title,headRefName
```

- **Below**: a base other than the default branch is the head of the PR below.
- **Above**: every open PR the list returns. Run the list again from each of
  their heads until it comes back empty.
- **Stack tools** such as Graphite also list the stack in the PR body.

No PR below and none above? The PR is not in a stack, and the rest of this
file is skipped.

## Review this PR alone

The diff MUST be taken against the PR's own base, the way `gh pr diff` gives
it. Code a PR below adds belongs to that PR's review.

## Drop what a PR above fixes

Each finding MUST be checked against the diffs of the PRs above before it goes
in: `GH_PAGER=cat gh pr diff <above>`.

- **Fixed above**: the finding MUST NOT go in, as a comment or in the table.
  The summary MAY name it in one line, with a link to the PR that fixes it.
- **Fixed in part**: keep the finding, and name the PR that covers the rest.
