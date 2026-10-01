---
name: address-comments
description: 'Use when the user asks to address, fix, resolve, handle or go through review comments on a pull request, in any repository and in any language: "address the comments", "fix the PR feedback", "handle the review", "go through the threads", a PR link plus "comments". Makes one small commit per review thread with as little new code as it takes, then replies in each thread with the commit SHA and one sentence on how it was fixed.'
---

# Address review comments on a pull request

One thread, one commit, one reply. A thread is the reviewer's comment plus
every answer under it.

## 1. Get the PR and the branch

Every `gh` MUST carry the `GH_PAGER=cat` prefix, or it opens a pager and hangs.

The PR comes from the link the user gave, or from the current branch:

```bash
GH_PAGER=cat gh pr view <number-or-url> --json number,url,headRefName,baseRefName,author
GH_PAGER=cat gh api user -q .login   # who the user is in the threads
```

`OWNER` and `REPO` below come from the PR URL.

Before the first edit:

- The working tree MUST be clean. Not clean? Stop and name the files.
- Not on the PR branch? Run `gh pr checkout <number>`.
- Run `git pull --ff-only`. It fails? Stop and say so, a rebase is the user's
  call.

## 2. Fetch the threads

```bash
GH_PAGER=cat gh api graphql -F owner=OWNER -F repo=REPO -F number=N -f query='
query($owner: String!, $repo: String!, $number: Int!) {
  repository(owner: $owner, name: $repo) {
    pullRequest(number: $number) {
      reviewThreads(first: 100) {
        nodes {
          id isResolved isOutdated path line originalLine
          comments(first: 50) { nodes { author { login } body diffHunk url } }
        }
      }
    }
  }
}'
```

Keep the threads with `isResolved: false`.

Asks outside a thread count too: a review body, a comment in the PR
conversation. Read them with `gh pr view N --json comments,reviews`. Each ask
there is handled like a thread.

## 3. Read each thread to the end

The whole thread MUST be read before deciding anything. The last thing both
sides agreed on is the fix: the reviewer asked for X, the author offered Y, the
reviewer said fine, so the fix is Y.

Put each thread in one bucket:

- **Fix** the thread asks for a change, and nobody disputes it or the
  discussion settled it.
- **Answer** a question with nothing to change. Draft a reply, no commit.
- **Open** the author pushed back and the reviewer has not agreed, the ask is
  unclear, or it needs a redesign. No commit, no reply.
- **Done** the code already does what the thread asks, common on
  `isOutdated`. No commit, no reply.

The user's own last word in a thread SHOULD be taken as their decision. A "won't
fix" from them keeps the thread out of the work.

Write the plan in the chat before editing, one line per thread: `path:line`, the
ask in a few words, the bucket. Then start, without asking.

## 4. The smallest change that answers the thread

Work through the Fix threads in file order.

- The change MUST do what the thread asks and nothing else. No renames, no
  reformatting, no fixes to nearby code.
- Deleting SHOULD beat adding. Before writing a line, look for code the fix lets
  you remove, a helper the repo already has, or a language feature that does
  the job.
- A new function, file, type or abstraction MUST NOT appear unless the thread
  asks for one.
- A code comment explaining the fix MUST NOT go in. The reply carries the why.
- The fix spreads past the lines the thread points at, or into another module?
  Revert it, move the thread to Open and say why.

Read `git diff` before the commit. More lines added than removed? Look once
more for a shorter way, and keep the change if there is none.

Run the repo's fastest check over the touched files: typecheck, lint, the
tests next to them. The commands come from `package.json`, `AGENTS.md`,
`CONTRIBUTING.md` or the CI config. A failing check MUST be fixed in the same
commit, or the change reverted with `git checkout -- <files>` and the thread
moved to Open.

## 5. Commit

- Stage only the files of this fix with `git add <files>`. `git add -A` and
  `git add .` MUST NOT be used.
- The message SHOULD follow the repo convention from `git log --oneline -10`.
  No convention? One imperative line on what the code does now.
- A ticket prefix goes in when the branch's other commits carry one.
- Hooks MUST run. `--no-verify` and `--amend` MUST NOT be used.
- Note the short SHA: `git rev-parse --short HEAD`.

```text
Clear the name field after the save succeeds
PROJ-123: drop the unused formatDate wrapper
```

Threads asking for the same change MAY share one commit. Each still gets its
own reply.

## 6. Push, then reply

Push once every Fix thread has its commit. A rejected push MUST stop the run, a
force push is the user's call.

```bash
git push
```

Then one reply per thread, the body from a file so backticks survive:

```bash
GH_PAGER=cat gh api graphql -f threadId="$thread_id" -f body="$(cat reply.md)" -f query='
mutation($threadId: ID!, $body: String!) {
  addPullRequestReviewThreadReply(input: {pullRequestReviewThreadId: $threadId, body: $body}) {
    comment { url }
  }
}'
```

An ask from the PR conversation gets its reply there, quoting the line it
answers: `gh pr comment N --body-file reply.md`.

Resolving a thread MUST be left to the reviewer, unless the user asks for it.

## 7. The reply

You MUST load the `writing-style` skill before the first reply, unless it is in
context, and run its checklist over every reply.

- One line: the SHA, then one sentence on how the code works now.
- English, whatever language the chat is in. The team reads it.
- Line counts, "refactored", thanks and a greeting stay out.
- An Answer reply SHOULD stop at two sentences.

```markdown
Fixed in 3f2c1ab: the field clears only after saveName resolves ok.
```

```markdown
Fixed in 9d04e7c: dropped the wrapper, the callers use formatDate directly.
```

GitHub turns the short SHA into a link to the commit, so the reply carries no
URL.

## 8. Report back

One line per thread with the SHA and the reply URL. Then the Answer drafts,
unposted, for the user to send. Then the Open and Done threads, one line each
with the reason or the decision the user needs to make.

## Guardrails

- A force push, a rebase or an amend MUST NOT happen.
- Files outside the fix MUST be left alone, staged or not.
- A push to the default branch MUST NOT happen. Stop and say so.
- A thread MUST NOT be answered with a fix the code doesn't hold. Push first,
  reply second.
