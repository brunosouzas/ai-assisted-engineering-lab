# ai-assisted-engineering-lab: project context

## Purpose

A reusable, synthetic Mule 4 application for reproducible AI-assisted engineering articles. Each exercise has its own API contract, route prefix, Mule file, flow prefix and MUnit suite. The Maven artifact identifies the shared lab rather than the first exercise.

## Technology

Stack: Mule 4, APIkit, MUnit, Maven, GitHub Actions
Delivery: E reference
Integration branch: `main`
Data: none
Article: `brunosouzas-content: writing/validate-ai-api-contract-change/` (also cited by `brunosouzas-content: writing/where-the-work-moves/`)

- Build: `mvn -B clean package -DskipMunitTests` (what CI runs on every pull request, `.github/workflows/ci.yml`; no credentials needed)
- Test: `mvn clean package` (MUnit; needs the MuleSoft Enterprise repository credentials in ~/.m2/settings.xml, so it runs locally before each pull request, not in CI)
- Run locally: `mvn clean package`, run the jar on a local Mule 4.9 runtime and call GET /api/customer-lookup/customers/CUST-001
- Deliver and verify: `nothing is deployed; CI green on the merge commit, and the links and paths the articles cite still work`

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

- Article repository: this repository was made for a published article and keeps what the article published (its code, OpenSpec content and structure). A change here changes the article, so every merge is Bruno's (level 2), also under a delegation.
- Board area: `mulesoft` (Azure Boards, project `brunosouzas`).
- OpenSpec: `openspec/` is scaffolded as published; it holds no change yet.
