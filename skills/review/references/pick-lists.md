# Asking the user to pick from a list

You MUST read this before any list the user picks from: the deep dive offer and
the question about which comment version to post both use it.

A markdown checkbox, `- [ ]`, MUST NOT appear anywhere in the answer. VS Code
draws it as a box that nothing clicks, and the text behind the box falls onto
its own line.

## The host has a picker tool

A tool that asks the user to pick from a list, such as `AskUserQuestion` or the
VS Code question tool? You MUST call it, and the written out list below MUST
stay out of the answer.

- The question is one line: what the pick buys them.
- Several answers allowed, as in the deep dive? Picking several MUST be turned
  on. One answer only, as in the comment version? It MUST stay off.
- A choice MUST be plain text under about 60 characters, opening with its number
  where the list is numbered elsewhere.
- Markdown MUST stay out of a choice. Backticks, bold and a leading number with
  a dot all come back broken.

## No such tool

Write the list out, numbered, and say how to answer:

```markdown
Dig deeper? Answer with the numbers, or "all", and I'll trace the callers, walk
the code on a real input and count how often it happens.

1. Blocker: the typed name is lost when the save is slow
2. Should fix: the save error is swallowed
3. Nit: nothing reads the `isLoading` flag
4. All of them
```
