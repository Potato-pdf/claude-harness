---
name: documentation
description: Gestión del estado de sesión, mantenimiento del README y protocolo de auditoría/barrido de versiones en documentación.
---

```yaml
name: documentation
description: Gestión del estado de sesión, mantenimiento del README y protocolo de auditoría/barrido de versiones en documentación.
version: 1.0.0

session_state:
  file_path: "./.docs/session_state.md"
  required_sections:
    - name: "[QUÉ SE LLEVA (Done)]"
      description: "Lista concisa de módulos, endpoints o características terminadas y funcionales."
    - name: "[QUÉ FALTA (Pending)]"
      description: "Tareas pendientes, deuda técnica inmediata o errores conocidos."
    - name: "[QUÉ SE HIZO HOY (Today's Diff)]"
      description: "Registro detallado de los cambios exactos realizados exclusivamente en la sesión actual."

readme_maintenance:
  trigger: "Desarrollo de nuevas funcionalidades o cambios que impactan al usuario/despliegue."
  actions:
    - "Actualizar la sección de características principales o guías de uso."
    - "Verificar los encabezados de versión declarada."

version_sweep_protocol:
  trigger: "Obligatorio en toda sesión que modifique archivos de documentación."
  steps:
    - step: 1
      name: "Consultar versión autoritativa"
      action: "Obtener la última versión publicada utilizando las herramientas del gestor de paquetes o del control de versiones (Git tags/releases)."
    - step: 2
      name: "Ejecutar barrido en documentación"
      action: "Buscar patrones de versión (ej. expresiones regulares de semver) en README y carpeta de documentación para identificar discrepancias."
    - step: 3
      name: "Clasificar y actualizar"
      rules:
        update: "Actualizar encabezados de estado actual, tablas de comandos y guías activas a la versión publicada."
        preserve: "NO modificar referencias dentro de changelogs, registros de bugs o documentos de planificación histórica para preservar la trazabilidad."

feedback_logging:
  file_path: "./.docs/feedback_log.md"
  action: "Registrar correcciones importantes, vulnerabilidades o aprendizajes indicando la fecha, el problema detectado y la solución implementada para evitar regresiones."
```
