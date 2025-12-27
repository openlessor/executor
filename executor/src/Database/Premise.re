open Common;

[%%mel.raw "const { sql } = require(\"bun\")"];

type t = {
  id: string,
  name: string,
  description: string,
  updated_at: Js.Date.t,
};

let getPremise: string => Js.promise(PeriodList.Premise.t) = [%mel.raw
  {| async function(premise_id) {
  return await sql`
  SELECT * FROM premise WHERE id = ${premise_id}
  ` }
  |}
];

let getConfig = (premise_id: string): Js.promise(Config.t) => {
  getPremise(premise_id)
  |> Js.Promise.then_(premise => {
       Inventory.getInventoryList(premise_id)
       |> Js.Promise.then_(inventory => {
            let config: Config.t = {
              inventory,
              premise: Some(premise),
            };
            Js.Promise.resolve(config);
          })
     });
};
