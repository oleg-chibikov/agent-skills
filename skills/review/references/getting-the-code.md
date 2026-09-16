# Getting the code onto disk

Read this when the review target is a branch or a PR, before you write anything.

## Checking out the branch

The open workspace is the same repository as the code under review? Then you
MUST get that branch onto disk before you write the review, run or no run.
Files on disk beat a diff: you can open the callers, grep the repo and jump to
definitions.

You MUST put it in a separate worktree, so the user's checkout keeps whatever is
in it:

1. Use the repo's own worktree skill when it has one. It carries the setup the
   fresh checkout needs, and its steps win over the ones below.
2. Otherwise: `git fetch origin <branch>` for a branch, or
   `git fetch origin pull/<number>/head:<branch>` for a PR, then
   `git worktree add ../<repo>-<branch> <branch>`.
3. Install if the branch needs it, the way the repo's README says.
4. You MUST read and run inside that worktree, and you MUST leave the user's
   original checkout on the branch it was on, untouched.

A worktree is impossible? Then, and only then, you MAY switch in place:
`git status --short` MUST come back empty, any output at all means you stop and
ask the user what to do with it, and you MUST NOT stash, reset, or check out
over someone's unsaved work. Then
`GH_PAGER=cat gh pr checkout <number>` or `git switch <branch>`.

The branch MUST still be checked out when the review ends. You MUST NOT switch
back. The answer MUST say where the code sits: the worktree path, or the branch
name when you switched in place.

The code under review lives in a repository that is not open here? You MUST
review from `GH_PAGER=cat gh pr diff <number>`, say once that you are reading
the diff alone, and mark every finding you could not prove.

## Running code

Most reviews need no run. Reading settles the question, and an answer you got by
reading is faster and easier to check. You MUST run the code only when reading
leaves you unsure and the finding depends on the answer. You MUST run the
smallest piece that answers the question: one function on one input, one test
file. You SHOULD NOT run a full build or the whole suite.

You MUST stay read only: no commit, no push, no `git add`, no edits to the
reviewed code unless the user asked for them.
