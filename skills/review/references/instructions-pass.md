# Agent instructions

`SKILL.md`, `AGENTS.md`, `CLAUDE.md`, an `.instructions.md` or a prompt is code
an agent runs to the letter. Read each changed rule as that agent.

- **Taken literally**: what does the agent write when it follows this rule on
  every case it covers? Name the case where that output is wrong.
- **Two orders**: does the rule clash with another one in the diff, or in a
  file it links to? Say which one wins.
- **Same rule twice**: is it now in two files, with reasons that differ? One
  copy goes, the other links to it.
- **Commands it gives**: does the command print what the text says it prints,
  in the folder it runs in?
- **Text left behind**: does another line of the same skill still describe the
  old behaviour?

The finding MUST quote the rule and show what the agent produces from it.
