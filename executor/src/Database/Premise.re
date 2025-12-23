[%%mel.raw "const { sql } = require(\"bun\")"];

type t = {
  id: string,
  name: string,
  description: string,
  updated_at: Js.Date.t,
};

let getPremise: string => PeriodList.Premise.t = [%mel.raw
  {| async function() {
  return await sql`
  SELECT * FROM premise WHERE id = ${premise_id}
  ` }
  |}
];

let getConfig = (premise_id: string): Config.t => {
  let premise = getPremise(premise_id);
  let inventory = Inventory.getInventoryList(premise_id);
  let config: Config.t = {
    inventory,
    premise: Some(premise),
  };
  config;
};
