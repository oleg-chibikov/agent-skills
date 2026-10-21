# What to look for

In this order of importance:

1. **Breaks for the user**: wrong result, crash, data loss, lost input, stuck
   spinner, a forgotten case (empty list, no network, slow reply, two clicks in
   a row). Then the machine it runs on: a tool missing, a GUI app's short
   `PATH`, Linux, a detached HEAD.
2. **Security**: anything from the OWASP Top 10. Unescaped user input, secrets
   in code or logs, a missing permission check, an open redirect, a query built
   by string concatenation.
3. **Money and speed**: work repeated in a loop, a request per item, a file read
   on every render, an unbounded list held in memory.
4. **Will bite later**: a silent `catch`, a `TODO` that hides a known bug, two
   sources of truth for the same value. A comment, a doc line or the PR
   description the code now contradicts. A test that cannot fail, named by the
   one-character edit it lets through: `|| exit 0` turned into `&& exit 0`.
5. **Already written somewhere**, does the repo or a dependency do this today.
6. **Style**. It MUST NOT be flagged unless the repo asks for it in writing.

You MUST read [already-written.md](already-written.md) at this step for 5. It
runs on every review.

Whether the design fits the task MUST NOT be judged here. That is the second
round, [architecture-pass.md](architecture-pass.md), and it runs once this
report is on screen.

A file that is fine MUST be named as fine. Silence reads as "not reviewed". It
goes in the one "Clean:" line under the findings table.

## Skip what is already said

On a PR, read the open threads and the checks once, before the first finding:

```sh
GH_PAGER=cat gh api repos/OWNER/REPO/pulls/<number>/comments \
  --jq '.[] | "\(.path):\(.line) \(.body[0:80])"'
GH_PAGER=cat gh pr view <number> --json reviews,comments,statusCheckRollup
```

- **Raised by someone else**: a finding a thread or a review already has MUST
  NOT go in.
- **Caught by a check**: a finding a failing lint, typecheck or test already
  reports MUST NOT go in. The summary MAY name the failing check in one line.
- Check names and states are enough. Logs SHOULD stay closed.

## Try to knock each finding down

Before a finding goes in, give it one look for the reason it is wrong: a guard
in the caller, a type that rules the case out, a test that covers it, a config
that turns it off.

- One look per finding: a file already open or one search.
- A run, a dependency's source or another repo MAY come in only as the last
  resort, when the finding stands or falls on it. One command on stubs, no
  network, no writes to the repo. Its marker reads `(ran it)`.
- **Knocked down**: the finding MUST go.
- **Can't tell**: keep it, marked as not proven.

Each finding SHOULD be worked out from the diff and the files around it, no
further. A finding you can't pin down stays in, marked for what it is. The deep
dive is where the digging happens, on the ones the user picks.
