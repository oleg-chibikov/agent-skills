# agent-skills

Three skills that teach a coding agent to write like a person, review code, and
open a pull request.

## Install

```sh
git clone https://github.com/oleg-chibikov/agent-skills.git
cd agent-skills
./install.sh --lang English
```

That is it. The script finds the agents on your machine and installs into all of
them: Claude Code, Codex, GitHub Copilot, Cursor and 80 more.

`--lang` is the language your code review comes back in. Put any language there:

```sh
./install.sh --lang Russian
./install.sh --lang Spanish
```

Comments meant for the PR stay English, because the whole team reads them.

## What you get

**`writing-style`** cleans up every line a person reads: chat, comments,
commits, PRs, docs, UI copy. Plain words, answer first, one idea per sentence,
no em dash, no AI filler.

**`review`** reads a PR, a branch or a diff and tells you what the change
solves, which order to read the files in, then each problem with the line
number, the input that breaks it and the fix. Every problem comes with a short
comment ready to paste on the line.

**`create-pr`** writes the PR description in three parts, problem, solution,
packages, then opens the PR with `gh`.

`review` and `create-pr` load `writing-style` first, so all three move together.

## Use it

Ask in plain words:

- "review this" and a PR link
- "open a PR for this branch"
- "rewrite this so it sounds human"

## Change the language later

Run `./install.sh --lang <language>` again. Or open
`skills/review/LANGUAGE.md`, it holds one word.

## Other flags

| Flag | What it does |
| --- | --- |
| `--link` | Points the agents at this clone, so editing a rule here changes what they read. |
| `--vscode` | Turns the writing rules on for every Copilot answer in every workspace. |

## Licence

MIT.
