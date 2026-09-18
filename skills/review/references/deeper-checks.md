# The two checks past the bug hunt

You MUST read this at the "look for what matters" step, on every review. Both
run even when every line is correct.

## Wrong shape for the job

Start from the task: read the PR description, the linked issue and the tests,
and say in one sentence what the change has to achieve. Then ask:

- Does the design achieve all of it? Name the part it misses.
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

A finding here MUST carry a cost: what breaks, what gets slower, what the next
person has to read. "This could be cleaner" is not a finding.

## Already written somewhere

Before accepting a new helper, parser, formatter, date maths, deep clone, sort,
debounce, retry or validation:

- Grep the repo for the behaviour and the obvious names, including the shared
  packages folder and any internal utils package.
- Check `package.json` and the lockfile. The library may already be a
  dependency, paid for and used elsewhere.
- Check the platform: `Intl`, `structuredClone`, `URL`, `URLSearchParams`,
  `AbortController`, `Object.groupBy`, `toSorted`. Honour the repo's baseline
  rule.

The finding MUST name the exact replacement: the file and export with a link, or
the package and function. "Probably something in lodash" is not a finding. Say
how many lines go away, how many copies the repo stops carrying, and why a copy
is a risk: the two versions drift, and a bug fixed in one stays in the other.

A dependency the repo lacks MUST stay a question: say what it weighs, let the
author decide. The duplicate is simpler than the shared one, or the shared one
drags in something heavy? Say that and leave the code alone.
