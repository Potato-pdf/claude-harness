---
name: qa-test-gate
description: "Plan, create, execute, and report unit, integration, static, and smoke tests for code or configuration changes that affect executable behavior. Use when implementing, fixing, refactoring, integrating, or independently validating code, including work delegated to another agent or CLI. Do not use for documentation-only, research-only, or other tasks with no executable behavior; in those cases ignore this skill."
---

# QA Test Gate

Use this internal skill as the acceptance gate for every change to executable
behavior. A task is not verified because code looks correct or another agent
reports success; it is verified only by reproducible evidence from the target
repository.

## Scope

Apply this skill when a task adds, changes, fixes, refactors, integrates, or
validates executable code, build logic, runtime configuration, migrations, or
interfaces between components. Ignore it entirely for documentation-only,
research-only, planning-only, or other work with no executable behavior.

Before designing or running the gate, read
`references/test-levels.md`. Apply `dev-standards` as well when the change
touches architecture or test design.

## 1. Discover the repository contract

Inspect the repository's instructions, package or build manifests, existing test
layout, CI configuration, and documented commands. Prefer repository-native
commands over invented alternatives. Record:

- the changed behavior and its failure modes;
- the components and boundaries affected;
- the commands the repository already uses for build, lint, types, tests, and
  startup; and
- required services, fixtures, credentials, ports, or platform constraints.

Never weaken a check, delete a failing test, or replace a real boundary with a
mock merely to obtain a green result.

## 2. Build the mandatory matrix

Create a four-row QA matrix before declaring implementation complete:

| Level | Required decision | Minimum evidence |
|---|---|---|
| Unit | Required for changed logic | New or existing focused tests cover success, edge, and error paths |
| Integration | Required for affected boundaries | Components exchange real contracts using the closest practical test environment |
| Static | Required for the languages and build system | Repository formatter/check, linter, type checker, compiler, and applicable security checks run |
| Smoke | Required for the changed critical path | Built or runnable artifact starts and completes one minimal representative flow |

Every row must finish as `PASSED`, `FAILED`, `BLOCKED`, or `NOT APPLICABLE`.
`NOT APPLICABLE` requires a concrete structural reason, not lack of time.
`BLOCKED` requires the missing dependency, the attempted command or procedure,
and what remains unverified. Never silently omit a row.

## 3. Create tests with failure evidence

For new or corrected behavior, add the smallest deterministic automated test
that would fail without the change. Prove the test can detect the defect before
using its green result as evidence. For structural assertions, exercise at least
two distinct break modes so the test does not merely match the current shape.

Favor observable behavior over implementation details. Cover representative
boundary values, error propagation, cleanup, and regression cases. Coverage
percentages are supporting signals, not substitutes for meaningful assertions.

## 4. Execute from fast feedback to runtime proof

Unless repository instructions require another order, run:

1. static checks;
2. focused unit tests, then the full unit suite;
3. affected integration tests, then the broader integration suite when viable;
4. a smoke test against the built or runnable artifact.

Stop to diagnose failures, classify them as product defect, test defect, or
environment defect, and correct the appropriate layer. After any correction,
rerun the failed level and every downstream level whose evidence may have been
invalidated. A clean merge or a delegated agent's summary is never a substitute
for compilation and tests on the final working tree.

## 5. Verify delegated work independently

When code was produced by AGY or any other agent, the parent agent must inspect
the diff and rerun the applicable matrix on the final integrated tree. Agent
transcripts and reported pass counts may guide review, but do not satisfy this
gate on their own.

## 6. Report the gate

The completion report must include:

- each matrix row and its final status;
- exact commands or reproducible procedures actually run;
- relevant pass/fail counts and the failure-first evidence for new tests;
- blocked or not-applicable rows with reasons;
- unverified behavior and residual risk; and
- confirmation that the final working tree, not an earlier intermediate state,
  produced the reported evidence.

Do not say that the change works when any required row is `FAILED` or `BLOCKED`.
Say what is implemented, what is verified, and what remains unresolved.

## Pre-delivery check

Before reporting completion, confirm that all four rows are present, every
required command finished successfully on the final tree, failures were not
hidden by skipped tests or weakened assertions, and any limitation is explicit.
