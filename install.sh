#!/bin/sh
# Installs the skills in this repo into every coding agent on this machine.
# Works from a clone, or piped straight from curl.
set -eu

repo=https://github.com/oleg-chibikov/agent-skills.git
lang=""
vscode=0
link=0
uninstall=0
yes=0
rest=""

usage() {
  cat <<'EOF'
Usage: ./install.sh [--lang <language>] [--link] [--vscode] [-- <skills-cli args>]
       ./install.sh --uninstall [--yes]

  --lang <language>  Language for the long review text. Default English.
                     Example: --lang Russian
  --link             Symlink the agent folders straight at this clone, so an
                     edit here is live everywhere. Skips the skills CLI.
  --vscode           Also link the always-on writing rules into VS Code,
                     so GitHub Copilot applies them to every answer.
  --uninstall        Remove these skills from every agent folder on this
                     machine. Lists what it found and asks first.
  --yes              Answer yes to the uninstall question.
  --                 Everything after this goes to `npx skills add`.
                     Example: -- --agent claude-code --yes
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --lang|-l)
      [ $# -ge 2 ] || { echo "--lang needs a language" >&2; exit 1; }
      lang=$2
      shift 2
      ;;
    --link) link=1; shift ;;
    --vscode) vscode=1; shift ;;
    --uninstall) uninstall=1; shift ;;
    --yes|-y) yes=1; shift ;;
    -h|--help) usage; exit 0 ;;
    --) shift; rest=$*; break ;;
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
  else
    git clone --quiet --depth 1 "$repo" "$root"
  fi
  echo "Skills in $root"
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

if [ "$uninstall" -eq 1 ]; then
  found=""
  places=""
  # .[!.]*/ so the glob cannot walk up into the parent of $HOME.
  for parent in "$HOME"/.[!.]*/skills "$HOME"/.[!.]*/*/skills; do
    [ -d "$parent" ] || continue
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

  for prompts in "$HOME/Library/Application Support/Code/User/prompts" "$HOME/.config/Code/User/prompts"; do
    rules="$prompts/writing-style.instructions.md"
    if [ -e "$rules" ] || [ -L "$rules" ]; then
      found="$found$rules
"
      places="$places
$rules"
    fi
  done

  if [ -z "$found" ]; then
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
  IFS=$old_ifs
  echo "removed. The clone in $root is still there, delete it by hand if you want it gone."
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
echo "Report language: $lang"

link_into() {
  target=$1
  mkdir -p "$target"
  for dir in "$root"/skills/*/; do
    name=$(basename "$dir")
    rm -rf "$target/${name:?}"
    ln -s "${dir%/}" "$target/$name"
  done
  echo "linked into $target"
}

if [ "$link" -eq 1 ]; then
  link_into "$HOME/.agents/skills"
  [ -d "$HOME/.claude" ] && link_into "$HOME/.claude/skills"
elif command -v npx > /dev/null 2>&1; then
  # The skills CLI knows where 80+ agents keep their skills, so let it place them.
  # Piped from curl, stdin holds the script, so hand the CLI the terminal instead.
  # shellcheck disable=SC2086
  if [ -t 0 ] || [ ! -e /dev/tty ]; then
    npx -y skills add "$root" --skill '*' --global $rest
  else
    npx -y skills add "$root" --skill '*' --global $rest < /dev/tty
  fi
else
  echo "npx not found, linking by hand instead"
  link_into "$HOME/.agents/skills"
  [ -d "$HOME/.claude" ] && link_into "$HOME/.claude/skills"
fi

if [ "$vscode" -eq 1 ]; then
  prompts="$HOME/Library/Application Support/Code/User/prompts"
  [ -d "$(dirname "$prompts")" ] || prompts="$HOME/.config/Code/User/prompts"
  if [ -d "$(dirname "$prompts")" ]; then
    mkdir -p "$prompts"
    ln -sf "$root/writing-style.instructions.md" "$prompts/"
    echo "linked the writing rules into $prompts"
  else
    echo "VS Code user folder not found, skipped --vscode" >&2
  fi
fi
