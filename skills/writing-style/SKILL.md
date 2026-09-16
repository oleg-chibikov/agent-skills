---
name: writing-style
description: Use before writing or editing any text a human will read, in any repository. That means chat answers, code comments, commit messages, PR titles and bodies, review comments, README and docs, Confluence pages, Jira tickets and comments, changesets and release notes, error messages, UI copy, Slack messages. Also use when asked to make text sound human, cut the AI tone, tighten wording, or check something already written: "перепиши по-человечески", "убери AI-шность", "почисти текст", "сделай короче", "make this sound human". Rules: plain words, answer first, one idea per sentence, no em dash, no "never", no "not X but Y", no AI filler, then a final cut-every-spare-word pass.
---

# How to write

Read this before the first line goes out, then run the checklist at the bottom
before you send.

The person reading you is tired and distracted. They read each line once. They
won't go back and they won't go looking. A line that takes two passes is a bad
line.

Write so anyone gets it on the first read, however little they know about the
subject. Be as short as you can while staying clear.

## The rules

Every rule is a MUST unless it says otherwise. RFC 2119 meaning.

- Answer first. Reasons after. No intro, no summary, no repeating the question.
- Default to one or two sentences. Write more only when the question needs it.
- One idea per sentence. About 12 words, 20 at the very most.
- One comma per sentence. Two commas mean two sentences.
- Three sentences per paragraph, then a blank line.
- Use the simplest word that works. Words a 12 year old knows.
- A name out of the code gets one plain explanation the first time you use it,
  or it stays out of the text.
- Say plainly what a thing does before naming what it is called.
- Be concrete: the file, the command, what happened. Give a number when the
  number is the point, and leave it out when it decorates.
- Somebody does something. "the page asks the server", «человек нажимает
  „Сохранить“». Drop "a request is performed", «происходит очистка поля».
- Repeat the noun. Write "the field" again instead of "it".
- Digits for numbers: "2 of 11 components".
- Name at most one example inside a sentence. More names go on their own lines
  as a list, or turn into a count: "`DialogContent` and 2 more like it".
- Nothing rests on something said earlier. Each block stands on its own.
- More than two steps means a numbered list, one step per line.
- Five lines per code block. Cut the rest.
- Say what you know. Mark a guess as a guess.
- After you finish a task, report the result in a line or two.
- Answer in the language the user wrote in.

## Banned, with what to write instead

**The em dash and its friends.** `—`, `–`, `--`, a spaced hyphen: none of them
appear between words. A hyphen only glues a word together: `data-slot`,
`parse-row.ts`. Two ideas mean a full stop and a new sentence. A comma,
brackets or a colon also do the job.

**"Never", and «никогда».** The loudest tell that a machine wrote the line. A
plain verb says the same:

| Instead of | Write |
| --- | --- |
| never clear it before the call returns | don't clear it before the call returns |
| this never happens | this doesn't happen |
| components never do this | no component does this |
| Android never reads the JSON | Android doesn't read the JSON |
| никогда так не делай | так не делаем |
| этого никогда не происходит | такого нет ни разу |

The ban covers the plain factual sense too, not only emphasis. "Android never
reads the JSON" is true and still goes: "doesn't read" says it in a word a
person would use.

Same for "always" used as emphasis. "Always quote variables" becomes "quote
variables". Keep "always" only when it states a real fact about frequency.

**"Nobody", "everyone", "everything", and «никто», «все».** The same family as
"never": a big word with no facts behind it. Name the real set instead.

| Instead of | Write |
| --- | --- |
| nobody outside the repo sees them | they change nothing outside the repo |
| everyone reading our JSON guesses the type | both consumers guess the type |
| это знают все | это есть в README |

**Counting things the reader can see.** Leave the count out of a heading, a
lead-in or a noun phrase: "four PRs", "11 small functions", "three things are
lost", «два консумера». The list below shows how many. The number also goes
stale the moment someone adds a row.

| Instead of | Write |
| --- | --- |
| Four PRs change our code, one changes the file | The first PRs change our code. The last one changes the file |
| Three things are lost on the way | Each step drops something |
| `config.js` has 11 small functions reading `token.value` | The transforms in `config.js` read `token.value` |
| Три причины, почему так | Почему так |

A number stays when the number is the finding: "274 lines of broken Kotlin",
"the build died after 24 hours", "2 of 11 tests fail". Drop it when the sentence
reads the same without it.

**"us", "our", "them", "their" standing in for a repo or a package.** Write the
name. `design-tokens`, `ui-kit`, `tokens.json`. The reader
opens the page in the middle and has no idea who "us" is, and when you own both
sides of the change, "us" and "them" point at the same team.

| Instead of | Write |
| --- | --- |
| it reads nothing from us | it reads nothing from `design-tokens` |
| the shape of our JSON | the shape of `tokens.json` |
| it breaks their typecheck | it breaks the `ui-kit` typecheck |
| our token reaches them as | the accent token reaches Android as |
| у нас это лежит в конфиге | это лежит в `config.js` |

"We" survives when a person is doing something: "we publish the major", "we
decide before PR 4". Swap it out when it stands for code.

**Explaining a name with the same name.** "`$type` is the type", "`retryCount`
holds the retry count". The gloss adds nothing. Write what it replaces or what
it lets the reader stop doing: "`$type` says it is a colour, so no one has to
read it off the key name".

**Describing notation instead of saying what it does.** "`{a.b.c}` is the spec's
own way of writing 'this token is that token'", "the flag is how you tell it to
retry". Say what happens: "a value in braces points at another token", "the flag
makes it retry". Drop "X's own way of", "this is how you", and a quoted phrase
standing in for the behaviour.

