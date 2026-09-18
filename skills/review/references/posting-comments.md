# Posting the comments to the PR

You MUST read this when the user asks for the comments to go on the PR, and keep
it in context until the last call returns.

Reviewing a branch, a pasted diff or uncommitted work, with no PR behind it? Say
so in one line and stop.

## Ask which version first

The long comment block and the one under `Shorter:` say the same thing, so the
user picks, and the pick MUST NOT be guessed. One question before any call, two
plain choices plus "skip", put on screen the way
[pick-lists.md](pick-lists.md) says. The answer holds for every comment in the
review.

## One comment per finding, on its own line

Each comment MUST be posted on its own, as a standalone thread on the file and
line the finding's "Comment on" line names. Bundling several into one review
body loses the line each one belongs to.

The head SHA and the body go in as files, since a body carries newlines and
backticks that a shell argument mangles:

```sh
sha=$(GH_PAGER=cat gh pr view <number> --json headRefOid -q .headRefOid)
GH_PAGER=cat gh api repos/OWNER/REPO/pulls/<number>/comments \
  -f commit_id="$sha" \
  -f path='src/features/profile/SaveName.tsx' \
  -F line=42 -f side=RIGHT \
  -f body="$(cat comment-1.md)"
```

`side` is `RIGHT` for an added line and `LEFT` for a removed one. A comment over
a range takes `start_line` on the same side.

Only the line comments go up. Approving or requesting changes is the user's
call, which only an explicit ask in this conversation MAY do.

The call fails on `line must be part of the diff`? That line is untouched, so
move that one comment to the nearest changed line and open it with the real
location, the way [pr-links.md](pr-links.md) says. The other comments go up
unchanged.

## Before the call

- Every body MUST be English, with none of the report language left in it.
- One body per finding, the picked version alone, `nit: ` in front where it
  belongs.
- Fenced code, evidence markers, counts and the impact paragraph MUST stay out.
  They live in the finding.
- `path` and `line` MUST come from that finding's "Comment on" line, with the
  path spelled the way the repository spells it, taken from the diff.

## After the call

Print one line per comment, `file:line` and its first few words, with the URL the
call returned. A comment that failed MUST be named with the reason.
