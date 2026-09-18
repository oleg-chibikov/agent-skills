# Writing the Markdown in this repo

Rules for anything under `skills/`. An agent reads these files on every run, so
every line costs tokens on every run. The size caps are theirs alone, the rest
holds for `README.md` and the instructions file too. `install.sh` is outside
this.

## Structure

- `skills/<name>/SKILL.md` MUST hold the skill itself: frontmatter, then the
  steps in the order the agent does them.
- Detail needed in one branch of the work only SHOULD move to
  `skills/<name>/references/<topic>.md`, and SKILL.md MUST carry a line saying
  when to read it.
- `writing-style` owns every rule about words and layout. `review` and
  `create-pr` MUST load it and add only what is theirs. Other files MUST NOT
  copy a rule out of it.

## Size

Counted in prose lines. Fenced blocks and blank lines are free, because the
examples are the templates the agent copies.

| File | Prose lines |
| --- | --- |
| `SKILL.md` | 300 |
| a reference file | 60 |

```sh
python3 scripts/prose-lines.py skills/*/SKILL.md skills/*/references/*.md
```

Over the cap, a section SHOULD move to a reference file or go. Shrinking the
wording comes second.

## RFC 2119 words

Every rule MUST carry its own modal. No file MAY spend a line saying the words
keep their RFC 2119 meaning, the reader knows them.

- `MUST`, `MUST NOT`: breaking it ruins the output or the repo.
- `SHOULD`, `SHOULD NOT`: the default, and it breaks only with a reason stated
  in the answer.
- `MAY`: a real choice, both branches fine.
- A step, a description or an example takes no modal: "Write three bullets",
  "Sort by severity".
- One modal per sentence, and none inside an example block. Examples show, they
  don't legislate.

## Prose

- A rule SHOULD fit one line. Give the reason only where the agent gets it
  wrong without it.
- Three or more rules MUST go in a list.
- A section SHOULD stop at five bullets. Past that, split it under a heading.
- A rule MAY carry one example, and a Bad and Good pair beats an explanation.
- Articles and filler SHOULD go wherever the line still reads: "Read the repo
  rules first" beats "You should make sure to read the repo rules first".

## Verbatim regions

Fenced blocks, inline backticks and links are templates the agent copies.
Compressing or reformatting them changes the output. They MUST stay as they are
unless the edit is about them.

## Frontmatter

- `name` MUST match the folder.
- `description` MUST be one paragraph: when to use the skill, the words that
  trigger it, what comes out. It is all an agent sees before loading the file,
  so the trigger words matter more than the prose.

## Language

- The skills MUST be written in English.
- `LANGUAGE.md` next to a SKILL.md names the language its output comes back in.
  The installer writes that file. A SKILL.md MUST NOT name a language itself.

## Before you commit

1. `scripts/prose-lines.py` exits 0.
2. Every rule carries a modal, and no line explains what the modals mean.
3. Every `MUST` reads true as "breaking this ruins the output". The rest drop
   to `SHOULD` or lose the modal.
4. No rule copied out of `writing-style`.
5. Fenced blocks untouched unless the edit is about them.
6. The `writing-style` final checklist run over the prose.
