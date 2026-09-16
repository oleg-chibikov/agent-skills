# agent-skills

Three skills for coding agents: how to write, how to review code, how to open a
pull request.

They work in Claude Code, GitHub Copilot in VS Code, Cursor and anything else
that reads a `SKILL.md`.

## The skills

| Skill | What it does |
| --- | --- |
| [`writing-style`](skills/writing-style/SKILL.md) | Rules for every line a person reads: chat, comments, commits, PRs, docs, UI copy. Plain words, answer first, one idea per sentence, no em dash, no AI filler. Ends with a checklist to run before sending. |
| [`review`](skills/review/SKILL.md) | Reviews a PR, a branch, a file or a pasted diff. Writes the review in Russian: what the change solves, the order to read the files in, then findings with line numbers, the input, the real output and the fix. Each finding ends with a short English comment ready to paste on the line. |
| [`create-pr`](skills/create-pr/SKILL.md) | Writes a PR description in three parts: problem, solution, what was picked and rejected. Then opens or updates the PR with `gh`. |

`review` and `create-pr` both load `writing-style` before they write anything,
so the three live in one repo and move together.

## Install

Clone the repo, then link the skills into `~/.agents/skills`:

```sh
git clone https://github.com/oleg-chibikov/agent-skills.git ~/agent-skills
cd ~/agent-skills
mkdir -p ~/.agents/skills
ln -s "$PWD"/skills/* ~/.agents/skills/
```

The path matters. `review` and `create-pr` point at
`~/.agents/skills/writing-style/SKILL.md` by that exact path.

### Claude Code

```sh
mkdir -p ~/.claude/skills
ln -s ~/.agents/skills/{writing-style,review,create-pr} ~/.claude/skills/
```

### GitHub Copilot in VS Code

Copilot picks the skills up from `~/.agents/skills`. To apply the writing rules
to every answer, link the instructions stub as well:

```sh
ln -s "$PWD"/writing-style.instructions.md \
  ~/Library/Application\ Support/Code/User/prompts/
```

The stub has `applyTo: '**'`, so it loads in every workspace and tells the agent
to read the full `writing-style` skill.

## Use

Say what you want in plain words and the agent picks the skill by its
description:

- "review this" + a PR link
- "open a PR for this branch"
- "перепиши по-человечески"

## Licence

MIT.
