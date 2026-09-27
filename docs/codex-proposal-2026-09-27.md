# Controlled Codex proposal — 2026-09-27

Runtime: Codex CLI `gpt-6-sol`, read-only sandbox. No files were edited and no tests were run during this proposal.

## Exact prompt

> Add a second synthetic customer, CUST-002, whose status is INACTIVE, to the existing Mule customer lookup API. Propose the contract and implementation change. Do not edit the repository yet. Explain any assumptions and which tests should verify the behaviour.

## Full final response

**Proposed contract:** `GET /api/customers/CUST-002` returns `200` with the existing `CustomerSummary` shape and `status: INACTIVE`. The RAML already permits `INACTIVE`, so this needs no new field or response code. Add a synthetic `CUST-002` example or clarify the operation description in [customer-lookup-api.raml](/Users/brunosouzas/repository-local/com/github/brunosouzas/ai-engineer-contract-lab/src/main/resources/api/customer-lookup-api.raml). This is an additive change to the documented behaviour.

**Proposed implementation:** Add a `CUST-002` branch in `customer-lookup-process` in [customer-lookup-api.xml](/Users/brunosouzas/repository-local/com/github/brunosouzas/ai-engineer-contract-lab/src/main/mule/customer-lookup-api.xml). Return a deterministic synthetic display name, segment, and timestamp that satisfy the existing type, alongside `customerId: CUST-002` and `status: INACTIVE`. Update the baseline behaviour described in [README.md](/Users/brunosouzas/repository-local/com/github/brunosouzas/ai-engineer-contract-lab/README.md) when the change is implemented.

**Assumption for the engineer to decide:** An inactive customer remains visible through lookup. The status enum permits that response but does not define visibility policy. If inactive records should be hidden, the contract should say so and the expected result for `CUST-002` would be `404` instead.

Add a MUnit case in [customer-lookup-api-suite.xml](/Users/brunosouzas/repository-local/com/github/brunosouzas/ai-engineer-contract-lab/src/test/munit/customer-lookup-api-suite.xml) asserting `200`, `CUST-002`, `INACTIVE`, the complete response fields, and correlation ID propagation. Keep the existing tests for `CUST-001`, invalid IDs, and valid unknown IDs to check that their behaviour is preserved. The current suite calls the handler directly, so an HTTP/APIKit test would be needed to verify the route end to end.

I used the MuleSoft API specification and Mule application skills to inspect this proposal. No files were edited or tests run.