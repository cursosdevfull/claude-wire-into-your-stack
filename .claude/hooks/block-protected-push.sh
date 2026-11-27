#!/usr/bin/env bash
# PreToolUse hook (Bash): blocks `git push` to protected branches.
# Exit 2 = block the tool call; the message on stderr is shown to Claude.

PROTECTED_REGEX='^(main|release|maintenance)$'

input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty')
cwd=$(printf '%s' "$input" | jq -r '.cwd // empty')

# Nothing to check if the command has no `git push` in it.
printf '%s' "$cmd" | grep -Eq '(^|[^[:alnum:]_-])git([[:space:]]+-[Cc][[:space:]]+[^[:space:]]+|[[:space:]]+-[^[:space:]]+)*[[:space:]]+push([[:space:]]|$)' || exit 0

current_branch() {
  git -C "${cwd:-.}" rev-parse --abbrev-ref HEAD 2>/dev/null
}

block() {
  echo "Bloqueado por hook: no se permite hacer push a la rama protegida '$1' (main, release, maintenance). Usa una rama de trabajo y abre un PR." >&2
  exit 2
}

# Split the command into segments (;, &&, ||, |, newlines) and inspect each `git push`.
segments=$(printf '%s' "$cmd" | sed -E 's/(\&\&|\|\||;|\|)/\n/g')

while IFS= read -r seg; do
  # Keep only what comes after `push` in this segment.
  rest=$(printf '%s' "$seg" | sed -nE 's/.*(^|[^[:alnum:]_-])git([[:space:]]+-[Cc][[:space:]]+[^[:space:]]+|[[:space:]]+-[^[:space:]]+)*[[:space:]]+push([[:space:]]+(.*))?$/\4/p')
  printf '%s' "$seg" | grep -Eq '(^|[^[:alnum:]_-])git([[:space:]]+-[Cc][[:space:]]+[^[:space:]]+|[[:space:]]+-[^[:space:]]+)*[[:space:]]+push([[:space:]]|$)' || continue

  positional=()
  for tok in $rest; do
    tok=${tok//\"/}; tok=${tok//\'/}
    case "$tok" in
      --all|--mirror) block "todas las ramas ($tok)" ;;
      -*) ;;                      # other flags (-u, --force, ...)
      *) positional+=("$tok") ;;
    esac
  done

  # positional[0] = remote, the rest = refspecs.
  if [ "${#positional[@]}" -le 1 ]; then
    targets=("$(current_branch)")
  else
    targets=("${positional[@]:1}")
  fi

  for ref in "${targets[@]}"; do
    ref=${ref#+}                  # +main (force)
    ref=${ref##*:}                # src:dst -> dst
    ref=${ref#refs/heads/}
    [ "$ref" = "HEAD" ] || [ -z "$ref" ] && ref=$(current_branch)
    if printf '%s' "$ref" | grep -Eq "$PROTECTED_REGEX"; then
      block "$ref"
    fi
  done
done <<< "$segments"

exit 0
