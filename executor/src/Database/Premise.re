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
  let premise =
    getPremise(premise_id)
    ->Js.Promise.then_(premise => {
        let inventoryRows = Inventory.getInventoryList(premise_id);
        let inventory: array(InventoryItem.t) =
          Belt.Array.map(
            inventoryRows,
            Inventory.toInventoryItem,
            {
              inventory,
              premise: Some(premise),
            },
          );
        ();
      });
  ();
};
