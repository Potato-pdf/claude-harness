# Harness de desarrollo

Reglas permanentes para todo trabajo de código. No son sugerencias.

## Ciclo obligatorio

Antes de escribir código, invocá la skill `planning` y acordá el plan.
Durante la implementación, seguí el ciclo de `execution-harness`.
Al tocar arquitectura o tests, aplicá `dev-standards`.
Al cerrar, actualizá lo que corresponda según `documentation`.

Si una tarea es trivial (una línea, un typo), no hace falta el ciclo completo — pero decilo explícitamente en vez de saltearlo en silencio.

## Arquitectura

Diseñá contra los principios SOLID. Antes de implementar, evaluá al menos dos
opciones de diseño y justificá la elegida en una o dos frases.

No introduzcas regresiones arquitectónicas: si la solución rápida contradice la
estructura existente del repo, decilo y proponé la alternativa correcta en lugar
de meter el parche.

## Testing

Todo cambio de comportamiento va acompañado de pruebas unitarias. Corré la suite
antes de reportar el trabajo como terminado.

Si no podés correr los tests (falta entorno, credenciales, servicio externo),
decilo explícitamente — nunca declares que algo funciona sin haberlo verificado.

## Control de versiones

No crees commits ni hagas push. Nunca. El usuario revisa y commitea a mano.
Dejá los cambios en el árbol de trabajo y resumí qué tocaste.

Un hook bloquea estos comandos: si te lo rechaza, no busques la vuelta.

## Verificación de repositorio

Al empezar, revisá el estado real del repo (rama, árbol de trabajo, upstream) —
un hook te lo inyecta automáticamente. Si hay cambios sin commitear que no
reconocés, pueden ser trabajo en curso del usuario: preguntá antes de tocarlos.

Antes de cualquier comando que pueda descartar trabajo, verificá `git status` primero.

## Aprendizaje

Invocá la skill `task-observer` Y ejecutá su Session Start Protocol (chequeo de
storage, scan de frontmatter, trigger de revisión) cuando la sesión vaya a
involucrar trabajo de varios pasos: implementar, refactorizar, depurar, o
cualquier tarea donde vayas a tocar código o tomar decisiones de diseño.
Cargar la skill y correr el protocolo son pasos distintos: una sesión que carga
el archivo y se detiene no activó nada.

No lo cargues para una consulta puntual, una lectura, una pregunta de una
respuesta o un pedido de una sola línea — pesa ~11.600 tokens de línea de base
que se reenvían en cada tool call de la sesión, y en una tarea chica ese costo
supera lo que se podría llegar a capturar. Si a mitad de una sesión "chica" el
pedido escala a trabajo real, cargalo en ese momento — no hace falta haberlo
anticipado desde el mensaje de apertura.

Elegí las skills por la DECISIÓN que el pedido involucra, no por el artefacto en
que llegó. Nombrá qué está decidiendo el usuario y recién ahí matcheá contra las
descripciones instaladas.

Al terminar cada tarea, revisá las observaciones escritas en la sesión y reportá
una línea (ids y títulos, o "ninguna, y por qué"). Es el backstop: fuerza a mirar
el log, así una sesión que se saltó el protocolo se descubre en el primer cierre
de tarea y no nunca.

Cargar una skill no está completo hasta haber consultado el log por observaciones
OPEN que la nombren y leído sus cuerpos:
  find "$HOME/.claude/task-observer/skill-observations/observation-log" -maxdepth 1 \
    -name '*.md' -exec grep -l "skill:.*<nombre-skill>" {} +
(Usá `find`, no un glob `*.md` pelado: bajo zsh un glob sin match es error y en
un log vacío el comando nunca corre.) Aplicá lo que digan a ESTA tarea. Editar
el archivo de la skill, o escribir la regla en otro archivo que lea una sesión
futura, es *actuar* sobre la observación y eso espera a la revisión.

El workspace de task-observer es:
  $HOME/.claude/task-observer
Todas las rutas derivan de esa raíz y de nada más:
  $HOME/.claude/task-observer/skill-observations/observation-log/
  $HOME/.claude/task-observer/skill-observations/cross-cutting-principles.md
  $HOME/.claude/task-observer/skill-updates/
  $HOME/.claude/task-observer/skill-updates/PENDING.md
Nunca las resuelvas desde el directorio de trabajo actual. Es ámbito usuario a
propósito: las skills viven en `~/.claude/skills/` y se observan desde todos los
proyectos, así que el log es uno solo y compartido.

**Escribí los cuerpos de observación con la herramienta de edición, nunca por
shell.** El hook que bloquea git inspecciona el texto del comando, así que una
observación que *cite* un `git commit` se bloquearía sola si se escribe por heredoc.

Además, al cerrar una tarea, preguntate si aprendiste algo que la próxima sesión
no va a poder deducir sola: un patrón de fallo, una trampa del entorno, una
decisión del usuario y su porqué, una convención del repo que no está escrita.

Si la respuesta es sí, escribilo en memoria (`memory/`) con el *por qué*, no solo
el qué. Si no aprendiste nada no obvio, no escribas nada — el ruido en memoria
cuesta más que el silencio.

No guardes lo que el repo ya documenta (estructura, historial de git, CLAUDE.md).
Antes de crear un archivo nuevo, revisá si ya existe uno que cubra el tema y
actualizalo en vez de duplicar.

Cuando un mismo error se repita entre sesiones, decilo explícitamente en vez de
volver a tropezarlo en silencio.

## Protocolo del repositorio

Si el repo tiene `AGENTS.md` o `.rules/`, esas reglas mandan sobre este archivo.
Leelas antes de cambiar nada estructural, y confirmá con el usuario cuando exijan confirmación.
