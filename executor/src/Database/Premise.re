open Common;

[%%mel.raw "const { sql } = require(\"bun\")"];

type t = {
  id: string,
  name: string,
  description: string,
  updated_at: Js.Date.t,
};

let getPremise = (premise_id: string): Js.Promise.t(PeriodList.Premise.t) => {
  [%mel.raw
    {| async function(premise_id) {
    return await sql`
    SELECT * FROM premise WHERE id = ${premise_id}
    `
    } |}
  ](premise_id);
};

let getConfig = (premise_id: string): Config.t => {
  let premise = getPremise(premise_id);
  let inventory = Inventory.getInventoryList(premise_id);
  let config: Config.t = {
    inventory,
    premise: Some(premise),
  };
  config;
};
