# AI Engineer Contract Lab

A small, synthetic Mule 4 application for a reproducible exercise about AI-assisted software engineering. The repository separates an already working baseline from a later AI-assisted contract change, so observations can be checked against code and test results.

The baseline was copied from the `customer-lookup-api-fixture` in [`mulesoft-agent-test-lab`](https://github.com/brunosouzas/mulesoft-agent-test-lab). Its MIT licence is retained. No customer, company or production data is included.

## Baseline behaviour

`GET /api/customers/{customerId}` returns a synthetic customer for `CUST-001`, `400` for an invalid identifier, `404` for a valid unknown identifier and a sanitised `500` for the controlled `CUST-500` case. The application preserves or creates a correlation ID.

## Reproduce the baseline

Prerequisites: Java 17, Maven 3.9.8, and cached Mule dependencies or network access to the configured repositories. Run:

```bash
JAVA_HOME=/path/to/jdk-17 mvn -o clean package
```

Remove `-o` when the dependencies have not been cached. MUnit starts a local Mule runtime and needs access to dynamic localhost ports. The application has no external service, credential or deployment target.

On 27 September 2026, the local baseline build passed six MUnit tests with zero failures, errors or skips, and reported 60.00% application coverage. This is an observed result for that environment, not a project threshold. The tests exercise the handler directly; listener and APIKit routing are not directly covered.

## Experiment record

See [the experiment protocol](docs/experiment.md) for the prompt, engineering decision and evidence fields. Do not describe the baseline as AI-generated in this experiment. Record the actual AI proposal and the human decision before drawing conclusions for the article.
