# AI-Assisted Engineering Lab

A reusable, synthetic Mule 4 application for reproducible AI-assisted engineering articles. Each exercise has its own API contract, route prefix, Mule file, flow prefix and MUnit suite. The Maven artifact identifies the shared lab rather than the first exercise.

The initial synthetic customer lookup fixture was adapted from an earlier private lab by the same author. Its MIT licence is retained. No customer, company or production data is included.

## Customer lookup exercise

`GET /api/customer-lookup/customers/{customerId}` returns a synthetic customer for `CUST-001`. Invalid, unknown and inactive customers are business errors (`400`). A missing API endpoint returns `404`; unsupported methods, representations and media types use `405`, `406` and `415`; the controlled `CUST-500` system failure returns a sanitised `500`. Error bodies follow the shared `{ "error": { "code": number, "reason": string, "message": string } }` contract. Correlation IDs are carried in the `x-correlation-id` response header.

The engineer's decision supersedes the original AI proposal, which suggested `200` for inactive `CUST-002`. See [the experiment record](docs/experiment.md) and [the preserved AI response](docs/codex-proposal-2026-09-27.md).

## Order status exercise

`GET /api/order-status/orders/{orderId}` (`orderId` is `ORD-` and three digits) reads one order from a synthetic backend, the Order Store, and returns its status in the lab's shape: `orderId`, `customerId`, `status` (`RECEIVED`, `PAID`, `SHIPPED`, `DELIVERED`, `CANCELLED`), `placedAt` (UTC), `lines[]` (`productId`, `productName`, `quantity`, `lineTotal`) and `orderTotal` (`amount`, `currency`). The product names come from `GET /products/{productId}`, one call per distinct product, at most five at once. A product the Order Store does not know keeps its line with `productName: null`. The Order Store is synthetic and never reachable: MUnit plays it. Its requirements are in [docs/order-status/requirements.md](docs/order-status/requirements.md). This exercise reuses the lab's HTTP listener (`http-listener-config`, port `http.port`, a system property as before) and loads only its own properties, from `order-status.yaml`.

Most test names start with the numbers of the requirements they prove (R1 operation, R2 `orderId` rule, R4 order call, R5 product call, R6 20-line limit, R7 ids, R8 status mapping, R9 `placedAt`, R10 lines, R11 `orderTotal`, R12 unknown product, R14 correlation header, R15 to R19 the `400`, `404`, `504`, `503` and `502` cases, R20 time budget). Two have no test of their own: R3 (Order Store host, port and protocol from properties) is checked by reading `order-status.yaml` and the request config, and R21 (the Order Store is synthetic and never reachable) holds because every Order Store call is mocked by its `doc:name` and `order-store.invalid` cannot resolve. R13 (the shared error body with a fixed message) is asserted inside every error test.

Errors use the same shared body and `x-correlation-id` header as the customer lookup, with a fixed message that never carries the Order Store's own text:

| Case | Status |
| --- | --- |
| `orderId` that does not match `ORD-` and three digits | `400` |
| The Order Store does not know the order | `404` |
| The Order Store (or a product call) does not answer in time, or the request's time budget (5 s) is spent | `504` |
| The Order Store cannot be reached | `503` |
| Any other Order Store failure, an unknown `statusCode`, or an order with more than 20 lines | `502` |

Every call to the Order Store times out after 2 seconds (and fails after 1 second when it cannot connect) and a request has a 5-second budget, so a request takes at most about 7 seconds; the values are in `order-status.yaml` (`orderStore.*`, `orderStatus.*`). Any unexpected failure inside the exercise's own flows, including a defect of this application, is also answered `502`: this is accepted, not a separate mapping. There is no circuit breaker, because the requirements give no traffic figure; adding one is a decision for the repository's owner.

Observed on 19 November 2026: 31 MUnit tests for this exercise (37 in the lab with the six customer-lookup tests), all passing; application coverage 64.91% (77.78% for `order-status-api.xml`, 42.86% for `customer-lookup-api.xml`). Every test of this suite sends its request through the HTTP listener and the APIkit router, except the two time-budget tests, which need to set a deadline and call the flows directly. These are observed results, not thresholds.

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
