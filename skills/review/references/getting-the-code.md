# Getting the code onto disk

Read this when the review target is a branch or a PR, before you write anything.

## Checking out the branch

The open workspace is the same repository as the code under review? Get that
branch onto disk first, run or no run. Files on disk beat a diff: you can open
the callers, grep the repo and jump to definitions.

It goes in a separate worktree, so the user's checkout keeps whatever is in it:

1. Use the repo's own worktree skill when it has one. It carries the setup a
   fresh checkout needs, and its steps win over the ones below.
2. Otherwise: `git fetch origin <branch>` for a branch, or
   `git fetch origin pull/<number>/head:<branch>` for a PR, then
   `git worktree add ../<repo>-<branch> <branch>`.
3. Install if the branch needs it, the way the repo's README says.
4. Read and run inside that worktree. Leave the user's original checkout on the
   branch it was on, untouched.

A worktree is impossible? Then, and only then, you MAY switch in place.
`git status --short` MUST come back empty. Any output at all, and you stop and
ask the user what to do with it. Don't stash, reset, or check out over someone's
unsaved work. Then `GH_PAGER=cat gh pr checkout <number>` or
`git switch <branch>`.

Leave the reviewed branch checked out when the review ends. Don't switch back.
The answer says where the code sits: the worktree path, or the branch name when
you switched in place.

The code lives in a repository that is not open here? Review from
`GH_PAGER=cat gh pr diff <number>`, say once that you are reading the diff
alone, and mark every finding you could not prove.

## Running code

Most reviews need no run. Reading settles the question, and an answer you got by
reading is faster and easier to check. Run the code only where reading leaves
you unsure and the finding depends on the answer. Run the smallest piece that
answers it: one function on one input, one test file. A full build or the whole
suite SHOULD NOT be run.

Stay read only: no commit, no push, no `git add`, no edits to the reviewed code
unless the user asked for them.
