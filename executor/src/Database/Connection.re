[%%mel.raw "const { sql } = require(\"bun\")"]
type json_items = array<{.}>

let sqlQ = ([%mel.raw {| async function() { return await sql`SELECT * FROM inventory` } |}]: unit => Js.promise<array<{.}>>)
let results = sqlQ ()|>Js.Promise.then_((values) => {
  Js.log(values)
  Js.Promise.resolve()
})
Listener.withListener("test", ~onMessage=message => {
  Js.log2("Message received:", message)
})
