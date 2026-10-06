# ai-assisted-engineering-lab: project context

## Purpose

A reusable, synthetic Mule 4 application for reproducible AI-assisted engineering articles. Each exercise has its own API contract, route prefix, Mule file, flow prefix and MUnit suite. The Maven artifact identifies the shared lab rather than the first exercise.

## Technology declarations

- `app.runtime = 4.9.15` — [pom.xml](pom.xml).
- `mule.maven.plugin.version = 4.9.1` — [pom.xml](pom.xml).
- `munit.version = 3.7.1` — [pom.xml](pom.xml).
- `Declared minimum Mule runtime 4.9.15` — [mule-artifact.json](mule-artifact.json).

These are source declarations, not evidence of installed runtimes. Maven properties may describe build/test dependencies rather than supported runtime minima; unresolved expressions remain inherited until verified.

## Layout and operation sources

Top-level source/documentation directories: `docs`, `src`.

- [README.md](README.md).
- [mule-artifact.json](mule-artifact.json).
- [pom.xml](pom.xml).

GitHub default branch inspected on 2026-10-06: `main`. Release bases are defined by the project sources, separately from that setting. Build/publish commands mentioned by those sources are context, not authorization.

## Project rules

Before planning, reviewing or changing this project, read [the applicable project rules](rules/README.md).
