# Order status exercise: requirements

A second exercise of the lab, independent of `customer-lookup`. It reads one order from a synthetic backend, the Order Store, over HTTP, and answers with its status in the lab's shape. Everything in it is synthetic: the Order Store is never reachable; MUnit plays it.

Slug: `order-status`. Routes under `/api/order-status/*`. Files: `order-status-api.raml`, `order-status-api.xml` (or what the lab's naming says), its own MUnit suite.

## Operation

`GET /api/order-status/orders/{orderId}`

| Name | Location | Type | Required | Rule |
| --- | --- | --- | --- | --- |
| orderId | path | string | Yes | `ORD-` followed by three digits (`ORD-001`) |

## The Order Store (backend)

HTTP and JSON. Host, port and protocol come from properties; the Order Store answers in about 100 ms when healthy.

| Call | Answer |
| --- | --- |
| `GET /orders/{orderId}` | `200` with the order (sample below); `404` when it does not know the order |
| `GET /products/{productId}` | `200` with `{ "productId": "...", "name": "..." }`; `404` when it does not know the product |

An order has at most 20 lines (an Order Store rule).

Sample `GET /orders/ORD-001`:

```json
{
  "id": "ORD-001",
  "customerId": "CUST-001",
  "statusCode": 3,
  "placedAtUtc": "2026-10-02T14:05:00Z",
  "currency": "EUR",
  "lines": [
    { "productId": "PRD-10", "quantity": 2, "unitPrice": 12.5 },
    { "productId": "PRD-20", "quantity": 1, "unitPrice": 7.25 }
  ]
}
```

## Mapping (Order Store to API)

| Order Store | API field | Rule |
| --- | --- | --- |
| `id` | orderId | as it is |
| `customerId` | customerId | as it is |
| `statusCode` | status | 1 `RECEIVED`, 2 `PAID`, 3 `SHIPPED`, 4 `DELIVERED`, 5 `CANCELLED`; any other value is a defect of the Order Store (`502`) |
| `placedAtUtc` | placedAt | ISO 8601 date-time, kept in UTC |
| `lines` | lines[] | one entry per line: `productId`, `productName` (from `GET /products/{productId}`), `quantity`, `lineTotal` (`quantity x unitPrice`, two decimals) |
| lines | orderTotal | the sum of `lineTotal`, two decimals, with `currency` |

A product the Order Store does not know keeps its line, with `productName: null`.

## Errors

The lab's shared error body: `{ "error": { "code": number, "reason": string, "message": string } }`, a fixed message, never the Order Store's own text; `x-correlation-id` on every response.

| Case | Status |
| --- | --- |
| `orderId` that does not match the pattern | `400` |
| the Order Store answers `404` for the order | `404` |
| the Order Store does not answer in time | `504` |
| the Order Store cannot be reached | `503` |
| any other Order Store failure, or an unknown `statusCode` | `502` |

## Not decided here

The response time callers can expect, and whether a slow Order Store needs more than a timeout, are left to the implementation, which states its decision.
