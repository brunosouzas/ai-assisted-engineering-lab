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
| Engineer's contract decision | Pending |
| Changed files and final commit | Pending |
| Validation command and result | Pending |
| Remaining limits | Pending |

Do not use an invented error or a fabricated AI response to make the story more dramatic. If the AI proposes the chosen contract immediately, document that outcome and show how it was checked.

## Preliminary AI proposal (preserved before the engineer decision)

Proposed prompt for the controlled run, drafted on 27 September 2026:

> Add a second synthetic customer, `CUST-002`, whose status is `INACTIVE`, to the existing Mule customer lookup API. Propose the contract and implementation change. Do not edit the repository yet.

Codex preliminary proposal in this documentation session:

> The current RAML already allows `INACTIVE` in `CustomerSummary.status`, so the smallest contract-compatible change is to return `200` with the existing response shape for `CUST-002`. Add a branch to `customer-lookup-process` that builds a deterministic synthetic summary, plus a MUnit test asserting `200`, the identifier and `INACTIVE` status. Keep the existing `404` for unknown identifiers. This proposal assumes inactive records are visible to callers. If inactivity should hide a record, the contract needs an explicit rule and a test for that policy; the model cannot infer it from the status enum.

The separate controlled run is now preserved in `docs/codex-proposal-2026-09-27.md`. It independently proposed `200` and identified inactive-customer visibility as an assumption. The next step is to record the engineer's choice before editing code.
