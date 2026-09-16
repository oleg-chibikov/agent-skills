#!/bin/sh
# Installs the skills in this repo into every coding agent on this machine.
# Works from a clone, or piped straight from curl.
set -eu

repo=https://github.com/oleg-chibikov/agent-skills.git
lang=""
uninstall=0
yes=0
stub=writing-style.instructions.md
block_start='<!-- agent-skills: writing rules -->'
block_end='<!-- agent-skills: end -->'

# Files an agent reads on every turn, so the writing rules apply without being
# asked for. Claude follows an @path, the rest get the path in plain words.
claude_memory="$HOME/.claude/CLAUDE.md"
codex_memory="$HOME/.codex/AGENTS.md"

# Where each agent keeps its global skills, relative to $HOME, minus the
# trailing /skills. A folder gets a link only when the agent is already there.
agents="
.adal
.agents
.aider-desk
.astrbot/data
.augment
.autohand
.bob
.claude
.codeartsdoer
.codebuddy
.codeium/windsurf
.codemaker
.codestudio
.codex
.commandcode
.config/crush
.config/devin
.config/goose
.continue
.copilot
.cursor
.factory
.forge
.hermes
.iflow
.inferencesh
.jazz
.junie
.kilocode
.kiro
.kode
.lingma
.mcpjam
.moxby
.mux
.neovate
.ona
.openclaw
.openhands
.pi/agent
.pochi
.qoder
.qoder-cn
.qwen
.reasonix
.roo
.rovodev
.snowflake/cortex
.tabnine/agent
.terramind
.tinycloud
.trae
.trae-cn
.vibe
.zcode
.zencoder
"

usage() {
  cat <<'EOF'
Usage: ./install.sh [--lang <language>]
       ./install.sh --uninstall [--yes]

  --lang <language>  Language for the long review text. Default English.
                     Example: --lang Russian
  --uninstall        Remove these skills from every agent folder on this
                     machine. Lists what it found and asks first.
  --yes              Answer yes to the uninstall question.

The skills live in one folder and every agent gets a symlink to it, so there is
only ever one copy to edit. Run it again after you install a new agent.
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --lang|-l)
      [ $# -ge 2 ] || { echo "--lang needs a language" >&2; exit 1; }
      lang=$2
      shift 2
      ;;
    --uninstall) uninstall=1; shift ;;
    --yes|-y) yes=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "unknown option: $1" >&2; usage >&2; exit 1 ;;
  esac
done

# Piped from curl, so $0 is not a file on disk: fetch the skills first.
if [ -f "$0" ] && [ -d "$(dirname "$0")/skills" ]; then
  root=$(cd "$(dirname "$0")" && pwd)
else
  root=${AGENT_SKILLS_DIR:-$HOME/.agent-skills}
  if [ -d "$root/.git" ]; then
    git -C "$root" pull --ff-only --quiet
    # A pull leaves files someone deleted by hand deleted, so put them back.
    [ -z "$(git -C "$root" ls-files -d)" ] || git -C "$root" checkout --quiet -- .
  else
    git clone --quiet --depth 1 "$repo" "$root"
  fi
fi

