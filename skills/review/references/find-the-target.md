# Finding what to review

You MUST NOT ask when the target is obvious. Pick in this order:

1. The user named a file, a PR number or a branch. Use that.
2. Uncommitted changes: `git status --short`, then `git diff` and
   `git diff --staged`.
3. Otherwise the branch: `git diff "$base"...HEAD`.

`$base` is the branch this one came off. The remote is `origin` almost
everywhere, and on a fork or a mirror it is not, so read its name:

```sh
remote=$(git remote | grep -qx origin && echo origin || git remote | head -1)
base=$remote/$(GH_PAGER=cat gh repo view --json defaultBranchRef \
  -q .defaultBranchRef.name)
```

For a PR: `GH_PAGER=cat gh pr diff <number>`. You MAY ask the user only when
none of that finds anything.

Target is a branch or a PR? You MUST read
[getting-the-code.md](getting-the-code.md) now, for the worktree steps, the
user's own checkout and when running the code is allowed. Uncommitted changes in
the open repo need none of it.
