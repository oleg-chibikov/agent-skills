# Writing the comment that goes on the line

Read this before the first per-finding comment, and keep it in context until the
last one is written.

A colleague reads this text, so have the `writing-style` skill in context first
and run its final checklist over the comment before it goes in the answer.

It reads like a colleague typing in a hurry, not like a report. The long version
sits above it in the report language. Here you raise the doubt and ask.
**One or two sentences. Three at the very most.**

The house style, copy its shape:

```markdown
will this be reported in report() that is called from collectResults()?
```

```markdown
I think there are no tests for this function. could we cover it?
```

```markdown
this seems to be unused. Can we add tests that would leverage it?
```

```markdown
not sure which readme is meant here
```

```markdown
as far as I understand it won't capture parse( if it exists in a nested file or
maybe if it uses parse<Row>( - can we either add them to search or reflect in
the comment?
```

```markdown
what if the code is export const rows = parse("file.csv")(); - it's already in
the const, but it's the result of the call there, not the parse. Can we rewrite
the message to reflect that? eg "Every `parse()` call must be held by its own
`const`, which is how the importer finds it."
```

```markdown
nit: JSdoc would be better for the property description
```

What that style is made of, all of it required:

- **Ask, don't state.** Most comments are a question: "will this ...?", "could
  we ...?". A blocker still says plainly that it breaks.
- **Hedge what you guessed, not what you checked.** Grepped or read it: say it
  flat, "the shared config already sets `restoreMocks: true`". Worked it out in
  your head: "I think", "as far as I understand", once, at the front. Didn't
  look: ask, "not sure which readme is meant here". A hedge on a verified fact
  gets waved away, and a flat claim you guessed at gets you corrected.
- **Bound the claim instead of going vague.** "from what I see", "I only looked
  at the resolver". Don't lecture the author on the area they work in daily.
  Hand a call that is theirs back as a question.
- **Point, don't argue.** A file and line, a link, a screenshot beats a
  paragraph of reasoning.
- **`nit: ` on anything that only makes the code nicer**: formatting, a name, a
  shorter way to write the same thing. Give the replacement bare.
- **Skip the impact paragraph and the evidence.** Leave out "so the user loses
  data", counts, tool output and "I ran X over Y". That stays in the finding.
- **Name the case, not the theory.** One input, one snippet, inline:
  `parse<Row>(`, `parse("file.csv")()`. No fenced code inside the comment.
- **Offer the wording** for a message or a string, after "eg", in quotes.
- **Loose punctuation is fine**: a lowercase start, a hyphen where a comma would
  do, a missing backtick. Polishing it makes it read like a machine.
- Leave out headings, bold labels, bullet lists, a severity tag, a greeting, a
  sign off and thanks for the PR. Don't repeat the file name or the line number,
  the comment already sits there.

Bad, and why:

```markdown
This clears the input before `saveName` answers, so a slow or failed save wipes
the name the person typed and shows them nothing. They think it saved. Could
you clear it after the call comes back ok, and leave the text alone on error?
```

Three sentences explaining the damage to the person who wrote the code. Cut to
the doubt and the ask:

```markdown
this clears the input before saveName comes back - if the save fails the typed
name is gone. can we clear it after the call resolves ok?
```
