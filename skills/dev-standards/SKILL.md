---
name: dev-standards
description: Estándares universales de arquitectura de software, principios SOLID y reglas rigurosas de testing automatizado.
---

```yaml
name: dev_standards
description: Estándares universales de arquitectura de software, principios SOLID y reglas rigurosas de testing automatizado.
version: 1.0.0

principles:
  solid:
    single_responsibility: "Cada módulo, función o clase debe tener una única razón para cambiar."
    open_closed: "Abierto a extensión, cerrado a modificación."
    liskov_substitution: "Los objetos de una subclase deben poder reemplazar a los de la superclase sin alterar la integridad del sistema."
    interface_segregation: "Muchas interfaces específicas son mejores que una sola interfaz de propósito general."
    dependency_inversion: "Depender de abstracciones mediante inyección de dependencias en lugar de instanciaciones directas."
  clean_code:
    modularity: "Mantener alta cohesión y bajo acoplamiento. Si un archivo supera sus responsabilidades lógicas, refactorizar y dividir."
    doc_location: "Toda la documentación, notas y diagramas generados deben almacenarse en la carpeta centralizada de documentación."

testing_rules:
  fail_first_verification:
    rule: "Verificar tests nuevos provocando su fallo voluntario."
    description: "Desactivar temporalmente el arreglo (fix), ejecutar la prueba para confirmar que falla, y restaurar la solución. Garantiza que la aserción valida realmente el fix."
  observable_state_assertion:
    rule: "Aseverar el estado final observable y tangible."
    description: "No validar estados intermedios ni el inicio de un proceso efímero; validar el resultado final persistido o el valor devuelto."
  platform_decoupling:
    rule: "Desacoplar dependencias de plataforma mediante inyección o mocks."
    description: "Nunca ejecutar aserciones contra el sistema operativo host sin aislar o simular explícitamente la plataforma objetivo en el entorno de prueba."
  fixture_integrity:
    rule: "Validar fixtures y datos de prueba contra fuentes autoritativas reales."
    description: "Evitar autogenerar datos o golden files a partir del propio código bajo prueba, ya que enmascara cambios o desalineaciones en los contratos de API."
  ci_guard_steps:
    rule: "Validación explícita de artefactos en CI previa a la ejecución."
    description: "Asegurar que los pipelines de integración continua fallen explícitamente si faltan dependencias o artefactos compilados, evitando falsos verdes por pruebas saltadas (skipped tests)."
  runtime_version_sourcing:
    rule: "Fuente única de verdad para versiones en tiempo de ejecución."
    description: "Toda versión expuesta en runtime debe obtenerse dinámicamente de la fuente autoritativa del proyecto (ej. package.json, Cargo.toml, pyproject.toml) y nunca mediante cadenas hardcodeadas."
```
