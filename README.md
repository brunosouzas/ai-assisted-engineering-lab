# AI-Assisted Engineering Lab

A reusable, synthetic Mule 4 application for reproducible AI-assisted engineering articles. Each exercise has its own API contract, route prefix, Mule file, flow prefix and MUnit suite. The Maven artifact identifies the shared lab rather than the first exercise.

The initial synthetic customer lookup fixture was adapted from an earlier private lab by the same author. Its MIT licence is retained. No customer, company or production data is included.

## Customer lookup exercise

`GET /api/customer-lookup/customers/{customerId}` returns a synthetic customer for `CUST-001`. Invalid, unknown and inactive customers are business errors (`400`). A missing API endpoint returns `404`; unsupported methods, representations and media types use `405`, `406` and `415`; the controlled `CUST-500` system failure returns a sanitised `500`. Error bodies follow the shared `{ "error": { "code": number, "reason": string, "message": string } }` contract. Correlation IDs are carried in the `x-correlation-id` response header.

The engineer's decision supersedes the original AI proposal, which suggested `200` for inactive `CUST-002`. See [the experiment record](docs/experiment.md) and [the preserved AI response](docs/codex-proposal-2026-09-27.md).

## Naming for future exercises

Keep the repository and Maven artifact named `ai-assisted-engineering-lab`. Give each exercise a descriptive slug: for example, `customer-lookup-api.raml`, `customer-lookup-api.xml`, `customer-lookup-*` flows and `customer-lookup-*-parameterized-suite.xml` MUnit suites. Reserve `/api/<exercise-slug>/*` for its HTTP routes. Add another scenario with its own files and prefix instead of extending a generic `main` or `process` flow with unrelated behaviour.

## Build and test

Prerequisites: Java 17, Maven 3.9.8, and cached Mule dependencies or network access to the configured repositories. Run:

```bash
JAVA_HOME=/path/to/jdk-17 mvn -o clean package
```

Remove `-o` when the dependencies have not been cached. MUnit starts a local Mule runtime and needs access to dynamic localhost ports. The application has no external service, credential or deployment target.

The copied baseline passed six MUnit tests with 60.00% application coverage on 27 September 2026. The contract update first passed seven fixed-case tests; the current parameterized suites run six YAML cases (two success/correlation cases and four error cases) with 42.86% application coverage. These are observed results, not coverage thresholds. The suites exercise the handler directly; listener and APIKit routing are not directly covered. See [the MUnit parameterization documentation](https://docs.mulesoft.com/munit/latest/parameterized) for the YAML format.

## Experiment record

See [the experiment record](docs/experiment.md) for the prompt, proposal, engineer decision and verification. The copied baseline was not AI-generated in this experiment.
