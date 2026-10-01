# The second round: architectural gaps

The four parts are the bug hunt, line by line. This round asks the other
question: does the change have the right shape at all. It MUST run on every
review.

## When it runs

The whole first pass report MUST be on screen before this round starts, so the
user has the findings in hand while it runs. Then one line saying the second
round is starting, then the round, then the offer to post. Nothing goes on the
PR before it is done, since it can add findings that need a comment.

## What to ask

Start from the task: read the PR description, the linked issue and the tests,
and say in one sentence what the change has to achieve. Then ask:

- Does the design achieve all of it? Name the part it misses.
- What is missing around it: a new endpoint with no permission check, state
  nobody owns, an error path nothing handles, a migration with no way back.
- Is anything here for a problem the repo doesn't have: a flag with one value,
  an abstraction with one implementation, a field nothing reads? Say what it
  costs to carry.
- Is the work in the right place? A server check sitting in the browser, logic
  in a component every other screen will need, a package reaching into another
  package's internals.
- Would a plainer version do the same? Describe it in two or three sentences,
  with the file it lives in. Nothing plainer in mind? Say the shape is fine.
- Does it match how this repo does the same thing elsewhere? Link one existing
  example.

## What comes out

A finding here MUST carry a cost: what breaks, what gets slower, what the next
person has to read. "This could be cleaner" is not a finding.

Each one MUST take the shape [finding-shape.md](finding-shape.md) gives it, and
the numbers MUST carry on from the first pass. The round opens with its own
table, built the way [part-3-table.md](part-3-table.md) says, or with one line
saying the shape holds up and what carries it. Then its comments, then its
explanations, as [part-4-findings.md](part-4-findings.md) orders them.

A finding with no file and line to hang on goes in the explanations only, and
stays out of the posting.
