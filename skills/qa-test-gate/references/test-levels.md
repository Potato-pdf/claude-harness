# Test level guide

Use this guide to decide what each row of the QA matrix must prove. Adapt tools
and commands to the repository; preserve the intent of the level.

## Unit tests

Unit tests exercise one behavior through a stable public seam with deterministic
inputs. Isolate slow or external collaborators, but do not mock the subject into
reimplementing its own algorithm inside the test.

Cover, as applicable:

- the primary success path;
- boundary and empty values;
- invalid input and expected error behavior;
- state transitions and cleanup; and
- the exact regression that motivated a fix.

A unit row is complete when the new test was shown to fail for the missing or
broken behavior, passes with the implementation, and the full unit suite passes.

## Integration tests

Integration tests prove a contract across a real boundary: module-to-module,
API-to-client, service-to-database, filesystem, queue, cache, process, migration,
or external adapter. Use the closest practical test double only at the boundary
outside the system under test; do not replace both sides of the contract with
mocks.

Verify serialization, schema, status and error mapping, timeouts, retries,
transactions, cleanup, and compatibility where they are relevant. Prefer
isolated fixtures or ephemeral services and leave no persistent test data.

An integration row is `NOT APPLICABLE` only when the changed behavior crosses no
component or external boundary. Missing infrastructure makes it `BLOCKED`, not
`NOT APPLICABLE`.

## Static checks

Static checks inspect source or build artifacts without relying on the runtime
scenario. Discover and run the repository's applicable formatter verification,
linter, type checker, compiler or build, schema validator, dependency check, and
security scanner.

Run the canonical aggregate command when one exists. Do not introduce a new tool
solely to fill this row unless the user approves that tooling change. A check
that cannot load its configuration or silently skips the changed files has not
passed.

## Smoke tests

A smoke test proves that the assembled artifact can start and perform one short,
representative critical flow in an environment close enough to expose wiring,
configuration, packaging, migration, and startup failures.

Examples include starting a service and probing its health plus one changed
endpoint, launching a CLI and executing its changed command, importing and
initializing a packaged library, or loading the changed application and
completing its shortest core interaction.

Use bounded waits, controlled ports, explicit teardown, and non-production data.
A unit test that calls one function is not a smoke test. If credentials or a
service are unavailable, record the row as `BLOCKED` with the precise missing
precondition and do not claim runtime verification.