have_skills=0
for dir in "$root"/skills/*/; do
  if [ -d "$dir" ]; then have_skills=1; fi
done
if [ "$have_skills" -eq 0 ]; then
  echo "no skills in $root/skills, nothing to install" >&2
  exit 1
fi

ask() {
  if [ -t 0 ]; then
    printf '%s' "$1"
    read -r answer || answer=""
  elif [ -e /dev/tty ]; then
    printf '%s' "$1" > /dev/tty
    read -r answer < /dev/tty || answer=""
  else
    answer=""
  fi
}

# "Application Support" holds a space, so these paths stay quoted throughout.
vscode_dirs="$HOME/Library/Application Support/Code/User
$HOME/.config/Code/User"

add_block() {
  file=$1
  body=$2
  dir=${file%/*}
  if [ ! -d "$dir" ]; then return 0; fi
  if [ -f "$file" ] && grep -qF "$stub" "$file"; then return 0; fi
  if [ -s "$file" ]; then printf '\n' >> "$file"; fi
  printf '%s\n%s\n%s\n' "$block_start" "$body" "$block_end" >> "$file"
  echo "Writing rules wired into $file"
}

remove_block() {
  file=$1
  if [ ! -f "$file" ]; then return 0; fi
  if ! grep -qF "$block_start" "$file"; then return 0; fi
  tmp="$file.agent-skills.tmp"
  awk -v s="$block_start" -v e="$block_end" '
    $0 == s { skip = 1; next }
    $0 == e { skip = 0; next }
    skip != 1 { print }
  ' "$file" > "$tmp"
  mv "$tmp" "$file"
  # The file held nothing but the block, so it was ours to begin with.
  if [ ! -s "$file" ]; then rm -f "$file"; fi
}

wire_rules() {
  ln -sfn "$root/$stub" "$HOME/.agents/$stub"

  old_ifs=$IFS
  IFS='
'
  for dir in $vscode_dirs; do
    [ -d "$dir" ] || continue
    mkdir -p "$dir/prompts"
    ln -sfn "$root/$stub" "$dir/prompts/$stub"
    echo "VS Code reads the writing rules from $dir/prompts"
  done
  IFS=$old_ifs

  add_block "$claude_memory" "@~/.agents/$stub"
  add_block "$codex_memory" "Before you write any text a person will read, follow ~/.agents/$stub."
}

if [ "$uninstall" -eq 1 ]; then
  found=""
  places=""
  # .[!.]*/ so the glob cannot walk up into the parent of $HOME.
  for parent in "$HOME"/.[!.]*/skills "$HOME"/.[!.]*/*/skills; do
    [ -d "$parent" ] || continue
    # The folder the agents link to is the source, not a copy to clear.
    if [ "$parent" = "$root/skills" ]; then continue; fi
    for dir in "$root"/skills/*/; do
      target="$parent/$(basename "$dir")"
      if [ -e "$target" ] || [ -L "$target" ]; then
        found="$found$target
"
        places="$places$parent
"
      fi
    done
  done
  places=$(printf '%s' "$places" | sort -u)

  old_ifs=$IFS
  IFS='
'
  for dir in $vscode_dirs; do
    rules="$dir/prompts/$stub"
    if [ -e "$rules" ] || [ -L "$rules" ]; then
      found="$found$rules
"
      places="$places
$rules"
    fi
  done
  IFS=$old_ifs

  if [ -L "$HOME/.agents/$stub" ]; then
    found="$found$HOME/.agents/$stub
"
    places="$places
$HOME/.agents/$stub"
  fi

  wired=""
  for file in "$claude_memory" "$codex_memory"; do
    if [ -f "$file" ] && grep -qF "$block_start" "$file"; then
      wired="$wired$file
"
      places="$places
$file (the writing rules block only)"
    fi
  done

  if [ -z "$found" ] && [ -z "$wired" ]; then
    echo "nothing to remove"
    exit 0
  fi

  echo "About to delete these skills from:"
  printf '%s\n' "$places" | sed 's/^/  /'

  if [ "$yes" -ne 1 ]; then
    ask 'Delete these? [y/N]: '
    case "$answer" in
      y|Y|yes|YES) ;;
      *) echo "left alone"; exit 0 ;;
    esac
  fi

  old_ifs=$IFS
  IFS='
'
  for target in $found; do
    rm -rf "${target:?}"
  done
  for file in $wired; do
    remove_block "$file"
  done
  IFS=$old_ifs
  echo "removed. The folder in $root is still there, delete it by hand if you want it gone."
  exit 0
fi

if [ -z "$lang" ]; then
  ask 'Language for the long review text [English]: '
  lang=$answer
fi
[ -n "$lang" ] || lang=English

# Any script is fine. A slash or a line break would break the file it goes into.
case "$lang" in
  */*|*'
'*)
    echo "a language name cannot hold a slash or a line break: $lang" >&2
    exit 1
    ;;
esac

for dir in "$root"/skills/*/; do
  printf '%s\n' "$lang" > "$dir/LANGUAGE.md"
done

linked=""
skipped=""
for agent in $agents; do
  # .agents is the shared folder several agents read, so it always gets made.
  if [ "$agent" != ".agents" ] && [ ! -d "$HOME/$agent" ]; then
    continue
  fi
  mkdir -p "$HOME/$agent/skills"
  for dir in "$root"/skills/*/; do
    target="$HOME/$agent/skills/$(basename "$dir")"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
      skipped="$skipped  $target
"
      continue
    fi
    ln -sfn "${dir%/}" "$target"
  done
  linked="$linked $agent"
done

wire_rules

echo "Skills live in $root, report language $lang."
echo "Linked into:$linked"

if [ -n "$skipped" ]; then
  printf 'Left alone, something real is already sitting there:\n%s' "$skipped"
fi
