#!/usr/bin/env python3
"""Count prose lines in a markdown file. Fenced blocks and blanks don't count.

    python3 scripts/prose-lines.py skills/*/SKILL.md
"""
import pathlib
import re
import sys

CAPS = {"SKILL.md": 300, "reference": 60}

failed = False
for name in sys.argv[1:]:
    path = pathlib.Path(name)
    fences: list[str] = []
    prose = 0
    for line in path.read_text().splitlines():
        opener = re.match(r"^(`{3,})", line)
        if opener:
            tag = opener.group(1)
            if fences and fences[-1] == tag:
                fences.pop()
            else:
                fences.append(tag)
            continue
        if not fences and line.strip():
            prose += 1
    cap = CAPS["SKILL.md"] if path.name == "SKILL.md" else CAPS["reference"]
    over = " OVER CAP" if prose > cap else ""
    failed = failed or bool(over)
    print(f"{prose:4d} / {cap}  {path}{over}")

sys.exit(1 if failed else 0)
