---
name: execution-harness
description: Define el ciclo de vida estandarizado de ejecución para agentes de desarrollo automatizado de software.
---

```yaml
name: execution_harness
description: Define el ciclo de vida estandarizado de ejecución para agentes de desarrollo automatizado de software.
version: 1.0.0
type: lifecycle_harness
config:
  docs_directory: "./.docs"
  state_file: "./.docs/session_state.md"
  feedback_file: "./.docs/feedback_log.md"
  plan_file: "./.docs/current_plan.md"
  readme_file: "./README.md"

lifecycle:
  phase_1_initialization:
    name: "Inicialización (Lectura de Contexto)"
    steps:
      - "Leer el archivo de estado de sesión para comprender el progreso actual del proyecto."
      - "Revisar el registro de feedback para evitar repetir errores previamente reportados."
      - "Verificar la existencia de un plan activo en el archivo de planificación antes de iniciar acciones."

  phase_2_planning:
    name: "Planificación (Estrategia)"
    steps:
      - "Para cualquier nueva característica o refactorización significativa, ejecutar la skill de planificación."
      - "No proceder al desarrollo hasta que el plan esté documentado y validado."

  phase_3_execution:
    name: "Ejecución y Desarrollo (Implementación)"
    steps:
      - "Ejecutar las tareas planificadas aplicando los estándares de desarrollo y testing."
      - "Modificar o escribir el código garantizando que las pruebas automatizadas pasen exitosamente."

  phase_4_session_close:
    name: "Cierre de Sesión (Persistencia de Contexto)"
    steps:
      - "Aplicar la skill de gestión de documentación y realizar el barrido de versiones en la documentación activa."
      - "Actualizar el archivo de estado de sesión con los avances, pendientes y cambios de la sesión actual."
      - "Actualizar el README si se agregaron nuevas funcionalidades o cambiaron las versiones públicas."
      - "Actualizar el estado del plan marcando las tareas completadas."
```
