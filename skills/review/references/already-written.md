# Already written somewhere

You MUST read this at the "look for what matters" step, on every review. It runs
even when every line is correct.

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
