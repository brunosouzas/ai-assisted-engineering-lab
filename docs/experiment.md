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
| Requirement sent to AI | Pending |
| AI runtime and date | Pending |
| Proposal artifact or commit | Pending |
| Engineer's contract decision | Pending |
| Changed files and final commit | Pending |
| Validation command and result | Pending |
| Remaining limits | Pending |

Do not use an invented error or a fabricated AI response to make the story more dramatic. If the AI proposes the chosen contract immediately, document that outcome and show how it was checked.
