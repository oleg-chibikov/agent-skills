# The shape of a finding

Someone in a hurry reads it on a line in GitHub. Four `####` blocks MUST sit
between the opening line and the fix, about 25 lines in total including the
code. Anything that does not fit gets cut.

A nit MUST skip this shape: the heading, the link, and one line saying what and
where, fix inline if it's short. No four blocks, no separate fix block.

````markdown
### 1. Blocker: the typed name is lost when the server is slow

[src/features/profile/SaveName.tsx:42](src/features/profile/SaveName.tsx#L42) · [in the PR](https://github.com/acme/shop/pull/7/files#diff-2f0b8aR42)

**The name field clears before the server answers, so a failed save loses what
the person typed. Clear it after the answer.**

#### Who hits it

A person opens Settings, types a new name and presses Save. Nothing else reaches
this code.

#### Now

Line 42 empties the field, then waits for the server:
`setName(""); await saveName(name);`

#### Comes out

The server answers two seconds later, or fails. The field is already empty, so
the typed name is neither on screen nor on the server, and no message appears.
(read the diff)

#### Costs

The person thinks it saved, leaves the page and loses the data. On a slow
network this is every second try.

Fix, clear the field after the confirmation and leave the text alone on error:

```tsx
const saved = await saveName(name);
if (saved.ok) setName("");
```

**Comment on** [src/features/profile/SaveName.tsx:42](src/features/profile/SaveName.tsx#L42) · [in the PR](https://github.com/acme/shop/pull/7/files#diff-2f0b8aR42),
line 42, added in this PR, the green side of the diff.

```markdown
this clears the input before saveName comes back - if the save fails the typed
name is gone. can we clear it after the call resolves ok?
```

Shorter:

```markdown
clears the input before saveName comes back, so a failed save loses the name.
clear it after it resolves ok?
```
````

## Part by part

- **Heading**: severity, then the symptom a person could see, not the cause or
  the file name.
- **Link**: it MUST sit right under the heading, both halves, every time:

  ```markdown
  [path/to/file.ts:42](path/to/file.ts#L42) · [in the PR](https://github.com/OWNER/REPO/pull/7/files#diff-HASHR42)
  ```

  The visible text MUST end in `:42`, so the line shows without hovering.
  Writing `[path/to/file.ts](path/to/file.ts#L42)` puts the number in the
  target, where the reader doesn't see it, that's the mistake to avoid. Path is
  workspace relative, no backticks. The second half MUST be built the way
  [pr-links.md](pr-links.md) says, on every finding when the target is a PR.

- **The opening line**, bold, under the link: what breaks, then what to do.
  Someone who reads only this line MUST know what is wrong.
- **Who hits it**: the steps in the product, in order, from something a person
  sees. Reachable only from a test? Say so.
- **Now**: what the code does, one sentence, with the line in backticks. Over
  three lines of code, it moves to its own fenced block.
- **Comes out**: the actual value, quoted, not a summary, then the evidence
  marker in brackets. A finding without a concrete outcome and a marker MUST
  NOT be sent.
- **Costs**: what the person or the business loses, and how often. No count
  until the deep dive has grepped one? Say what it turns on instead.
- **Fix**: one line of words, then the code, up to roughly ten lines. Unsure?
  Give the idea and name what needs checking.
- **Comment on**: the line above the comment block, same two-link shape, and
  whether the line is in the diff.
- **Comment for the PR**: it MUST be there on every finding, nits included. Two
  blocks, the second under a bare `Shorter:` line, saying the same thing with
  the explaining cut out. The user picks one.

Those headings MUST come in that order with nothing added. A fifth one means two
findings.

## The two files that finish a finding

- Reviewing a GitHub PR, or landing a comment on a line the diff does not touch?
  You MUST read [pr-links.md](pr-links.md) before the first link.
- You MUST read [comment-style.md](comment-style.md) before the first comment
  block, and keep it in context until the last one is done. One sentence of
  doubt and one ask, under 40 words, then the same thing halved as a second
  block. No headings, no fenced code.
