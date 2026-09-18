# Getting the code onto disk

Read this when the review target is a branch or a PR, before you write anything.

## Checking out the branch

Start from the diff: `GH_PAGER=cat gh pr diff <number>` or `git diff`. It
settles most findings on its own and costs nothing to fetch.

Check out the branch only when the diff leaves a real gap it can't close: a
caller, a type or a config file the diff doesn't show, or a finding whose
answer needs a run. The open workspace is the same repository as the code under
review, and files on disk beat grepping a diff for that.

It goes in a separate worktree, so the user's checkout keeps whatever is in it:

1. Use the repo's own worktree skill when it has one. It carries the setup a
   fresh checkout needs, and its steps win over the ones below.
2. Otherwise: `git fetch origin <branch>` for a branch, or
   `git fetch origin pull/<number>/head:<branch>` for a PR, then
   `git worktree add ../<repo>-<branch> <branch>`.
3. Install only when you are about to run something in it, the way the repo's
   README says.
4. Read, and run if you must, inside that worktree. Leave the user's original
   checkout on the branch it was on, untouched.

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

Default to reading: it is faster, cheaper, and the reader can check it without
running anything themselves. Don't run the test suite or a typechecker to
double check a finding you already settled by reading. Run code only when one
finding's whole verdict hangs on a runtime answer reading can't give, a
compiler's exact error text or a library's behaviour on an odd input are the
usual reasons. At most a couple of runs in the whole review, never one per
finding. Run the smallest piece that answers it: one function on one input,
one test file, one file through the type checker. A full build, a full
install, a full typecheck or the whole test suite MUST NOT be run.

Stay read only: no commit, no push, no `git add`, no edits to the reviewed code
unless the user asked for them.
