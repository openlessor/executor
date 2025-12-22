[%%mel.raw "const { sql } = require(\"bun\")"];
type json_items = array({.});

let sqlQ: unit => Js.promise(array({.})) = [%mel.raw
  {| async function() { return await sql`SELECT * FROM inventory` } |}
];
let results =
  sqlQ()
  |> Js.Promise.then_(values => {
       Js.log(values);
       Js.Promise.resolve();
     });
Bus.withListener("test", ~onMessage=message => {
  Js.log2("Message received:", message)
});
