#!/usr/bin/env bash
# SessionStart: inyecta el estado real del repositorio antes de que el agente asuma nada.
set -uo pipefail

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  exit 0
fi

branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
status=$(git status --porcelain=v1 2>/dev/null | head -40)
recent=$(git log --oneline -5 2>/dev/null)
upstream=$(git rev-parse --abbrev-ref '@{u}' 2>/dev/null || echo "(sin upstream)")
ahead_behind=$(git rev-list --left-right --count '@{u}...HEAD' 2>/dev/null || echo "-")

ctx=$(printf 'VERIFICACION DE REPOSITORIO (hook automatico)\nRama: %s\nUpstream: %s\nbehind/ahead: %s\n\nArbol de trabajo:\n%s\n\nUltimos commits:\n%s\n\nRecordatorio del harness: no crear commits ni hacer push. Si el arbol tiene cambios sin commitear que no reconoces, preguntale al usuario antes de tocarlos.' \
  "$branch" "$upstream" "$ahead_behind" "${status:-(limpio)}" "$recent")

jq -n --arg ctx "$ctx" '{
  hookSpecificOutput: {
    hookEventName: "SessionStart",
    additionalContext: $ctx
  }
}'
