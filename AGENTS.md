# Writing the skills in this repo

Rules for anything under `skills/`. An agent reads these files on every run, so
every line costs tokens on every run. `README.md` and `install.sh` are outside
this.

## Structure

- `skills/<name>/SKILL.md` holds the skill: frontmatter, then the steps in the
  order the agent does them.
- Detail needed in one branch of the work only goes in
  `skills/<name>/references/<topic>.md`, with a line in SKILL.md saying when to
  read it.
- `writing-style` owns every rule about words and layout. `review` and
  `create-pr` load it and add only what is theirs. A rule copied out of it is a
  bug.

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

Over the cap: move a section to a reference file, or cut it. Shrinking the
wording comes second.

## RFC 2119 words

Declare them once at the top of the file, then:

- Plain imperative is the default: "Write three bullets", "Sort by severity".
  Most lines need no modal.
- `MUST`, `MUST NOT`: breaking it ruins the output or the repo. About one per 20
  lines. Past that none of them read as loud.
- `SHOULD`, `SHOULD NOT`: the default, breakable with a reason stated in the
  answer.
- `MAY`: a real choice, both branches fine.
- One modal per sentence, and none inside an example block. Examples show, they
  don't legislate.

## Prose

- A rule is one line. Give the reason only where the agent gets it wrong
  without it.
- Three or more rules go in a list.
- Five bullets to a section. Past that, split under a heading.
- One example per rule, and a Bad and Good pair instead of an explanation.
- Drop articles and filler wherever the line still reads: "Read the repo rules
  first", not "You should make sure to read the repo rules first".

## Verbatim regions

Fenced blocks, inline backticks and links are templates the agent copies.
Compressing or reformatting them changes the output. Leave them as they are
unless the edit is about them.

## Frontmatter

- `name` matches the folder.
- `description` is one paragraph: when to use the skill, the words that trigger
  it, what comes out. It is all an agent sees before loading the file, so the
  trigger words matter more than the prose.

## Language

- The skills are written in English.
- `LANGUAGE.md` next to a SKILL.md names the language its output comes back in.
  The installer writes that file. Don't put a language in SKILL.md.

## Before you commit

1. `scripts/prose-lines.py` exits 0.
2. Every `MUST` reads true as "breaking this ruins the output". The rest become
   imperatives.
3. No rule copied out of `writing-style`.
4. Fenced blocks untouched unless the edit is about them.
5. The `writing-style` final checklist run over the prose.
