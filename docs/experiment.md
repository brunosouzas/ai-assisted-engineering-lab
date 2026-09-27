# AI-assisted contract experiment

## Question

Which decisions remain with the engineer when an AI assistant proposes an API change?

## Starting point

The initial commit contains the existing synthetic customer lookup fixture. It is a reproducible baseline, not the output of the AI step in this experiment. Preserve its commit ID before changing code.

## Procedure

1. Record the proposed change as a short, intentionally incomplete requirement.
2. Give the AI assistant that exact requirement and the baseline repository context. Save the prompt, model/runtime, date and full proposal. Do not insert a desired answer into the prompt.
3. Have the engineer decide the contract, including status code, response body and affected tests. Record the reason and any rejected alternative.
4. Apply or amend the proposal in a separate commit. Keep the original AI proposal available for comparison.
5. Run `JAVA_HOME=/path/to/jdk-17 mvn -o clean package`. Save the command, environment, test counts and result. If a test fails, retain the first failure and the correction in the record.
6. Compare the final contract, implementation and tests. Identify what the AI proposed, what the engineer decided and what execution actually verified.

## Evidence to fill during the run

| Item | Actual observation |
|---|---|
| Baseline commit | `82eb3332c889d31e75351df58c69948d4d50fcc1` |
| Requirement sent to AI | Exact prompt in `docs/codex-proposal-2026-09-27.md` run metadata below |
| AI runtime and date | Codex CLI, `gpt-6-sol`, 2026-09-27, read-only |
| Proposal artifact or commit | `docs/codex-proposal-2026-09-27.md`; no code applied |
| Engineer's contract decision | Bruno: `404` only for a missing endpoint; business errors, including unknown or inactive customers, use `400`; system failures use `500`; apply the standard error body even in examples |
| Changed files and final commit | Pending |
| Validation command and result | Java 17 + Maven 3.9.8, offline `clean package`: seven tests, zero failures/errors/skips, `BUILD SUCCESS`; details below |
| Remaining limits | Handler-only MUnit; HTTP/APIKit status mapping was not exercised end to end |

Do not use an invented error or a fabricated AI response to make the story more dramatic. If the AI proposes the chosen contract immediately, document that outcome and show how it was checked.

## Preliminary AI proposal (preserved before the engineer decision)

Proposed prompt for the controlled run, drafted on 27 September 2026:

> Add a second synthetic customer, `CUST-002`, whose status is `INACTIVE`, to the existing Mule customer lookup API. Propose the contract and implementation change. Do not edit the repository yet.

Codex preliminary proposal in this documentation session:

> The current RAML already allows `INACTIVE` in `CustomerSummary.status`, so the smallest contract-compatible change is to return `200` with the existing response shape for `CUST-002`. Add a branch to `customer-lookup-process` that builds a deterministic synthetic summary, plus a MUnit test asserting `200`, the identifier and `INACTIVE` status. Keep the existing `404` for unknown identifiers. This proposal assumes inactive records are visible to callers. If inactivity should hide a record, the contract needs an explicit rule and a test for that policy; the model cannot infer it from the status enum.

The separate controlled run is now preserved in `docs/codex-proposal-2026-09-27.md`. It independently proposed `200` and identified inactive-customer visibility as an assumption. The engineer subsequently selected a different contract. The code change is recorded below.

## Engineer decision and implementation

Bruno defined the standard for this reusable repository and related articles: use HTTP response semantics consistently; reserve `404` for an endpoint that does not exist, return `400` for business errors, and return `500` for system failures. The shared RAML utility library defines error bodies as `{ "error": { "code": integer, "reason": string, "message": string } }`; the implementation now follows this shape. Correlation IDs remain in the response header. This decision rejects the AI proposal to return `200` for inactive `CUST-002` and also corrects the copied baseline's `404` for a valid but unknown customer.

The shared lab retains scenario-specific names (`customer-lookup-*`) and gives this API a route prefix (`/api/customer-lookup/*`). Its Maven artifact is `ai-assisted-engineering-lab`, leaving room for other exercises with distinct files, flows and route prefixes.

The first updated MUnit execution on 27 September 2026 used Java 17 and Maven 3.9.8: `mvn -o clean package` returned `BUILD SUCCESS`, seven tests, zero failures, zero errors, zero skips and 48.65% application coverage. This run preceded the route-prefix adjustment and the standard 500 fallback; a final run is recorded below. The lower coverage percentage reflects added routing/error components that the handler-only suite does not exercise directly; it is not evidence of a quality regression by itself.

## Final validation and limits

After adding the scenario-specific route prefix, the application was rebuilt on 27 September 2026 with:

```bash
JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home /Users/brunosouzas/application/apache/apache-maven-3.9.8/bin/mvn -o clean package
```

Observed result: `BUILD SUCCESS`, seven MUnit tests, zero failures, zero errors, zero skipped, and 42.86% application coverage. The tests verify the handler's success, business errors, sanitised system error, and correlation ID behaviour. They do not invoke the HTTP listener or APIKit router, so the configured `404`, `405`, `406` and `415` responses still need a separate end-to-end check. A local attempt with `mvn -o mule:run` did not start the application because Mule Maven Plugin 4.9.1 has no `run` goal; that command failure is an environment/tooling limit, not a failing application test.

The contract change from business `404` to `400` is incompatible for consumers that interpret the old status. This is an isolated, unpublished laboratory application; no production consumer was found or changed.
