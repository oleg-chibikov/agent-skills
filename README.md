# agent-skills

Three skills that teach a coding agent to write like a person, review code, and
open a pull request.

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/oleg-chibikov/agent-skills/main/install.sh | sh -s -- --lang English
```

One command, one folder on disk, a symlink from every agent that is installed on
your machine: Claude Code, Codex, Cursor, Copilot, Crush, Goose, Roo, Windsurf
and the rest. The writing rules also go where an agent reads them on every turn,
without being asked: the VS Code prompts folder, `~/.claude/CLAUDE.md`,
`~/.codex/AGENTS.md`. Run it again after you install a new agent, or to pick
another language.

`--lang` is the language your code review comes back in. Any language works:

```sh
... | sh -s -- --lang Russian
... | sh -s -- --lang 日本語
```

Comments meant for the PR MUST stay English, because the whole team reads them.

You MUST have `git` and any POSIX shell. `review` and `create-pr` read pull
requests through the GitHub CLI, so `gh` MUST be installed and logged in once
with `gh auth login`.

Rather read the script before running it? You MAY clone and run it yourself. The
clone becomes the folder every agent links to, so editing a rule there changes
what they read straight away:

```sh
git clone https://github.com/oleg-chibikov/agent-skills.git
cd agent-skills
./install.sh --lang English
```

## What you get

**`writing-style`** cleans up every line a person reads: chat, comments,
commits, PRs, docs, UI copy. Plain words, answer first, one idea per sentence,
no em dash, no AI filler. It also sets the shape: bullets instead of paragraphs,
the point of each one in bold at the front, nothing over three lines.

**`review`** reads a PR, a branch or a diff and tells you what the change
solves, which order to read the files in, then every problem in one table, then
each one with the line number, the input that breaks it and the fix. Every
problem comes with a short comment ready to paste on the line.

**`create-pr`** writes the PR description in three parts, problem, solution,
packages, then opens the PR with `gh`.

`review` and `create-pr` load `writing-style` first, so all three move together.

## What a review looks like

The review opens with a table, so the whole verdict fits on one screen:

| # | Severity | Where | What |
| --- | --- | --- | --- |
| 1 | Blocker | `SaveName.tsx:42` | the typed name is lost when the save is slow |
| 2 | Should fix | `profile.ts:88` | the save error is swallowed, so the page stays silent |
| 3 | Nit | `SaveName.tsx:20` | nothing reads the `isLoading` flag |

<details>
<summary>One finding out of that table</summary>

### 1. Blocker: the typed name is lost when the server is slow

[src/features/profile/SaveName.tsx:42](src/features/profile/SaveName.tsx#L42) · [in the PR](https://github.com/acme/shop/pull/7/files#diff-2f0b8aR42)

**The name field clears before the server answers, so a failed save loses what
the person typed. Clear it after the answer.**

- **Who hits it** a person opens Settings, types a new name and presses Save.
  Nothing else reaches this code.
- **Now** line 42 empties the field, then waits for the server:
  `setName(""); await saveName(name);`
- **Comes out** the server answers two seconds later, or fails. The field is
  already empty, so the typed name is neither on screen nor on the server, and
  no message appears. Walked the code with that input.
- **Costs** the person thinks it saved, leaves the page and loses the data. On a
  slow network this is every second try.

Fix, clear the field after the confirmation and leave the text alone on error:

```tsx
const saved = await saveName(name);
if (saved.ok) setName("");
```

**Comment on** line 42, added in this PR, the green side of the diff.

```markdown
this clears the input before saveName comes back - if the save fails the typed
name is gone. can we clear it after the call resolves ok?
```

</details>

Above the table: what the change solves in three bullets, and a tree of the
changed files with the order to read them in. Below it: the findings, then one
paste-ready comment for the PR.

## Use it

Ask in plain words:

- "review this" and a PR link
- "open a PR for this branch"
- "rewrite this so it sounds human"

## Change the language later

Run the install again with a different `--lang`, or open
`skills/review/LANGUAGE.md` in the folder the installer named and put another
language in it. There is one copy, every agent points at it.

## Remove them

```sh
curl -fsSL https://raw.githubusercontent.com/oleg-chibikov/agent-skills/main/install.sh | sh -s -- --uninstall
```

It lists the folders it is about to clear and asks before deleting. Your own
notes in `CLAUDE.md` and `AGENTS.md` stay, only the block the installer added
goes. `--yes` MAY be added to skip the question.

## Editing the skills

[AGENTS.md](AGENTS.md) holds the rules for every `.md` file here: the prose
budget under `skills/`, when a line earns a `MUST`, and what stays verbatim.
Check a file against the budget with:

```sh
python3 scripts/prose-lines.py skills/*/SKILL.md skills/*/references/*.md
```

## Licence

MIT.
