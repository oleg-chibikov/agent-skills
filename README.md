# agent-skills

Three skills for coding agents: how to write, how to review code, how to open a
pull request.

They work in Claude Code, Codex, GitHub Copilot, Cursor and 80 more agents.

## The skills

| Skill | What it does |
| --- | --- |
| [`writing-style`](skills/writing-style/SKILL.md) | Rules for every line a person reads: chat, comments, commits, PRs, docs, UI copy. Plain words, answer first, one idea per sentence, no em dash, no AI filler. Ends with a checklist to run before sending. |
| [`review`](skills/review/SKILL.md) | Reviews a PR, a branch, a file or a pasted diff. Says what the change solves, the order to read the files in, then findings with line numbers, the input, the real output and the fix. Each finding ends with a short English comment ready to paste on the line. |
| [`create-pr`](skills/create-pr/SKILL.md) | Writes a PR description in three parts: problem, solution, what was picked and rejected. Then opens or updates the PR with `gh`. |

`review` and `create-pr` both load `writing-style` before they write anything,
so the three live in one repo and move together.

## Install

```sh
git clone https://github.com/oleg-chibikov/agent-skills.git
cd agent-skills
./install.sh
```

The script asks one question, the language, then hands the skills to
[`npx skills`](https://github.com/vercel-labs/skills). That CLI finds the agents
you have installed and puts the skills where each one looks for them.

Want no questions? Name the language up front:

```sh
./install.sh --lang Russian
```

### Options

| Flag | What it does |
| --- | --- |
| `--lang <language>` | Language for the long review text. Default English. |
| `--link` | Points the agent folders straight at this clone, so editing a file here changes what every agent reads. Use this if you plan to change the rules. |
| `--vscode` | Also links the writing rules into VS Code, so Copilot applies them to every answer in every workspace. |
| `-- <args>` | Everything after `--` goes to `npx skills add`, for example `-- --agent claude-code --yes`. |

### Without the script

`npx skills add oleg-chibikov/agent-skills` installs the same three skills
straight from GitHub. You get English, because the script is what writes the
language file.

## Language

The `review` skill writes two things at once:

- **The report**, the long text only you read. This is the language you pick at
  install. `install.sh` writes it into `skills/<name>/LANGUAGE.md`.
- **The comments for the PR**, the lines you paste on GitHub. These stay
  English, because the whole team reads them.

Change your mind later? Run `./install.sh --lang <language>` again, or edit
`skills/review/LANGUAGE.md` by hand. The file holds one word.

## Use

Say what you want in plain words and the agent picks the skill by its
description:

- "review this" and a PR link
- "open a PR for this branch"
- "rewrite this so it sounds human"

## Licence

MIT.
