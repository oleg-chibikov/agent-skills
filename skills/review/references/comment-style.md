# Writing the comment that goes on the line

Read this before the first per-finding comment, and keep it in context until the
last one is written.

A colleague reads this text, so have the `writing-style` skill in context first
and run its final checklist over the comment before it goes in the answer.

It reads like a colleague typing in a hurry, not like a report. The long version
sits above it in the report language. Here you raise the doubt and ask.

**One sentence for the doubt, one for the ask, under 40 words.** Draft it, then
halve it. The first draft always explains twice as much as the author needs.

Write two blocks per finding, the drafted one and the halved one, so the user
picks. Both say the same thing, so the second reads as the first with the
explaining taken out.

The house style, copy its shape:

```markdown
will this actually get reported to the caller, or does it stay silent here?
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

- **Plain problem first, code second.** Say what goes wrong in words anyone on
  the team would follow, no matter the language. Bring in a name, a call or a
  snippet only when the plain sentence alone can't point at the spot, and never
  chain two of them to explain how one calls the other.
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
- **Name the case, not the theory.** Reach for a real input or snippet only once
  a plain sentence stops being enough to pin down the spot: one input, one
  snippet, inline, `parse<Row>(`, `parse("file.csv")()`. No fenced code inside
  the comment.
- **Offer the wording** for a message or a string, after "eg", in quotes.
- **Loose punctuation is fine**: a lowercase start, a hyphen where a comma would
  do, a missing backtick. Polishing it makes it read like a machine.
- Leave out headings, bold labels, bullet lists, a severity tag, a greeting, a
  sign off and thanks for the PR. Don't repeat the file name or the line number,
  the comment already sits there.

What the halving cuts, in this order:

- **The mechanism.** How the library or the language ends up doing this. Point
  at the spot and the author reads it themselves.
- **Why it looks fine today.** "it only works because the parent has a height"
  is your working out, not the ask.
- **The second option.** Offer one fix. Two read as thinking out loud.
- **Anything already in the finding above.** The user has it, the author doesn't
  need it to answer.

Too wordy, and the same comment halved:

```markdown
as far as I understand aspect-auto here doesn't cancel the variant's
group-data-[orientation=vertical]:aspect-square - tailwind-merge only dedupes
classes with the same modifier, and the variant selector wins on specificity.
it looks right only because flex-1 gives the tile a definite height. can we
write group-data-[orientation=vertical]/attachment:aspect-auto, or expose it as
a variant?
```

```markdown
I think aspect-auto doesn't cancel the variant's
group-data-[orientation=vertical]:aspect-square - different modifier, so both
survive. can we match the modifier here?
```

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