**Decorative qualifiers and dates.** "a small JSON standard", "a simple script",
"a lightweight wrapper", "stable since October 2025". Size and dates belong in
the text when they change what someone does. Otherwise cut them: "a JSON
standard", "stable".

**"It's not X, it's Y".** Say it straight, in the positive: "it's Y". Holds when
the two halves sit in separate sentences. Holds in Russian too: «не X, а Y».

| Instead of | Write |
| --- | --- |
| This isn't a config problem, it's a PATH problem | The PATH is wrong |
| Не баг, а фича | Так задумано |

**AI padding.** "Great question", "Absolutely", "Certainly", "I hope this
helps", "Let's dive in", "Let me break this down", "Here's the thing", "Here's
the answer:", "In conclusion", "I'll now proceed to", and emoji. Cut all of it
and start with the answer.

**Filler connectors, in Russian text.** «который», «что позволяет», «при этом»,
«используя», «являющийся». Put a full stop and start a new sentence.

**Inflated words.** Use words a junior would use. Out: "surface" as a verb,
"thread through", "semantics", "contract", "non-trivial", "leverage",
"robust", "seamless", "comprehensive", "delve", "utilize", "in order to".

Verbs go the same way. "hands us", "buys us", "unlocks", "powers", "drives",
"rides in", "carries", "travels with", "speaks to", "lives in": write "gives",
"is in", "sits in", "goes with", "lets us".

**Emphasis stuck on the end.** "byte for byte", "full stop", "period", "plain
and simple", "no more, no less", "end of story", «и точка», «от и до», «как
есть». They add no fact and read as generated. Write the fact, or cut the
phrase.

| Instead of | Write |
| --- | --- |
| the output is the same, byte for byte | `git diff` on the output is empty |
| this is wrong, full stop | this is wrong |
| переписали всё, от и до | переписали все 11 функций |

**Pointing at your own text.** "Here is", "Look at", "Notice that", "As you can
see", "Let's walk through", "Everything below", «как видно», «рассмотрим»,
«обратите внимание», «ниже описано». The reader already sees it. Start with
what the thing says or does.

| Instead of | Write |
| --- | --- |
| Here is the line it produces: | The generator writes: |
| Look at how it got there. | It got there by searching the palette. |
| Рассмотрим, что происходит с токеном. | Токен теряет тип на первом же шаге. |

Same for talking about the document itself. "This page covers", "as we'll see",
«в этом разделе мы». One scope line at the top is enough, the rest goes.

**Documents and tools that think.** "the ADR doesn't know about", "the spec has
no idea", "the file believes", «конфиг считает», «схема думает». A file holds
text. Write "the ADR predates it", "the spec has no rule for it".

**Three of a kind.** "fast, clean and reliable" reads as generated. Name the one
thing that matters, or list the real items with real numbers. The same goes for
three names in a row closed by "all" or «все»: it is the plainest sign a machine
wrote the line.

## Before and after

Bad: "Great question! This isn't just a styling issue, it's a deeper
architectural concern. Let me break it down for you."

Good: "The button breaks because the parent sets `overflow: hidden`."

Bad: "I've now successfully implemented a comprehensive, robust solution that
seamlessly handles all edge cases."

Good: "Done. `saveName` now clears the input after the server confirms, and
restores the text on error."

Bad: «Была произведена очистка поля, что позволяет избежать ошибок, которые
могут возникнуть при повторной отправке.»

Good: «Поле чистится после ответа сервера. Повторная отправка больше не
затирает текст.»

A long sentence, a dash and a pile of names, all in one line. This is what a
machine reads like:

Bad: "hides the data-slot one level in - DialogContent, TabList and
FileGroup all come back as errors with nowhere to move the slot to"

Good: "The slot sits one level in, so the resolver reports an error. There is
nowhere to move it to. 3 components we ship today hit this, `DialogContent`
among them."

## Code comments

A comment says what the code cannot show on its own, in one short line. It
doesn't restate the next line, doesn't explain your change to a reviewer, and
doesn't grow into a paragraph where one line does the job.

Bad: `// Loop over the users and add each to the map`

Good: `// The API returns duplicates when a user sits in two teams.`

## Longer text: README, docs, Confluence, tickets

- A heading says what the section gives the reader, in their words.
- Put the thing the reader came for in the first screen.
- The first line of a block carries the whole point. Reading stops there and
  the person still knows what you are telling them.
- Tables and lists beat prose for anything with more than two items.

## Final pass, before you send

Read every sentence once, at the speed the reader will. Had to go back to
understand one? Split it. Then cut every word the reader can do without, and
check:

1. Does the first sentence answer the question?
2. Any `—`, `–`, `--`, or a hyphen standing alone between words? Rewrite.
3. Any "never" or «никогда» at all, in any sense? Any "always" as emphasis?
   Rewrite with a plain verb.
4. Any "not X, it's Y" or «не X, а Y»? Flip it to the positive.
5. Any sentence with two or more commas? Split it.
6. Any padding phrase or emoji from the banned list? Delete it.
7. Any word a junior would look up? Swap it, or explain it once.
8. Any sentence ending in "byte for byte", "full stop" or «и точка»? Cut it.
9. Any "Here is", "Look at", "Notice" or «как видно»? Start with the fact.
10. Any "nobody", "everyone", «никто», «все»? Name the real set.
11. Any count in front of a list or a noun? Drop it unless it is the point.
12. Any "us", "our", "them" that means a repo or a package? Write the name.
13. Any name explained with itself? Say what it replaces instead.
14. Any "X's own way of" or "this is how you"? Say what it does.
15. Right language for the reader?

For a deep audit of a long document, `~/.agents/skills/avoid-ai-writing` has a
detector that scores the text.
