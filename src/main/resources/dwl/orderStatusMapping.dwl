%dw 2.0

// Pure functions of the order-status exercise (DW-5), typed (DW-6). The Order Store's order and the product names
// come in as parameters; nothing here reads vars, attributes or properties.

// The Order Store's numeric status code as the API's status. Only a number is a code: a literal pattern would also
// accept the string "3", so the type is checked first. An unknown code gives null; the flow answers 502 (DW-7).
fun statusName(code: Any): String | Null = code match {
  case n is Number -> n match {
    case 1 -> "RECEIVED"
    case 2 -> "PAID"
    case 3 -> "SHIPPED"
    case 4 -> "DELIVERED"
    case 5 -> "CANCELLED"
    else -> null
  }
  else -> null
}

// Money is rounded half up to two decimals with arithmetic, never through a string (DW-8).
fun roundMoney(value: Number): Number = round(value * 100) / 100

fun lineTotal(quantity: Number, unitPrice: Number): Number = roundMoney(quantity * unitPrice)

// The Order Store sends UTC date-times; the API keeps them in UTC with an explicit format (DW-8). Milliseconds are
// kept when the Order Store sends them (".250"), and left out when they are zero.
fun toUtcIsoString(value: String): String = do {
  var utc = (value as DateTime) >> "UTC"
  ---
  if ((utc.milliseconds default 0) == 0)
    utc as String {format: "yyyy-MM-dd'T'HH:mm:ss'Z'"}
  else
    utc as String {format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"}
}

// The distinct product ids of an order, in order of appearance: each product is read once.
fun distinctProductIds(lines: Array): Array<String> =
  (lines map ((line) -> line.productId as String)) distinctBy ((id) -> id)

// productNames is an object keyed by product id; a product the Order Store does not know has a null name.
fun toLine(line: Object, productNames: Object): Object = do {
  var quantity = line.quantity as Number
  ---
  {
    productId: line.productId as String,
    productName: productNames[(line.productId as String)] default null,
    quantity: quantity,
    lineTotal: lineTotal(quantity, line.unitPrice as Number)
  }
}

fun toResponse(order: Object, productNames: Object): Object = do {
  var lines = (order.lines default []) map ((line) -> toLine(line, productNames))
  ---
  {
    orderId: order.id as String,
    customerId: order.customerId as String,
    status: statusName(order.statusCode),
    placedAt: toUtcIsoString(order.placedAtUtc as String),
    lines: lines,
    orderTotal: {
      amount: roundMoney(sum(lines map ((l) -> l.lineTotal))),
      currency: order.currency as String
    }
  }
}
