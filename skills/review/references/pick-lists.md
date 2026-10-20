# Asking the user to pick from a list

You MUST read this before offering the user a choice of comment version.

A markdown checkbox, `- [ ]`, MUST NOT appear anywhere in the answer. VS Code
draws it as a box that doesn't click, and the text behind the box falls onto
its own line.

## The host has a picker tool

A tool that asks the user to pick from a list, such as `AskUserQuestion` or the
VS Code question tool? You MUST call it, and the written out list below MUST
stay out of the answer.

- The question is one line: what the pick buys them.
- The question MUST allow one answer.
- A choice MUST be plain text under about 60 characters, opening with its number
  where the list is numbered elsewhere.
- Markdown MUST stay out of a choice. Backticks, bold and a leading number with
  a dot all come back broken.

## No such tool

Write the choices out, numbered, and say how to answer:

```markdown
Which comment version should I post?

1. Full version
2. Shorter version
3. Assertive version
4. Best fit per comment, mixed
5. Let me pick per comment
6. Skip posting
```

## One question per comment

For "Let me pick per comment", each question names the comment, and the choices
are the versions.

- The question SHOULD be the comment's tag and heading: `C1. Blocker: the typed
  name is lost`.
- The choices are `Full`, `Shorter` and `Assertive`, with the comment text in
  each choice's description field.
- No description field? The three texts go in the question's message field,
  and the choices stay bare.

No picker tool? Write each comment with its numbered versions, then one line on
how to answer:

```markdown
C1. Blocker: the typed name is lost when the server is slow

1. Full: this clears the input before saveName comes back ...
2. Shorter: clears the input before saveName comes back ...
3. Assertive: this clears the input before saveName comes back ...

Answer with one number per comment, like: C1 2, C2 1
```
