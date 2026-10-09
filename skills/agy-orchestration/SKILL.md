---
name: agy-orchestration
description: "Delegate scoped work to the Antigravity agy CLI and independently verify its quality before accepting the result. Use when coordinating agy agents or reviewing work they produced; do not use for unrelated local tasks."
---

# Agy Orchestration

Use this internal skill to coordinate bounded subtasks through the locally
installed `agy` CLI. The parent agent remains accountable for the plan,
authority checks, integration, and final acceptance; an AGY response is
evidence to review, never an authoritative result.

## Scope and safety

- Confirm `agy` is installed with `command -v agy` and inspect its supported
  flags with `agy --help` before a first use in an environment.
- Treat `agy models` as an availability check only. It does **not** establish
  that a model is free, that quota remains, or that its price will stay zero.
  Verify billing, quotas, and provider terms before high-volume work.
- Keep a delegated task narrow and reversible. Do not pass secrets, access
  tokens, personal data, or unrelated workspace material to AGY.
- Never use `--dangerously-skip-permissions`. Prefer `--sandbox`; request
  explicit authorization before an AGY task makes irreversible or external
  changes.
- Use planning mode for analysis, discovery, and proposals. Use edit-accepting
  mode only when the user authorized the resulting repository changes.

## Delegation contract

Before invoking AGY, write a compact brief that includes:

1. The concrete objective and the exact files or inputs in scope.
2. Required constraints, prohibited actions, and the expected output format.
3. Acceptance criteria: behavior, tests, style, security, and documentation
   expectations that actually apply to the task.
4. The requested model and effort. Prefer a Flash model appropriate to the
   risk; increase effort or use a stronger model only when the task warrants
   it.

Ask for observable evidence, not just a conclusion: changed paths, commands
run, test output, assumptions, and unresolved risks. If AGY lacks a required
input, it must report the gap rather than invent a value.

## Execution

For a non-interactive task, use AGY's print/prompt mode with an explicit
model, effort, and sandbox setting. Use its structured output options when a
machine-readable handoff materially reduces ambiguity. Keep one task per
invocation unless its steps share context and failure boundaries.

Available CLI capabilities may change. Re-check `agy --help` before relying
on a flag and `agy models` before selecting a model that was not verified in
the current environment. If AGY cannot start because a sandbox blocks its
local server or log directory, do not weaken the task's permissions silently:
request the required approval or use a different permitted execution path.

## Mandatory quality gate

Do not accept AGY output until the parent agent independently performs the
checks that fit the deliverable:

- **Executable changes:** invoke `qa-test-gate` and complete its unit,
  integration, static, and smoke matrix on the final integrated tree. If the
  skill is unavailable, stop and report the missing gate instead of accepting
  AGY's test claims as a substitute.

- **Requirements:** map every acceptance criterion to direct evidence; label
  anything without evidence as unverified.
- **Code:** inspect the diff, run the relevant tests and static checks, check
  for scope creep, regressions, unsafe commands, secrets, and accidental
  generated files. Reproduce critical claims instead of trusting AGY's test
  summary.
- **Research or analysis:** verify important facts against primary sources,
  distinguish facts from inferences, and retain citations or source paths.
- **Data or structured output:** validate schema, identifiers, completeness,
  and representative edge cases against the source data.
- **Files and documents:** open or render the result when presentation
  matters; verify the requested format and that no sensitive inputs leaked.

Use a second AGY pass only as a critique, not as the sole verifier of the
first pass. The parent agent makes the acceptance decision and records the
evidence, remaining risks, and any follow-up needed.

## Completion report

Report the selected model, what AGY was asked to do, what changed or was
produced, validation actually run, and limitations. State clearly when a
result was proposed but not applied, or when validation could not run.

## Pre-delivery check

Before delivering work that involved AGY, re-read this skill and confirm:

- the delegated scope and permissions matched the user's request;
- no unsafe permission bypass or sensitive data transfer occurred;
- the applicable quality-gate checks have direct evidence; and
- the final report separates verified facts, inferences, and open risks.
