---
name: planning
description: Metodología estándar para la creación, estructuración y seguimiento de planes de proyecto antes de modificar código.
---

```yaml
name: planning
description: Metodología estándar para la creación, estructuración y seguimiento de planes de proyecto antes de modificar código.
version: 1.0.0
config:
  plan_file: "./.docs/current_plan.md"
  archive_directory: "./.docs/archive/"

structure:
  objective:
    section: "[OBJETIVO ACTUAL]"
    description: "Descripción concisa (1 a 2 líneas) de la característica o problema a resolver."
  architecture:
    section: "[ARQUITECTURA/DISEÑO]"
    description: "Explicación de la estrategia técnica, patrones a aplicar, principios SOLID y dependencias necesarias."
  implementation_steps:
    section: "[PASOS DE IMPLEMENTACIÓN (Checklist)]"
    description: "Lista de tareas granulares ordenadas cronológicamente en formato de casilla de verificación Markdown (- [ ])."
  acceptance_criteria:
    section: "[CRITERIOS DE ACEPTACIÓN]"
    description: "Condiciones medibles y verificables necesarias para considerar la tarea como completada."

execution_rules:
  - "Durante el desarrollo, marcar con (- [x]) las tareas a medida que se completen."
  - "Si surge un impedimento técnico grave, pausar la ejecución, documentar el alcance modificado en el plan y reajustar los pasos."
  - "Al completar todas las tareas, archivar o limpiar el plan y consolidar los resultados en el estado de la sesión."
```
