# agent-skills

Three skills that teach a coding agent to write like a person, review code, and
open a pull request.

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/oleg-chibikov/agent-skills/main/install.sh | sh -s -- --lang English
```

That is it. The script finds the agents on your machine and installs into all of
them: Claude Code, Codex, GitHub Copilot, Cursor and 80 more. Run it again any
time to update.

`--lang` is the language your code review comes back in. Put any language there:

```sh
... | sh -s -- --lang Russian
... | sh -s -- --lang Spanish
```

Comments meant for the PR stay English, because the whole team reads them.

Rather read the script before running it? Clone and run it yourself:

```sh
git clone https://github.com/oleg-chibikov/agent-skills.git
cd agent-skills
./install.sh --lang English
```

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

Run the install again with a different `--lang`. Or open
`~/.agents/skills/review/LANGUAGE.md` and put another language in it. That is
the one real copy, every other agent points at it.

## Remove them

```sh
curl -fsSL https://raw.githubusercontent.com/oleg-chibikov/agent-skills/main/install.sh | sh -s -- --uninstall
```

It lists the folders it is about to clear and asks before deleting.

## Other flags

| Flag | What it does |
| --- | --- |
| `--link` | Points the agents at this clone, so editing a rule here changes what they read. |
| `--vscode` | Turns the writing rules on for every Copilot answer in every workspace. |
| `--uninstall` | Removes the three skills from every agent folder. |
| `--yes` | Answers yes to the uninstall question. |

## Licence

MIT.
