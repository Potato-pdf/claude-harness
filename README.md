# Claude Harness

Copia versionada de mi configuración de agentes de Claude Code. El objetivo es
tenerlo guardado: si pierdo la máquina o rompo algo, esto lo restaura.

Todo vive en `~/.claude/` en la máquina real. Este repo es el espejo.

---

## Qué es el harness

Tres capas que trabajan juntas. La diferencia importante entre ellas es **quién
las hace cumplir**:

| Capa | Archivo | Quién la aplica |
|---|---|---|
| Doctrina | `CLAUDE.md` | El modelo, leyéndola. Probabilística — se puede saltear. |
| Hooks | `settings.json` + `hooks/` | El harness, antes de ejecutar. Enforced. |
| Skills | `skills/` | El modelo, al invocarlas. |

Esa distinción es la razón de que el bloqueo de commits sea un hook y no una
línea en el `CLAUDE.md`: una instrucción se olvida, un hook rechaza.

---

## Las reglas (CLAUDE.md)

Aplica a Claude Desktop y a la CLI, porque está a nivel usuario.

- **Ciclo obligatorio** — `planning` antes de escribir código, `execution-harness`
  durante, `dev-standards` al tocar arquitectura o tests, `documentation` al cerrar.
- **Arquitectura** — SOLID, y evaluar al menos dos opciones de diseño antes de
  implementar. Nada de regresiones arquitectónicas para salir del paso.
- **Testing** — pruebas unitarias en todo cambio de comportamiento. Si no se
  pueden correr, decirlo; nunca declarar que algo funciona sin verificarlo.
- **Control de versiones** — no crear commits ni hacer push. Nunca. Yo reviso y
  commiteo a mano.
- **Verificación de repo** — mirar el estado real antes de asumir nada.
- **Aprendizaje** — invocar `task-observer` antes del primer tool call, y al
  cerrar, guardar en memoria lo que una sesión futura no podría deducir sola.
- **Precedencia** — si el repo tiene `AGENTS.md` o `.rules/`, esos mandan sobre
  este archivo.

---

## Los hooks

### `block-git-write.sh` — PreToolUse / Bash

Rechaza cualquier `git commit` o `git push`. Atrapa también los intentos
compuestos (`cd x && git push`, `git -C ruta commit`). Los comandos de lectura
(`status`, `diff`, `log`) pasan normalmente.

Existe porque la instrucción escrita no alcanzaba: ya había pasado que se
commiteara trabajo por iniciativa propia y me quedara sin poder revisar el diff.

**Efecto secundario a saber:** inspecciona el texto del comando, así que una
observación de task-observer que *cite* un `git commit` se bloquea sola si se
escribe por heredoc. Por eso el `CLAUDE.md` dice escribir los cuerpos de
observación con la herramienta de edición, no por shell.

### `repo-verify.sh` — SessionStart

Inyecta el estado real del repositorio al inicio: rama, upstream, behind/ahead,
árbol de trabajo y últimos commits. Más el recordatorio de preguntar antes de
tocar cambios sin commitear que el agente no reconozca.

### `task-observer-activation.sh` — SessionStart

La capa *enforced* de activación de task-observer. Cuenta las observaciones con
`status: open` (no los archivos del directorio — las resueltas se quedan un día
por el período de gracia) y avisa si la revisión está vencida.

---

## Las skills

Cuatro propias, en `skills/`:

- **`planning`** — metodología de planes antes de tocar código.
- **`dev-standards`** — SOLID y reglas de testing.
- **`execution-harness`** — ciclo de vida de ejecución.
- **`documentation`** — estado de sesión, README, auditoría de versiones.

### Dependencia externa: `task-observer`

**No está vendorizada en este repo a propósito.** Es de terceros
([rebelytics/one-skill-to-rule-them-all](https://github.com/rebelytics/one-skill-to-rule-them-all),
de Eoghan Henn, CC-BY-4.0) y conviene traerla de la fuente para que se actualice.

Es el mecanismo de aprendizaje: observa el trabajo, captura patrones y
correcciones, y tiene un ciclo de revisión que los convierte en mejoras a las
skills. Su workspace está anclado en `~/.claude/task-observer/` a **ámbito
usuario**, porque las skills viven en `~/.claude/skills/` y se observan desde
todos los proyectos — un log por proyecto dispersaría las observaciones.

---

## Restaurar en una máquina nueva

```bash
git clone https://github.com/Potato-pdf/claude-harness.git
cd claude-harness
mkdir -p ~/.claude/hooks ~/.claude/skills
cp CLAUDE.md ~/.claude/CLAUDE.md
cp hooks/*.sh ~/.claude/hooks/
cp -r skills/* ~/.claude/skills/
chmod +x ~/.claude/hooks/*.sh
mkdir -p ~/.claude/task-observer/skill-observations/observation-log ~/.claude/task-observer/skill-updates
```

`settings.json` va aparte: **no lo copies encima del tuyo.** Trae los hooks pero
también el modelo, el tema y los plugins habilitados, y pisar el archivo existente
se lleva puesto lo que hubiera. Abrilo y traé a mano el bloque `hooks`.

Después, task-observer:

```bash
git clone https://github.com/rebelytics/one-skill-to-rule-them-all.git /tmp/osrta
mkdir -p ~/.claude/skills/task-observer
cp -r /tmp/osrta/SKILL.md /tmp/osrta/references /tmp/osrta/scripts ~/.claude/skills/task-observer/
```

### Verificar que quedó

```bash
jq -e . ~/.claude/settings.json && echo "settings OK"
python3 ~/.claude/skills/task-observer/scripts/validate-skill-bundle.py ~/.claude/skills/task-observer
git commit --dry-run -m test   # debe ser RECHAZADO por el harness
```

Ese último es el que importa: si el commit pasa, el hook no está activo.

**Ojo:** la sesión que instala no puede probar la activación de task-observer.
Eso se verifica en una sesión *nueva*, confirmando que la skill se invocó sola
antes del primer tool call. Si después de varias sesiones de trabajo real el
directorio `observation-log/` sigue vacío, la activación nunca ocurrió.

---

## Qué NO está acá

- **Headroom** — proxy de optimización de contexto, servicio systemd aparte.
  Solo enruta la CLI de terminal; Desktop sobrescribe `ANTHROPIC_BASE_URL` y no
  pasa por él. Se corre `headroom learn` a mano cuando se repite un mismo error
  entre sesiones, tras un refactor grande, o una vez al mes.
- **claude-mem** — plugin de memoria, se instala desde su marketplace.
- **Memorias y observaciones** — son contenido, no configuración, y algunas
  tienen contexto de trabajo. Se quedan en la máquina.

---

## Licencia

Configuración personal. Las skills propias son mías; `task-observer` es
CC-BY-4.0 de Eoghan Henn y no se redistribuye acá.
