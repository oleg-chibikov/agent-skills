# Part 4: the findings

They follow under the table, in the same `## Findings` section, one `###`
heading each. Sort by severity and number them, and the numbers MUST match the
table. Three levels: blocker, should fix, nit, written in the report language.

[finding-shape.md](finding-shape.md) holds the blocks a finding is built from
and the full example. You MUST read it before writing the first finding.

## Picking the severity

The size of the fix says nothing about the severity, and a nit tells the author
to ignore it. So:

- **Nit**: the code behaves the same either way and nothing rots in a year.
  Formatting, a name, a shorter way to write the same expression.
- **Should fix**: anything that can silently drift or mislead later, even when
  the fix is one line. Duplication, code nothing calls, a path with no test, a
  comment that says what the code does not do, a swallowed error, a value
  hardcoded twice, a third party's token where the project has its own.
- Torn between two levels? The higher one MUST win, and the repo's own scale
  beats both when it has one.

## Carry one real case through the whole finding

The reader knows nothing about this code and will not go looking. The example,
the numbers and the fix all MUST sit in the finding.

A finding about the code in general reads as fog. One real case out of the repo,
rather than an invented `Foo`, MUST run from "Who hits it" to the fix:

- Say what the thing is before naming it: "`parseRow` reads one row of the
  uploaded file." One explanation, then the name alone.
- Show the value going in and the value coming out, quoted.
- Say what the result tells the reader, and what it leaves out, in the reader's
  own words: "the page says 40 rows imported, and says nowhere that two came
  out shifted."
- Close it with how you know, in brackets: `(read the diff)` on the first pass,
  `(walked the code with that input)` or `(ran it)` after the deep dive.
- Then how often it happens, once the deep dive has counted it.

```markdown
#### Who hits it

`parseRow` reads one row of the uploaded file. This file has a row with a comma
inside quotes: `12,"Smith, John",ok`.

#### Comes out

`{ id: "12", name: "\"Smith", status: " John\"" }`. The name is cut in two and
the status swallowed the second half. The page says 40 rows imported, and says
nowhere that two of them are broken. (read the diff)
```
