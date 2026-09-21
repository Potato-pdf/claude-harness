#!/usr/bin/env bash
# PreToolUse/Bash: impide que el agente cree commits o publique cambios.
# El usuario revisa y commitea a mano.
set -uo pipefail

cmd=$(jq -r '.tool_input.command // ""' 2>/dev/null)

if printf '%s' "$cmd" | grep -Eq '\bgit\b[^;&|]*\b(commit|push)\b'; then
  jq -n --arg c "$cmd" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: ("Harness: prohibido crear commits o publicar. El usuario revisa y commitea el mismo. Deja los cambios en el arbol de trabajo y resume que cambiaste. Comando bloqueado: " + $c)
    }
  }'
  exit 0
fi

exit 0
