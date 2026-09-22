#!/bin/sh
# SessionStart: capa de activacion enforced para task-observer.
# Inyecta la instruccion de invocacion + el estado del log de observaciones.
# Ref: references/environments.md -> "A session-start hook"

d="$HOME/.claude/task-observer/skill-observations"

# Contar SOLO las observaciones con status: open, no los archivos del directorio:
# las resueltas siguen ahi un dia por el periodo de gracia y las parqueadas ya
# estan decididas, asi que un conteo crudo infla el backlog en cada sesion.
open=$(find "$d/observation-log" -maxdepth 1 -name '*.md' -exec grep -l '^status: open$' {} + 2>/dev/null | wc -l | tr -d ' ')
last=$(cat "$d/last-review-date.txt" 2>/dev/null || echo never)

msg="Si esta sesion es trabajo de varios pasos (implementar, refactorizar, depurar, decisiones de diseno), invoca la skill task-observer y ejecuta su Session Start Protocol (chequeo de storage, scan de frontmatter, trigger de revision) antes de arrancar. No la cargues para una consulta puntual o un pedido de una sola respuesta: pesa ~11.6k tokens de linea de base por request. Si una sesion chica escala a trabajo real a mitad de camino, cargala en ese momento."

if [ "$open" -gt 0 ]; then
  msg="$msg Hay $open observaciones abiertas; ultima revision: $last."
  cutoff=$(date -d '7 days ago' +%Y-%m-%d 2>/dev/null || echo "")
  case "$last" in
    never)
      msg="$msg Ofrece la revision."
      ;;
    *)
      # Fechas ISO comparadas por orden lexico via sort: portable a todo shell
      # POSIX. [ "$a" \< "$b" ] es extension de bash/ksh que zsh rechaza.
      if [ -n "$cutoff" ] && [ "$(printf '%s\n%s\n' "$last" "$cutoff" | sort | head -1)" = "$last" ]; then
        msg="$msg La revision esta vencida: ofrecela."
      fi
      ;;
  esac
fi

# jq arma el JSON para escapar comillas y saltos de linea correctamente.
jq -n --arg m "$msg" '{
  hookSpecificOutput: {
    hookEventName: "SessionStart",
    additionalContext: $m
  }
}'
