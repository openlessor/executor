[%%mel.raw "const { sql } = require(\"bun\")"];

type t = {
  id: string,
  name: string,
  description: string,
  updated_at: Js.Date.t,
};

let getPremise: string => Js.promise(t) = [%mel.raw
  {| async function() {
  return await sql`
  SELECT * FROM premise WHERE id = ${premise_id}
  `
  |}
];

let getConfig = (premise_id: string): Js.promise(Config.t) => {
  let premise = Js.Nullable.toOption(getPremise(premise_id))->Option.get;
  let inventoryRows = await;
  Inventory.getInventoryList(~client, premise_id);
  let inventory: array(ExecutorUi.InventoryItem.t) =
    Belt.Array.map(
      inventoryRows,
      Inventory.toInventoryItem,
      {
        inventory,
        premise: Some(premise),
      },
    );
  ();
};
